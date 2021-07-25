//
//  MaskOCRExtension+View.swift
//  
//
//  Created by 永田大祐 on 2021/07/18.
//

import SwiftUI

@available(iOS 14.0, *)
extension View {
    public func isHidden(_ bool: Bool) -> some View {
        modifier(MaskOCRHiddenModifier(isHidden: bool))
    }
}
