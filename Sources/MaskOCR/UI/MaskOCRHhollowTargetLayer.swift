//
//  MaskOCRHhollowTargetLayer.swift
//  SampleFocus
//
//  Created by 永田大祐 on 2018/06/30.
//  Copyright © 2018年 永田大祐. All rights reserved.
//

import UIKit

@available(iOS 14.0.0, *)
final public class MaskOCRHhollowTargetLayer: UIView {

    var hollowTargetLayer: CALayer?

    private var path:  UIBezierPath?
    private var maskLayer: CAShapeLayer?

    public override init(frame: CGRect) {
        super.init(frame: .zero)

        self.frame = UIScreen.main.bounds
        self.frame.size.height = UIScreen.main.bounds.height

        hollowTargetLayer = CALayer()
        maskLayer = CAShapeLayer()
        path = UIBezierPath()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public func tori(_ gesture: MaskOCRGestureViewModel){
        guard let hollowTargetLayer = hollowTargetLayer,
                let maskLayer = maskLayer
            else { return }

        gesture.lineView?.layer.borderWidth = 1
        gesture.lineView?.layer.borderColor = UIColor.white.cgColor

        hollowTargetLayer.bounds = self.bounds
        hollowTargetLayer.frame.size.height = UIScreen.main.bounds.height
        hollowTargetLayer.position = CGPoint(
            x: self.bounds.width / 2.0,
            y: self.bounds.height / 2.0
        )

        hollowTargetLayer.backgroundColor = UIColor.black.cgColor
        hollowTargetLayer.opacity = 0.7

        maskLayer.bounds = hollowTargetLayer.bounds

        path = UIBezierPath.init(rect: gesture.lineView?.frame ?? CGRect())
        path?.append(UIBezierPath(rect: maskLayer.bounds))

        maskLayer.fillColor = UIColor.black.cgColor
        maskLayer.path = path?.cgPath
        maskLayer.position = CGPoint(
            x: hollowTargetLayer.bounds.width / 2.0,
            y: (hollowTargetLayer.bounds.height / 2.0)
        )

        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        hollowTargetLayer.mask = maskLayer
    }
}
