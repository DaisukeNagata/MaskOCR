//
//  MaskedOCRGestureViewModel.swift
//
//
//  Created by 永田大祐 on 2021/07/18.
//

import UIKit

@available(iOS 14.0, *)
public class MaskedOCRGestureViewModel: NSObject {

    public var viewModel: MaskOCRGestureViewModel
    public var modelView: MaskOCRLayerModelView
    private var panGesture = UIPanGestureRecognizer()

    public init(viewModel: MaskOCRGestureViewModel, modelView: MaskOCRLayerModelView) {
        self.viewModel = viewModel
        self.modelView = modelView
        super.init()
        gestureSet()
        panGesture.delegate = self

    }

    private func gestureSet() {
        guard let imageView = modelView.maskModel?.imageView else { return }
        modelView.maskModel?.maskGestureView?.addSubview(imageView)
        panGesture = UIPanGestureRecognizer(target: self, action:#selector(panTapped))
        modelView.maskModel?.maskGestureView?.addGestureRecognizer(panGesture)
    }

    @objc private func panTapped(sender: UIPanGestureRecognizer) { panTappedAction(sender: sender) }

}

// MARK: UIPanGestureRecognizer
@available(iOS 14.0, *)
extension MaskedOCRGestureViewModel: UIGestureRecognizerDelegate {

    @objc func panTappedAction(sender: UIPanGestureRecognizer) {
        let gestureObject = modelView.gestureObject
        let position: CGPoint = sender.location(in: gestureObject.cALayerView)

        guard position.y <= modelView.maskModel?.imageView.frame.size.height ?? 0,
              position.x <= modelView.maskModel?.imageView.frame.size.width ?? 0,
              position.y >= 0,
              position.x >= 0 else {
                  return
              }
        DispatchQueue.main.async {
            gestureObject.endFrame = gestureObject.lineView.frame
            gestureObject.endPoint = gestureObject.lineView.frame.origin
            gestureObject.cALayerView.tori(gestureObject)
        }
        switch sender.state {
        case .ended:
            gestureObject.endPoint = gestureObject.lineView.frame.origin
            gestureObject.endFrame = gestureObject.lineView.frame
        case .began:
            gestureObject.touchFlag = gestureObject.cropEdgeForPoint(point: gestureObject.framePoint)
        case .changed:
            gestureObject.updatePoint(point: position, touchFlag: gestureObject.touchFlag)
        default: break
        }
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let position: CGPoint = touch.location(in: modelView.maskModel?.imageView)
        modelView.gestureObject.framePoint = position
        return true
    }
}
