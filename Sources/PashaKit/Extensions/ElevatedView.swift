//
//  ElevatedView.swift
//  
//
//  Created by Murad on 13.12.22.
//

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
