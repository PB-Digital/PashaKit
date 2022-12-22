//
//  ElevatedView.swift
//  
//
//  Created by Murad on 13.12.22.
//

import Foundation
import UIKit

open class ElevatedView: UIView {

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

public extension UIView {

    func setupElevatedView() {
        self.clipsToBounds = false

        let elevatedView1 = ElevatedView()

        self.insertSubview(elevatedView1, at: 0)

        elevatedView1.fillSuperview()

        elevatedView1.setShadowConfig(
            config: ShadowConfig(
                corners: [.allCorners],
                cornerRadius: 12,
                fillColor: UIColor.white,
                shadowColor: UIColor.black.withAlphaComponent(0.08).cgColor,
                shadowOffet: CGSize(width: 0, height: 0),
                shadowOpacity: 1,
                shadowRadius: 2))

        let elevatedView2 = ElevatedView()

        self.insertSubview(elevatedView2, at: 1)

        elevatedView2.fillSuperview()

        elevatedView2.setShadowConfig(
            config: ShadowConfig(
                corners: [.allCorners],
                cornerRadius: 12,
                fillColor: UIColor.white,
                shadowColor: UIColor.black.withAlphaComponent(0.06).cgColor,
                shadowOffet: CGSize(width: 0, height: 2),
                shadowOpacity: 1,
                shadowRadius: 16))
    }

    func setupElevatedViewIL() {
        self.clipsToBounds = false

        let elevatedView1 = ElevatedView()

        self.insertSubview(elevatedView1, at: 0)

        elevatedView1.fillSuperview()

        elevatedView1.setShadowConfig(
            config: ShadowConfig(
                corners: [.allCorners],
                cornerRadius: 16,
                fillColor: UIColor.white,
                shadowColor: UIColor.black.withAlphaComponent(0.08).cgColor,
                shadowOffet: CGSize(width: 0, height: 0),
                shadowOpacity: 8,
                shadowRadius: 2))

        let elevatedView2 = ElevatedView()

        self.insertSubview(elevatedView2, at: 1)

        elevatedView2.fillSuperview()

        elevatedView2.setShadowConfig(
            config: ShadowConfig(
                corners: [.allCorners],
                cornerRadius: 16,
                fillColor: UIColor.white,
                shadowColor: UIColor.black.withAlphaComponent(0.06).cgColor,
                shadowOffet: CGSize(width: 0, height: 2),
                shadowOpacity: 6,
                shadowRadius: 16))
    }
}
