//
//  MaskOCRLayerModelView.swift
//
//
//  Created by 永田大祐 on 2021/07/18.
//

import AVFoundation
import UIKit
import MobileCoreServices

@available(iOS 14.0, *)
public final class MaskOCRLayerModelView: NSObject {

    var panGesture = UIPanGestureRecognizer()
    public var mv: MaskOCRGestureViewModel?
    public var maskModel: MaskOCRLayerModel?
    public var mLViewModel: MaskOCRLayerViewModel?
    private var originCenter: CGFloat = 0
    private var gestureObject: MaskOCRGestureViewModel
    public init(gestureObject: MaskOCRGestureViewModel,
                imageView: UIImageView,
                maskGestureView: UIView) {
        self.gestureObject = gestureObject
        mLViewModel = MaskOCRLayerViewModel()
        maskModel = MaskOCRLayerModel(image: imageView.image,
                                      imageView: imageView,
                                      defaltImageView: imageView,
                                      maskGestureView: maskGestureView)
        super.init()
        frameResize(images: imageView.image, rect: imageView.frame)
        mv = MaskOCRGestureViewModel(mo: mLViewModel ?? MaskOCRLayerViewModel(), modelView: self)
        originCenter = (maskModel?.defaltImageView.frame.height ?? 0)/2 + (maskModel?.defaltImageView.frame.origin.y ?? 0)

        panGesture.delegate = self
    }

    public func designInit() {
        originCenter = (maskModel?.defaltImageView.frame.height ?? 0)/2 + (maskModel?.defaltImageView.frame.origin.y ?? 0)
        maskModel?.imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
        maskModel?.imageView.center = CGPoint(x:(maskModel?.defaltImageView.frame.width ?? 0) / 2,
                                              y: originCenter)
        imageResize()

        frameResize(images: maskModel?.imageView.image, rect: maskModel?.imageView.frame ?? CGRect())

    }

    public func frameResize(images: UIImage?, rect: CGRect) {
        guard let model = maskModel, let images = images else { return }
        maskModel?.imageView.frame = rect
        
        let imageSize = AVMakeRect(aspectRatio: images.size, insideRect: model.imageView.bounds)
        model.imageView.image = maskModel?.image
        model.imageView.frame.size = imageSize.size
        model.imageView.center = CGPoint(x: rect.width/2, y: rect.origin.y + rect.height/2)

        maskModel?.defaltImageView.image = maskModel?.imageView.image
        let orginY = Int(maskModel?.defaltImageView.frame.size.height ?? 0) - Int(maskModel?.imageView.image?.size.height ?? 0)
        gestureObject.lineView?.frame = CGRect(x: 0, y: CGFloat(orginY),
                                               width: maskModel?.defaltImageView.frame.width ?? 0,
                                               height: maskModel?.defaltImageView.image?.size.height ?? 0)
        gestureObject.cALayerView?.tori(gestureObject)
        maskModel?.imageView.layer.addSublayer(gestureObject.cALayerView?.hollowTargetLayer ?? CALayer())
        maskModel?.imageView.addSubview(gestureObject.cALayerView ?? UIView())
        maskModel?.imageView.addSubview(gestureObject.lineView ?? UIImageView())
        
    }

    func imageResize() {
        maskModel?.imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
        maskModel?.imageView.center = CGPoint(x:(maskModel?.defaltImageView.frame.width ?? 0) / 2,
                                              y: originCenter)
        maskModel?.imageView.layer.mask?.removeFromSuperlayer()
        maskModel?.imageView.frame = maskModel?.defaltImageView.frame ?? CGRect()
        maskModel?.imageView.image = maskModel?.image
    }

}

// MARK: UIPanGestureRecognizer

@available(iOS 14.0, *)
extension MaskOCRLayerModelView: UIGestureRecognizerDelegate {

    @objc func panTapped(sender:UIPanGestureRecognizer) {
        let position: CGPoint = sender.location(in: gestureObject.cALayerView)
        DispatchQueue.main.async { [self] in
            gestureObject.endFrame = gestureObject.lineView?.frame ?? CGRect()
            gestureObject.endPoint = gestureObject.lineView?.frame.origin ?? CGPoint()
            gestureObject.cALayerView?.tori(gestureObject)
        }
        switch sender.state {
        case .ended:
            gestureObject.endPoint = gestureObject.lineView?.frame.origin ?? CGPoint()
            gestureObject.endFrame = gestureObject.lineView?.frame ?? CGRect()
        case .began:
            gestureObject.touchFlag = gestureObject.cropEdgeForPoint(point: gestureObject.framePoint)
        case .changed:
            self.gestureObject.updatePoint(gestureObject.lineView?.frame.height ?? 0,
                                           point: position,touchFlag: gestureObject.touchFlag)
        default: break
        }
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let position: CGPoint = touch.location(in: maskModel?.imageView)
        gestureObject.framePoint = position
        return true
    }

}
