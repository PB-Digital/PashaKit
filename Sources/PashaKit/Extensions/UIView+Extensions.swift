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

extension UIView {
    public func setGradientBackground(gradientConfig: GradientBackgroundRepresentable) {

        if let view = self.subviews.first as? GradientView {
            view.removeFromSuperview()
        }

        let customView = GradientView.init(frame: self.bounds,
                                           colorPoints: gradientConfig.colorPoints,
                                           angle: gradientConfig.angle,
                                           isReversed: gradientConfig.isReversed)

        self.insertSubview(customView, at: 0)
        customView.fillSuperview()
    }
}

extension UIView {
    public func fillSuperview() {
        guard let parent = self.superview else { return }

        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: parent.topAnchor),
            self.leftAnchor.constraint(equalTo: parent.leftAnchor),
            self.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
            self.rightAnchor.constraint(equalTo: parent.rightAnchor)
        ])
    }
}

extension UIView {
    func performAnimation(transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, animations: {
            self.transform = transform
            self.layoutIfNeeded()
        }, completion: nil)
    }

    func performAnimation(animation: @escaping (() -> Void)) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, animations: animation, completion: nil)
    }
}

public extension UIView {

    func setupElevatedView() {
        self.clipsToBounds = false

        let elevatedView1 = PBElevatedView()

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

        let elevatedView2 = PBElevatedView()

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

        let elevatedView1 = PBElevatedView()

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

        let elevatedView2 = PBElevatedView()

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
