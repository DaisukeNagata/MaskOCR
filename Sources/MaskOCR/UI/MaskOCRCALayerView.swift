//
//  MaskOCRALayerView.swift
//  
//
//  Created by 永田大祐 on 2021/07/18.
//

import SwiftUI

@available(iOS 14.0, *)
public struct MaskOCRCALayerView: UIViewControllerRepresentable {

    public var caLayer: CALayer

    public init(caLayer: CALayer) {
        self.caLayer = caLayer
    }

    public func makeUIViewController(context: UIViewControllerRepresentableContext<MaskOCRCALayerView>) -> UIViewController {
        let viewController = UIViewController()
        viewController.view.layer.addSublayer(caLayer)
        caLayer.frame = viewController.view.layer.frame
        return viewController
    }

    public func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<MaskOCRCALayerView>) {
        caLayer.frame = uiViewController.view.layer.frame
    }
}
