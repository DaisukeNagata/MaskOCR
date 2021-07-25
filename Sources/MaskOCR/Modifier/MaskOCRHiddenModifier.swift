//
//  MaskOCRHiddenModifier.swift
//
//
//  Created by 永田大祐 on 2021/07/18.
//

import SwiftUI

@available(iOS 14.0.0, *)
public struct MaskOCRHiddenModifier: ViewModifier {

    public let isHidden: Bool

    public func body(content: Content) -> some View {
        Group {
            if isHidden {
                content.hidden()
            } else {
                content
            }
        }
    }
}
