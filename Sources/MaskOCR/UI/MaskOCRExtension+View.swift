//
//  MaskOCRExtension+View.swift
//
//
//  Created by 永田大祐 on 2021/07/18.
//

import UIKit
import SwiftUI

@available(iOS 14.0, *)
extension View {
    public func isHidden(_ bool: Bool) -> some View {
        modifier(MaskOCRHiddenModifier(isHidden: bool))
    }
}

extension UIImage {
    func resize(size: CGSize) -> UIImage? {
        let widthRatio = size.width / size.width
        let heightRatio = size.height / size.height
        let ratio = widthRatio < heightRatio ? widthRatio : heightRatio
        
        let resizedSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        
        UIGraphicsBeginImageContext(resizedSize)
        draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}
