//
//  ContentView.swift
//  MaskedOCRCamera
//
//  Created by 永田大祐 on 2021/07/18.
//

import SwiftUI
import MaskOCR

enum ViewItemCount: Int {
    case trim = 0
    case image = 1
    case ocr = 2
}

struct ViewItem: Identifiable {

    var title: String
    var image: Image?
    var id: ViewItemCount

    init (title: String,
          image: Image?,
          id: ViewItemCount) {

        self.title = title
        self.image = image ?? Image.init("")
        self.id = id
    }
}

struct ContentView: View {

    @ObservedObject var maskViewDesign = MaskOCRDesign()
    @ObservedObject var ocrMask = MaskOCRFunction()

    private let viewItem = [
        ViewItem(title: "Trim",
                 image: nil,
                 id: .trim),
        ViewItem(title: "",
                 image: Image(systemName: "camera.circle.fill"),
                 id: .image),
        ViewItem(title: "OCR",
                 image: nil,
                 id: .ocr)
    ]

    var body: some View {
        VStack {
            ZStack {
                ocrMask.backView?
                    .frame(maxHeight: .infinity)
                    .isHidden(ocrMask.previewLayer.isHidden == false ? true : false)
                ZStack {
                    MaskOCRCALayerView(caLayer: ocrMask.previewLayer)
                        .frame(maxHeight: .infinity)
                        .isHidden(ocrMask.previewLayer.isHidden == false ? false : true)
                }
            }
            .edgesIgnoringSafeArea(.all)

            MaskeOCRView(viewItem) { v in
                MaskeOCRItemList(viewItem: v,
                             avFoundationVM: ocrMask,
                             maskViewDesign: maskViewDesign)
            }
            .padding()
        }.onAppear {
            setting()
        }
    }

    private func setting() {
        maskViewDesign.layerModelView()
        ocrMask.setText(st: "[a-z-A-Z-0-9- -@-.-]")
        ocrMask.changeExecution = { image in
            DispatchQueue.main.async { [self] in
                maskViewDesign.didChangeCommponed(image: image)
                ocrMask.backView = MaskOCRBackView(frame: UIScreen.main.bounds,
                                                   views: maskViewDesign.maskView?.maskModel?.maskGestureView ?? UIView())
                ocrMask.previewLayer.isHidden = true
            }
        }
    }

    private func process() {
        guard let image = maskViewDesign.maskView?.maskModel?.imageView.image else { return }
        ocrMask.process(image: image)
    }

    private func trim() {
        maskViewDesign.trim()
    }

    private func desginInit() {
        maskViewDesign.desginInit()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
