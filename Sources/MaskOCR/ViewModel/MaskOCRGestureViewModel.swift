//
//  MaskOCRGestureViewModel.swift
//  SampleFocus
//
//  Created by 永田大祐 on 2018/06/30.
//  Copyright © 2018年 永田大祐. All rights reserved.
//

import UIKit

@available(iOS 14.0.0, *)
final public class MaskOCRGestureViewModel: NSObject {

    public enum TouchFlag {
        case touchTopLeft
        case touchTopRight
        case touchSideLeft
        case touchTop
        case touchDown
        case touchBottomLeft
        case touchBottomRight
        case touchSideRight
        case touchNone
    }
    public var maskModel: MaskOCRLayerModel?
    public var lineView = UIImageView()
    public var cALayerView = MaskOCRHhollowTargetLayer()
    var framePoint  = CGPoint()
    var endPoint = CGPoint()
    var endFrame = CGRect()
    var touchFlag = TouchFlag.touchBottomRight
    var modelView: MaskOCRLayerModelView?
    private var mLViewModel: MaskOCRLayerViewModel?

    public func cropEdgeForPoint(point: CGPoint) -> TouchFlag {

        let rect = lineView.frame
        let size: CGFloat = 32
        var topLeftRect: CGRect = rect
        topLeftRect.size.height = CGFloat(size)
        topLeftRect.size.width = CGFloat(size)

        if topLeftRect.contains(point) {
            return TouchFlag.touchTopLeft
        }

        var topRightRect = topLeftRect
        topRightRect.origin.x = rect.maxX - size
        if topRightRect.contains(point) {
            return TouchFlag.touchTopRight
        }

        var bottomLeftRect = topLeftRect
        bottomLeftRect.origin.y = rect.maxY - size
        if bottomLeftRect.contains(point) {
            return TouchFlag.touchBottomLeft
        }

        var bottomRightRect = topRightRect
        bottomRightRect.origin.y = bottomLeftRect.origin.y
        if bottomRightRect.contains(point) {
            return TouchFlag.touchBottomRight
        }

        var topRect = rect
        topRect.size.height = CGFloat(size)
        if topRect.contains(point) {
            return TouchFlag.touchTop
        }

        var bottomRect = rect
        bottomRect.origin.y = rect.maxY - size
        if bottomRect.contains(point) {
            return TouchFlag.touchDown
        }

        var leftRect = rect
        leftRect.size.width = size
        if leftRect.contains(point) {
            return TouchFlag.touchSideLeft
        }

        var rightRect = rect
        rightRect.origin.x = rect.maxX - size
        if rightRect.contains(point) {
            return TouchFlag.touchSideRight
        }
        return TouchFlag.touchNone
    }

    func updatePoint(point: CGPoint, touchFlag: TouchFlag) {
        switch touchFlag {
        case .touchNone:break
        case .touchSideRight:
            guard -point.x + endFrame.maxX < endFrame.width else {
                resetLine()
                return
            }
            lineView.frame.origin.x = point.x
            lineView.frame.size.width = -point.x + endFrame.minX
        case .touchBottomRight:
            guard -point.y + endFrame.maxY < endFrame.height, -point.x + endFrame.maxX < endFrame.width else {
                resetLine()
                return
            }
            lineView.frame.origin.x = point.x
            lineView.frame.size.width = -point.x + endFrame.minX
            lineView.frame.size.height = -point.y + endPoint.y
            lineView.frame.origin.y = endPoint.y
        case .touchBottomLeft:
            guard -point.y + endFrame.maxY < endFrame.height, -point.x + endFrame.maxX > .zero else {
                resetLine()
                return
            }
            lineView.frame.origin.x = point.x
            lineView.frame.size.width = -point.x + endFrame.maxX
            lineView.frame.size.height = -point.y + endPoint.y
            lineView.frame.origin.y = endPoint.y
        case .touchTop:
            guard -point.y + endFrame.maxY > .zero else {
                resetLine()
                return
            }
            lineView.frame.origin.y = point.y
            lineView.frame.size.height = -point.y + endFrame.maxY
        case .touchDown:
            guard -point.y + endFrame.maxY < endFrame.height - .zero else {
                resetLine()
                return
            }
            lineView.frame.size.height = -point.y + endPoint.y
            lineView.frame.origin.y = endPoint.y
        case .touchSideLeft:
            guard -point.x + endFrame.maxX > .zero else {
                resetLine()
                return
            }
            lineView.frame.origin.x = point.x
            lineView.frame.size.width = -point.x + endFrame.maxX
        case .touchTopRight:
            guard -point.y + endFrame.maxY > .zero, -point.x + endFrame.maxX < endFrame.width else {
                resetLine()
                return
            }
            lineView.frame.origin.x = point.x
            lineView.frame.size.width = -point.x + endFrame.minX
            lineView.frame.origin.y = point.y
            lineView.frame.size.height =  -point.y + endFrame.maxY
        case .touchTopLeft:
            guard -point.y + endFrame.maxY > .zero, -point.x + endFrame.maxX > .zero else {
                resetLine()
                return
            }
            lineView.frame.origin.x = point.x
            lineView.frame.size.width = -point.x + endFrame.maxX
            lineView.frame.origin.y = point.y
            lineView.frame.size.height =  -point.y + endFrame.maxY
        }
    }

    private func resetLine() {
        let resetSize: CGFloat = 44
        lineView.frame.origin.x = UIScreen.main.bounds.width/2 - resetSize/2
        lineView.frame.origin.y = UIScreen.main.bounds.height/4 + resetSize/2
        lineView.frame.size.width = resetSize
        lineView.frame.size.height = resetSize
    }
}
