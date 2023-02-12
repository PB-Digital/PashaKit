//
//  PBAttentionView.swift
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

/// `PBAttentionView` is a type of `UIView` for showing information, alerts to customers.
///
/// There is 2 levels of `AttentionLevel` for `PBAttentionView`:
///  - `low`
///  - `high`
/// Low level attention views are in grayish theme, while high level alerts are in red one.
///
open class PBAttentionView: UIView {

    /// Attention level of information
    ///
    /// Used for setting up attention view. Depending on its case,
    /// attention view' s theme can change into gray and red ones.
    ///
    public enum AttentionLevel {
        /// Least level of attention
        ///
        /// Use this case for attentions which are `recommended` to consider when doing action,
        /// but isn't must.
        ///
        case low

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
    /// By default `PBAttentionView` will be created with `medium` level.
    ///
    public var attentionLevel: AttentionLevel = .medium {
        didSet {
            if self.attentionLevel != oldValue {
                self.setupAttention(level: self.attentionLevel)
            }
        }
    }

    private lazy var multilineConstraints: [NSLayoutConstraint] = {
        return [
            self.infoIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: 16.0),
            self.infoIcon.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16.0),
            self.infoBody.topAnchor.constraint(equalTo: self.topAnchor, constant: 16.0),
            self.infoBody.leftAnchor.constraint(equalTo: self.infoIcon.rightAnchor, constant: 8.0),
            self.infoBody.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16.0),
            self.infoBody.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16.0)
        ]
    }()

    private lazy var singlelineConstraints: [NSLayoutConstraint] = {
        return [
            self.infoIcon.centerYAnchor.constraint(equalTo: self.infoBody.centerYAnchor),
            self.infoIcon.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16.0),
            self.infoBody.topAnchor.constraint(equalTo: self.topAnchor, constant: 16.0),
            self.infoBody.leftAnchor.constraint(equalTo: self.infoIcon.rightAnchor, constant: 8.0),
            self.infoBody.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16.0),
            self.infoBody.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16.0)
        ]
    }()

    private lazy var infoIcon: UIImageView = {
        let view = UIImageView()

        self.addSubview(view)

        view.setImage(withName: "ic_info")
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
        self.setupAttention(level: self.attentionLevel)
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

    private func setupDefaults() {
        self.backgroundColor = UIColor.Colors.PBGrayTransparent
        self.layer.cornerRadius = 12.0
    }
}

extension PBAttentionView {
    func setupAttention(level: AttentionLevel) {
        switch level {
        case .low:
            self.backgroundColor = UIColor.Colors.PBGrayTransparent
            self.infoBody.textColor = UIColor.Colors.PBBlackMedium
            self.infoIcon.setImage(withName: "ic_info_gray")
        case .medium:
            self.backgroundColor = UIColor.Colors.PBGrayTransparent
            self.infoBody.textColor = .darkText
            self.infoIcon.setImage(withName: "ic_info_dark")
        case .high:
            self.backgroundColor = UIColor.Colors.PBRed8
            self.infoBody.textColor = UIColor.Colors.PBRed
            self.infoIcon.setImage(withName: "ic_info_red")
        }
    }
}
