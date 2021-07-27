//
//  MaskOCRDesign.swift
//  OCRMaskCamera
//
//  Created by 永田大祐 on 2021/07/18.
//

import UIKit
import MaskOCR

final class MaskOCRDesign: ObservableObject {

    @Published var maskView: MaskOCRLayerModelView?
    let gestureObject = MaskOCRGestureViewModel()

    func trim() {
        guard let imageView = maskView?.maskModel?.imageView else { return }
        maskView?.mLViewModel.lockImageMask(imageView: imageView, windowFrameView: gestureObject.lineView)
    }

    func desginInit() {
        maskView?.designInit()
    }

    func didChangeCommponed(image: UIImage) {
        maskView?.maskModel?.image = image
        maskView?.frameResize(images: image, rect: UIScreen.main.bounds)
    }

    func layerModelView() {
        
        maskView = MaskOCRLayerModelView(gestureObject: gestureObject,
                                           imageView: UIImageView(frame: CGRect(x: 0,
                                                                                y: 0,
                                                                                width: UIScreen.main.bounds.width,
                                                                                height: UIScreen.main.bounds.height)),
                                           maskGestureView: UIView(frame: UIScreen.main.bounds))
        maskView?.designInit()
    }
}
