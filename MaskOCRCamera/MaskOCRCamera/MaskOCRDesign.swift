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

    init() {
        maskView?.gestureObject.cALayerView.borderWidth = 1
        maskView?.gestureObject.cALayerView.opacity = 0.7
    }

    func trim() {
        guard let imageView = maskView?.maskModel?.imageView else { return }
        maskView?.mLViewModel.lockImageMask(imageView: imageView, windowFrameView: maskView?.gestureObject.lineView ?? UIImageView(), boaderSize: 1)
        maskView?.maskOCRGestureActionViewModel = nil
        maskView = nil
    }

    func desginInit() {
        layerModelView()
    }

    func didChangeCommponed(image: UIImage) {
        maskView?.maskModel?.image = image
        maskView?.frameResize(images: image, rect: UIScreen.main.bounds)
    }

    private func layerModelView() {

        maskView = MaskOCRLayerModelView(gestureObject: maskView?.gestureObject ?? MaskOCRGestureViewModel(),
                                           imageView: UIImageView(frame: CGRect(x: 0,
                                                                                y: 0,
                                                                                width: UIScreen.main.bounds.width,
                                                                                height: UIScreen.main.bounds.height)),
                                           maskGestureView: UIView(frame: UIScreen.main.bounds))
        maskView?.designInit()
    }
}
