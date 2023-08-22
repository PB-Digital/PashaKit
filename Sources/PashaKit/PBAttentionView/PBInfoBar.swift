//
//  PBInfoBar.swift
//
//
//  Created by Murad on 20.12.22.
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

/// `PBInfoBar` is a type of `UIView` for showing information, alerts to customers.
///
/// There is 2 levels of `AttentionLevel` for `PBInfoBar`:
///  - `low`
///  - `high`
/// Low level info bars are in grayish theme, while high level alerts are in red one.
///
open class PBInfoBar: UIView {

    /// Attention level of information
    ///
    /// Used for setting up info bar. Depending on its case,
    /// info bar' s theme can change into gray and red ones.
    ///
    public enum AttentionLevel {
        /// Least level of attention
        ///
        /// Use this case for attentions which are `recommended` to consider when doing action,
        /// but isn't must.
        ///
        case low
        
        /// Informative level of attention
        ///
        /// Use this case for attentions which are `informative` to user
        /// contains informations good to know
        ///
        case informative

        /// Intermediate level of attention
        ///
        /// Use this case for attentions which are `required` to consider when doing action, but isn't must.
        ///
        case medium

        /// Highest level of attention
        ///
        /// Use this case for attentions which is very important to consider when doing action.
        ///
        case high
    }

    /// Sets attention level for view.
    ///
    /// By default `PBInfoBar` will be created with `medium` level.
    ///
    public var attentionLevel: AttentionLevel = .medium {
        didSet {
            if self.attentionLevel != oldValue {
                self.setup(attentionLevel: self.attentionLevel)
            }
        }
    }

    private lazy var multilineConstraints: [NSLayoutConstraint] = {
        return [
            self.infoIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: 12.0),
            self.infoIcon.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12.0),
            self.infoBody.topAnchor.constraint(equalTo: self.topAnchor, constant: 12.0),
            self.infoBody.leftAnchor.constraint(equalTo: self.infoIcon.rightAnchor, constant: 10.0),
            self.infoBody.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12.0),
            self.infoBody.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12.0)
        ]
    }()

    private lazy var singlelineConstraints: [NSLayoutConstraint] = {
        return [
            self.infoIcon.centerYAnchor.constraint(equalTo: self.infoBody.centerYAnchor),
            self.infoIcon.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12.0),
            self.infoBody.topAnchor.constraint(equalTo: self.topAnchor, constant: 12.0),
            self.infoBody.leftAnchor.constraint(equalTo: self.infoIcon.rightAnchor, constant: 10.0),
            self.infoBody.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12.0),
            self.infoBody.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12.0)
        ]
    }()

    private lazy var infoIcon: UIImageView = {
        let view = UIImageView()

        self.addSubview(view)

        view.image = UIImage.Images.icInfo
        view.contentMode = .scaleAspectFit

        view.translatesAutoresizingMaskIntoConstraints = false

        view.widthAnchor.constraint(equalToConstant: 24.0).isActive = true
        view.heightAnchor.constraint(equalToConstant: 24.0).isActive = true

        return view
    }()

    private lazy var infoBody: UILabel = {
        let label = UILabel()

        self.addSubview(label)

        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .darkText
        label.numberOfLines = 0

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    required public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupViews()
    }

    private func setupViews() {
        self.setup(attentionLevel: self.attentionLevel)
        self.layoutSubviews()
        self.setupDefaults()
    }

    private func setupConstraints() {
        if self.infoBody.frame.height > 18.0 {
            NSLayoutConstraint.activate(self.multilineConstraints)
            NSLayoutConstraint.deactivate(self.singlelineConstraints)
        } else {
            NSLayoutConstraint.activate(self.singlelineConstraints)
            NSLayoutConstraint.deactivate(self.multilineConstraints)
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        self.setupConstraints()
    }

    /// Sets informational text and its level for atttenion view.
    ///
    /// - Parameters:
    ///  - text: informational text
    ///  - attentionLevel: attention level, default value is low
    ///
    public func set(text: String) {
        self.infoBody.text = text
        self.layoutSubviews()
    }

    /// Sets an attributed text and its level for atttenion view.
    ///
    /// - Parameters:
    ///  - text: informational attributed text
    ///  - attentionLevel: attention level, default value is low
    ///
    public func set(attributedText: NSMutableAttributedString?) {
        attributedText?.setColor(color: self.getForegroundColor(for: self.attentionLevel))
        self.infoBody.attributedText = attributedText
        self.layoutSubviews()
    }

    private func setupDefaults() {
        self.backgroundColor = UIColor.Colors.PBGrayTransparent
        self.layer.cornerRadius = 12.0
    }

    func setup(attentionLevel: AttentionLevel) {
        self.infoIcon.tintColor = self.getTintColor(for: attentionLevel)
        self.infoBody.textColor = self.getForegroundColor(for: attentionLevel)
        self.backgroundColor = self.getBackgroundColor(for: attentionLevel)
    }

    private func getTintColor(for attentionLevel: AttentionLevel) -> UIColor {
        switch attentionLevel {
        case .low:
            return UIColor.Colors.PBBlackMedium
        case .informative:
            return UIColor.Colors.PBInfoYellowFG
        case .medium:
            return UIColor.Colors.PBGray40
        case .high:
            return UIColor.Colors.PBRed
        }
    }

    private func getForegroundColor(for attentionLevel: AttentionLevel) -> UIColor {
        switch attentionLevel {
        case .low:
            return UIColor.Colors.PBBlackMedium
        case .informative:
            return UIColor.Colors.PBInfoYellowFG
        case .medium:
            return .darkText
        case .high:
            return UIColor.Colors.PBRed
        }
    }

    private func getBackgroundColor(for attentionLevel: AttentionLevel) -> UIColor {
        switch attentionLevel {
        case .low:
            return UIColor.Colors.PBGrayTransparent
        case .informative:
            return UIColor.Colors.PBInfoYellowBG
        case .medium:
            return UIColor.Colors.PBGrayTransparent
        case .high:
            return UIColor.Colors.PBRed8
        }
    }
}
