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

    public func lockImageMask(imageView: UIImageView, windowFrameView: UIView, boaderSize: CGFloat) {
        let rect = CGRect(x: windowFrameView.frame.origin.x+boaderSize,
                          y: windowFrameView.frame.origin.y+boaderSize,
                          width: windowFrameView.frame.width-boaderSize,
                          height: windowFrameView.frame.height-boaderSize)
        guard let image = imageView.image?.resize(size: rect.size) else { return }
        let layer = CALayer()
        layer.contents = image.cgImage
        layer.contentsScale = image.scale
        layer.frame = rect
        windowFrameView.removeFromSuperview()
        imageView.layer.mask = layer
        getScreenShot(imageView)
    }

    private func getScreenShot(_ imageView: UIImageView)  {
        let rect = imageView.frame
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        imageView.layer.render(in: context)
        let capturedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        imageView.image = capturedImage
    }
}
