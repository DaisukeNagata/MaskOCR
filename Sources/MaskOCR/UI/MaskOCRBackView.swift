//
//  MaskOCRBackView..swift
//  
//
//  Created by 永田大祐 on 2021/07/18.
//

import SwiftUI

@available(iOS 14.0, *)
public struct MaskOCRBackView: UIViewRepresentable {
    var views: UIView?

    public init(frame: CGRect, views: UIView) {
        self.views = views
        self.views?.frame = frame
    }

    public func makeUIView(context: Context) -> UIView {
        return views ?? UIView()
    }

    public func updateUIView(_ uiView: UIView, context: Context) {
    }
}
