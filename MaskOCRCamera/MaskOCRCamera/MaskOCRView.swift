//
//  MaskeOCRView.swift
//  OCRMaskCamera
//
//  Created by 永田大祐 on 2021/07/18.
//

import SwiftUI

struct MaskeOCRView<Data, Content>: View where Data: RandomAccessCollection, Content: View, Data.Element: Identifiable {

    private let data: [Data.Element]
    private let content: (Data.Element) -> Content

    init(_ data: Data,
         content: @escaping(Data.Element) -> Content) {
        
        self.data = data.map { $0 }
        self.content = content
    }

    var body: some View {
        HStack {
            ForEach(data[0..<data.count].indices, id: \.self) { index in
                content(data[index])
            }
        }
    }
}
