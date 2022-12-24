//
//  ElevatedView.swift
//  
//
//  Created by Murad on 13.12.22.
//
//
//  MIT License
//
//  Copyright (c) 2022 Murad Abbasov
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
//  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation
import UIKit

open class PBElevatedView: UIView {

    private var shadowLayer: CAShapeLayer? = nil

    private var shadowConfig: ShadowConfig? = nil

    public override func layoutSubviews() {
        super.layoutSubviews()

        guard let config = self.shadowConfig else { return }

        if self.shadowLayer == nil {
            let shapeLayer = CAShapeLayer()

            shapeLayer.shadowColor = config.shadowColor
            shapeLayer.fillColor = config.fillColor.cgColor

            shapeLayer.shadowOffset = config.shadowOffet
            shapeLayer.shadowOpacity = config.shadowOpacity
            shapeLayer.shadowRadius = config.shadowRadius

            layer.insertSublayer(shapeLayer, at: 0)

            self.shadowLayer = shapeLayer
        }

        self.shadowLayer?.path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: config.corners,
            cornerRadii: CGSize(width: config.cornerRadius, height: config.cornerRadius)).cgPath

        self.shadowLayer?.shadowPath = self.shadowLayer?.path
    }

    func setShadowConfig(config: ShadowConfig?) {
        if self.shadowLayer != nil {
            layer.sublayers?.remove(at: 0)
            self.shadowLayer = nil
        }

        self.shadowConfig = config

        self.layoutSubviews()
    }
}

public struct ShadowConfig {
    let corners: UIRectCorner
    let cornerRadius: CGFloat
    let fillColor: UIColor
    let shadowColor: CGColor
    let shadowOffet: CGSize
    let shadowOpacity: Float
    let shadowRadius: CGFloat
}
