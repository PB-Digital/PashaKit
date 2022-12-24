//
//  File.swift
//  
//
//  Created by Murad on 06.12.22.
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

import UIKit

public class GradientView: UIView {

    var colorPoints = [GradientColorPoint]()
    var angle: GradientAngle = .horizontal
    let gradient = CAGradientLayer()
    var isReversed: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit(frame)
    }

    public init(frame: CGRect, colorPoints: [GradientColorPoint], angle: GradientAngle, isReversed: Bool) {
        super.init(frame: frame)
        self.colorPoints = colorPoints
        self.angle = angle
        self.isReversed = isReversed
        commonInit(frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit(CGRect.init(x: 0, y: 0, width: 0, height: 0))
    }

    private func commonInit(_ frame: CGRect) {
        self.backgroundColor = .clear
        gradient.frame = frame

        let endX: Double
        let endY: Double

        let startX: Double
        let startY: Double

        switch angle {
        case .horizontal:
            startY = 0.5
            endY = 0.5
            if isReversed {
                startX = 1.0
                endX = 0.0
            } else {
                startX = 0.0
                endX = 1.0
            }
        case .vertical:
            startX = 0.5
            endX = 0.5
            if isReversed {
                startY = 1.0
                endY = 0.0
            } else {
                startY = 0.0
                endY = 1.0
            }
        case .diagonal:
            if isReversed {
                startX = 1.0
                startY = 1.0

                endX = 0.0
                endY = 0.0
            } else {
                startX = 0.0
                startY = 0.0

                endX = 1.0
                endY = 1.0
            }
        case .diagonal_flipped_vertical:
            if isReversed {
                startX = 1.0
                startY = 0.0

                endX = 0.0
                endY = 1.0
            } else {
                startX = 0.0
                startY = 1.0

                endX = 1.0
                endY = 0.0
            }
        }

        gradient.startPoint = CGPoint.init(x: startX, y: startY)
        gradient.endPoint = CGPoint.init(x: endX, y: endY)

        gradient.colors = self.colorPoints.map({ (point) -> CGColor in
            point.color.cgColor
        })

        gradient.locations = self.colorPoints.map({ (point) -> NSNumber in
            point.position
        })

        self.layer.insertSublayer(gradient, at: 0)
    }

    public override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        gradient.frame = self.bounds
    }
}
