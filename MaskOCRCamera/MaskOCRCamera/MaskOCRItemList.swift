//
//  MaskeOCRItemList.swift
//  OCRMaskCamera
//
//  Created by 永田大祐 on 2021/07/18.
//

import SwiftUI
import MaskOCR

struct MaskeOCRItemList: View {

    @State private var viewItem: ViewItem
    @State private var isPresentedSubView = false
    @State private var maskViewDesign: MaskOCRDesign
    @ObservedObject private var avFoundationVM: MaskOCRFunction

    init (viewItem: ViewItem, avFoundationVM: MaskOCRFunction, maskViewDesign: MaskOCRDesign) {
        self.viewItem = viewItem
        self.maskViewDesign = maskViewDesign
        self.avFoundationVM = avFoundationVM
    }

    var body: some View {
        VStack {
            viewSet()
        }
        .onAppear {
            avFoundationVM.startSession()
        }
        .onDisappear {
            avFoundationVM.endSession()
        }
        .sheet(isPresented: $isPresentedSubView) {
            if !avFoundationVM.setText().isEmpty {
                SubView(title: avFoundationVM.setText())
            }
        }
    }

    private func viewSet() -> some View {
        HStack {
            switch viewItem.id {
            case .trim:
                Button(action: {
                    maskViewDesign.trim()
                }) {
                    Text(viewItem.title).frame(width: 50, height: 50, alignment: .center)
                }
                Spacer()
            case .image:
                Button(action: {
                    if avFoundationVM.previewLayer.isHidden {
                        avFoundationVM.initSet()
                        maskViewDesign.desginInit()
                    } else {
                        avFoundationVM.takePhotos()
                    }
                }) {
                    viewItem.image?
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 50, height: 50, alignment: .center)
                }
                .background(Color.white)
            case .ocr:
                Spacer()
                Button(action: {
                    guard let image = maskViewDesign.maskView?.maskModel?.imageView.image else { return }
                    avFoundationVM.process(image: image)
                    isPresentedSubView.toggle()
                }) {
                    Text(viewItem.title).frame(width: 50, height: 50, alignment: .center)
                }
            }
        }
        .padding(.leading)
        .padding(.trailing)
        .padding(.top)
    }
}

struct SubView: View {

    @State var title: String
    @State var copy: String = ""

    var body: some View {
        VStack {
            Text(title+copy)
                .onTapGesture(count: 2) {
                    UIPasteboard.general.string = title
                    copy = "\n I copied it."
                }
        }
    }
}
