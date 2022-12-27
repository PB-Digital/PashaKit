//
//  PBRoundedView.swift
//  
//
//  Created by Murad on 07.12.22.
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

///
/// `PBRoundedView` is type of `UIView` made for circular buttons .
///
/// **View Components**
///
/// Rounded view consists one subview:
/// - `iconView`- holds an icon of view
///
public class PBRoundedView: UIView {

    ///
    /// Sets icon for rounded view.
    ///
    /// By default there is no an icon for rounded view. It will be created as raw view with specified background
    /// color and proper style
    ///
    public var icon: UIImage? {
        didSet {
            self.updateUI()
        }
    }

    ///
    /// Sets the style for rounded view
    ///
    /// By default rounded view will be created as circle. However if you need more customized style
    /// set `roundedRect(cornerRadius: CGFloat)` case with proper `cornerRadius`
    ///
    public var style: Style = .circle {
        didSet {
            self.updateUI()
        }
    }

    /// Sets insets from all sides for `icon`
    ///
    /// If not specified insets from 4 sides will equal to 10.0. However
    /// you can change it to any insets you want.
    ///
    public var contentInsets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) {
        didSet {
            self.updateUI()
        }
    }

    private var activeConstraints = [NSLayoutConstraint]()

    private lazy var iconView: UIImageView = {
        let view = UIImageView()

        self.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false

        view.contentMode = .scaleAspectFit
        view.tintColor = .white

        return view
    }()

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /// Creates rounded view with icon and style
    ///
    /// - Parameters:
    ///  - icon: UIImage which will be used for  as view's `icon`
    ///  - style: Style of rounded view. If not specified, `circle` will be set.
    ///
    public convenience init(icon: UIImage?, style: Style = .circle) {
        self.init(frame: .zero)

        self.style = style
        self.icon = icon
        self.iconView.image = icon
        self.backgroundColor = UIColor(red: 0.455, green: 0.455, blue: 0.502, alpha: 0.08)

        self.setupDefaults()
        self.setupConstraints()
    }

    public convenience init() {
        self.init(icon: nil)
    }

    public override func layoutSubviews() {
        switch self.style {
        case .roundedRect(let cornerRadius):
            self.layer.cornerRadius = cornerRadius
        case .circle:
            self.layer.cornerRadius = self.frame.width / 2.0
        }
    }

    /// A function for updating icon and constraints of rounded view.
    /// 
    private func updateUI() {
        self.iconView.image = self.icon
        self.updateConstraints(basedOn: self.contentInsets)
    }

    private func updateConstraints(basedOn contentInsets: UIEdgeInsets) {

        NSLayoutConstraint.deactivate(self.activeConstraints)

        self.activeConstraints = [
            self.iconView.topAnchor.constraint(equalTo: self.topAnchor, constant: contentInsets.top),
            self.iconView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: contentInsets.left),
            self.iconView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -contentInsets.right),
            self.iconView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -contentInsets.bottom)
        ]

        NSLayoutConstraint.activate(self.activeConstraints)
    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalTo: self.heightAnchor)
        ])

        self.activeConstraints =  [
            self.iconView.topAnchor.constraint(equalTo: self.topAnchor, constant: self.contentInsets.top),
            self.iconView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: self.contentInsets.left),
            self.iconView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -self.contentInsets.right),
            self.iconView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -self.contentInsets.bottom)
        ]

        NSLayoutConstraint.activate(self.activeConstraints)
    }

    private func setupDefaults() {
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor(red: 0.455, green: 0.455, blue: 0.502, alpha: 0.08)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
