//
//  MaskOCRGestureViewModel.swift
//  SampleFocus
//
//  Created by 永田大祐 on 2018/06/30.
//  Copyright © 2018年 永田大祐. All rights reserved.
//

import UIKit

@available(iOS 14.0.0, *)
final public class MaskOCRGestureViewModel: NSObject {

    public enum TouchFlag {
        case touchTopLeft
        case touchTopRight
        case touchSideLeft
        case touchTop
        case touchDown
        case touchBottomLeft
        case touchBottomRight
        case touchSideRight
        case touchNone
    }

    var framePoint  = CGPoint()
    var endPoint = CGPoint()
    var endFrame = CGRect()
    var touchFlag = TouchFlag.touchBottomRight
    var cALayerView: MaskOCRHhollowTargetLayer?
    var lineView: UIImageView?

    init(lineView: UIImageView){
        cALayerView = MaskOCRHhollowTargetLayer()
        self.lineView = lineView
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var mLViewModel: MaskOCRLayerViewModel?
    public var modelView: MaskOCRLayerModelView?
    public init(mo: MaskOCRLayerViewModel, modelView: MaskOCRLayerModelView?) {
        super.init()
        self.modelView = modelView
        mLViewModel = mo
        desgin(mo: mo)

    }

    public func cropEdgeForPoint(point: CGPoint) -> TouchFlag {
        //タップした領域を取得
        guard let rect = lineView?.frame else { return .touchNone}
        var topLeftRect: CGRect = rect
        topLeftRect.size.height = CGFloat(64)
        topLeftRect.size.width = CGFloat(64)

        if topLeftRect.contains(point) {
            return TouchFlag.touchTopLeft
        }

        var topRightRect = topLeftRect
        topRightRect.origin.x = rect.maxX - CGFloat(64)
        if topRightRect.contains(point) {
            return TouchFlag.touchTopRight
        }

        var bottomLeftRect = topLeftRect
        bottomLeftRect.origin.y = rect.maxY - CGFloat(64)
        if bottomLeftRect.contains(point) {
            return TouchFlag.touchBottomLeft
        }

        var bottomRightRect = topRightRect
        bottomRightRect.origin.y = bottomLeftRect.origin.y
        if bottomRightRect.contains(point) {
            return TouchFlag.touchBottomRight
        }

        var topRect = rect
        topRect.size.height = CGFloat(64)
        if topRect.contains(point) {
            return TouchFlag.touchTop
        }

        var bottomRect = rect
        bottomRect.origin.y = rect.maxY - CGFloat(64)
        if bottomRect.contains(point) {
            return TouchFlag.touchDown
        }

        var leftRect = rect
        leftRect.size.width = CGFloat(64)
        if leftRect.contains(point) {
            return TouchFlag.touchSideLeft
        }

        var rightRect = rect
        rightRect.origin.x = rect.maxX - CGFloat(64)
        if rightRect.contains(point) {
            return TouchFlag.touchSideRight
        }
        return TouchFlag.touchNone
    }
    //タップされた領域からMaskするViewのサイズ、座標計算
    func updatePoint(_ screenWidth: CGFloat, point: CGPoint, touchFlag: TouchFlag) {
        guard let lineDashView = lineView else { return }
        switch touchFlag {
        case .touchNone: break
        case .touchSideRight:
            lineDashView.frame.origin.x = point.x
            lineDashView.frame.size.width = -point.x + endFrame.minX
        case .touchBottomRight:
            lineDashView.frame.origin.x = point.x
            lineDashView.frame.size.width = -point.x + endFrame.minX
            lineDashView.frame.size.height = -point.y + endPoint.y
            lineDashView.frame.origin.y = endPoint.y
        case .touchBottomLeft:
            lineDashView.frame.origin.x = point.x
            lineDashView.frame.size.width = -point.x + endFrame.maxX
            lineDashView.frame.size.height = -point.y + endPoint.y
            lineDashView.frame.origin.y = endPoint.y
        case .touchTop:
            lineDashView.frame.origin.y = point.y
            lineDashView.frame.size.height = -point.y + endFrame.maxY
        case .touchDown:
            lineDashView.frame.size.height = -point.y + endPoint.y
            lineDashView.frame.origin.y = endPoint.y
        case .touchSideLeft:
            lineDashView.frame.origin.x = point.x
            lineDashView.frame.size.width = -point.x + endFrame.maxX
        case .touchTopRight:
            lineDashView.frame.origin.x = point.x
            lineDashView.frame.size.width = -point.x + endFrame.minX
            lineDashView.frame.origin.y = point.y
            lineDashView.frame.size.height =  -point.y + endFrame.maxY
        case .touchTopLeft:
            lineDashView.frame.origin.x = point.x
            lineDashView.frame.size.width = -point.x + endFrame.maxX
            lineDashView.frame.origin.y = point.y
            lineDashView.frame.size.height =  -point.y + endFrame.maxY
        }
    }

    @objc private func panTapped(sender: UIPanGestureRecognizer) { modelView?.panTapped(sender: sender) }

    private func desgin(mo: MaskOCRLayerViewModel) {
        mLViewModel = mo
        guard let modelView = modelView, let imageView = modelView.maskModel?.imageView else { return }
        modelView.maskModel?.maskGestureView?.addSubview(imageView)
        modelView.panGesture = UIPanGestureRecognizer(target: self, action:#selector(panTapped))
        modelView.maskModel?.maskGestureView?.addGestureRecognizer(modelView.panGesture)
    }
}
