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

    public var maskModel: MaskOCRLayerModel?
    public var mLViewModel = MaskOCRLayerViewModel()
    public var gestureObject: MaskOCRGestureViewModel
    var maskOCRGestureActionViewModel: MaskOCRGestureActionViewModel?
    var mv = MaskOCRGestureViewModel()
    private var originCenter: CGFloat = 0


    public init(gestureObject: MaskOCRGestureViewModel,
                imageView: UIImageView,
                maskGestureView: UIView) {
        self.gestureObject = gestureObject
        maskModel = MaskOCRLayerModel(image: imageView.image,
                                      imageView: imageView,
                                      defaltImageView: imageView,
                                      maskGestureView: maskGestureView)
        super.init()
        maskOCRGestureActionViewModel = MaskOCRGestureActionViewModel(viewModel: gestureObject, modelView: self)

    }

    public func designInit() {
        imageResize()
        frameResize(images: maskModel?.imageView.image, rect: maskModel?.imageView.frame ?? CGRect())
    }

    public func frameResize(images: UIImage?, rect: CGRect) {
        guard let model = maskModel, let images = images else { return }
        var ipadCheck: CGFloat = 1
        if UIDevice.current.userInterfaceIdiom == .pad {
            ipadCheck = 0.9
        }
        model.imageView.frame = rect

        let imageSize = AVMakeRect(aspectRatio: images.size, insideRect: model.imageView.bounds)
        model.imageView.image = model.image
        model.imageView.frame.size.width = imageSize.size.width*ipadCheck
        model.imageView.frame.size.height = imageSize.size.height*ipadCheck
        model.imageView.center = CGPoint(x: rect.width/2, y: rect.origin.y + rect.height/2)

        maskModel?.defaltImageView.image = maskModel?.imageView.image

        gestureObject.lineView.frame = CGRect(x: 0,
                                              y: 0,
                                              width: imageSize.width*ipadCheck,
                                              height: imageSize.height*ipadCheck)
        gestureObject.cALayerView.frame = gestureObject.lineView.frame
        gestureObject.cALayerView.tori(gestureObject)
        maskModel?.imageView.layer.addSublayer(gestureObject.cALayerView.hollowTargetLayer ?? CALayer())
        maskModel?.imageView.addSubview(gestureObject.cALayerView)
        maskModel?.imageView.addSubview(gestureObject.lineView)
        maskModel?.maskGestureView?.addSubview(maskModel?.imageView ?? UIImageView())
    }

    private func imageResize() {
        originCenter = (maskModel?.defaltImageView.frame.height ?? 0)/2 + (maskModel?.defaltImageView.frame.origin.y ?? 0)
        maskModel?.imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
        maskModel?.imageView.center = CGPoint(x:(maskModel?.defaltImageView.frame.width ?? 0) / 2, y: originCenter)
        maskModel?.imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
        maskModel?.imageView.center = CGPoint(x:(maskModel?.defaltImageView.frame.width ?? 0) / 2, y: originCenter)
        maskModel?.imageView.layer.mask?.removeFromSuperlayer()
        maskModel?.imageView.frame = maskModel?.defaltImageView.frame ?? CGRect()
        maskModel?.imageView.image = maskModel?.image
    }

}
