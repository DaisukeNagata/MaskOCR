//
//  MaskOCRLayerViewModel.swift
//
//
//  Created by 永田大祐 on 2021/07/18.
//

import UIKit
import AVFoundation
import MobileCoreServices

@available(iOS 14.0, *)
public class MaskOCRLayerViewModel: NSObject {

    public func lockImageMask(imageView: UIImageView, windowFrameView: UIView) {
        guard let image = imageView.image else { return }

        let layer = CALayer()
        layer.contents = image.cgImage
        layer.contentsScale = image.scale
        layer.frame = windowFrameView.frame
        windowFrameView.removeFromSuperview()
        imageView.layer.mask = layer
        getScreenShot(imageView)
    }

    private func getScreenShot(_ imageView: UIImageView)  {
        let rect = imageView.bounds
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        imageView.layer.render(in: context)
        let capturedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        imageView.image = capturedImage
    }
}
