//
//  SMEAttentionView.swift
//  
//
//  Created by Farid Valiyev on 05.08.23.
//
//
//  MIT License
//
//  Copyright (c) 2023 Farid Valiyev
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

/// `SMEAttentionView` is a type of `UIView` for showing information, alerts to customers.
///
/// There is 2 levels of `AttentionType` for `SMEAttentionView`:
///  - `normal`
///  - `detailed`
/// normal type attention views is in one line, while detailed type are in two lines.
///
open class SMEAttentionView: UIView {
    
    /// Attention type of information
    ///
    /// Used for setting up attention view. Depending on its case,
    /// attention view' s theme can change into gray and red ones.
    ///
    public enum AttentionType: Equatable {
        case normal(localizedTitle: String)
        case detailed(localizedTitle: String, localizedDetailedTitle: String)
    }

    /// Attention style of information
    ///
    /// Used for setting up attention view. Depending on its case,
    /// attention view' s theme can change into diffrenet style.
    ///
    public enum AttentionStyle {
        
        /// Info style of attention
        ///
        /// Use this case for attentions which are `recommended` to consider when doing action,
        /// but isn't must.
        ///
        case info
        
        /// Inprogress style of attention
        ///
        /// Use this case for attentions which are `informative` to user
        /// contains informations good to know
        ///
        case inprogress

        /// Waiting style of attention
        ///
        /// Use this case for attentions which are `required` to consider when doing action, but isn't must.
        ///
        case waiting

        /// Error style of attention
        ///
        /// Use this case for attentions which is very important to consider when doing action.
        ///
        case error
        
        /// Done style of attention
        ///
        /// Use this case for attentions which is very important to consider when doing action.
        ///
        case done
    }
    
    public var title: String = "" {
        didSet {
            self.infoTitle.text = title
        }
    }
    
    public var detail: String = "" {
        didSet {
            self.infoBody.text = detail
        }
    }

    /// Sets attention type for view.
    ///
    /// By default `SMEAttentionView` will be created with `normal` type.
    ///
    public var attentionType: AttentionType = .normal(localizedTitle: "") {
        didSet {
            self.prepareAttentionByType(type: self.attentionType)
        }
    }
    
    /// Sets attention style for view.
    ///
    /// By default `SMEAttentionView` will be created with `info` style.
    ///
    public var attentionStyle: AttentionStyle = .info {
        didSet {
            if self.attentionStyle != oldValue {
                self.prepareAttentionByStyle(style: self.attentionStyle)
            }
        }
    }

    private lazy var infoIcon: UIImageView = {
        let view = UIImageView()

        self.addSubview(view)

        view.image = UIImage.Images.icInfoDark
        view.contentMode = .scaleAspectFit

        view.translatesAutoresizingMaskIntoConstraints = false

        view.widthAnchor.constraint(equalToConstant: 24.0).isActive = true
        view.heightAnchor.constraint(equalToConstant: 24.0).isActive = true

        return view
    }()

    private lazy var infoTitle: UILabel = {
        let label = UILabel()

        label.font = UIFont.sfProText(ofSize: 15, weight: .medium)
        label.textColor = .darkText
        label.numberOfLines = 0
        label.text = self.title

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private lazy var infoBody: UILabel = {
        let label = UILabel()

        label.font = UIFont.sfProText(ofSize: 13, weight: .regular)
        label.textColor = .darkText
        label.numberOfLines = 0
        label.text = self.detail
        
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private lazy var textStackView: UIStackView = {
        let view = UIStackView()

        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        view.alignment = .leading
        view.axis = .vertical
        view.spacing = 4.0
        view.distribution = .fill
        return view
    }()

    public convenience init(typeOfAttention: AttentionType = .normal(localizedTitle: "")) {
        self.init()
        
        UIFont.registerCustomFonts()
        
        self.attentionType = typeOfAttention
        self.attentionStyle = .info
        
        self.prepareAttentionByType(type: typeOfAttention)
        self.prepareAttentionByStyle(style: .info)
        
        self.setupViews()
        
        self.setupConstraints()
    }
    
    public convenience init(typeOfAttention: AttentionType = .normal(localizedTitle: ""),
                            styleOfAttention: AttentionStyle = .info) {
        self.init()
        
        UIFont.registerCustomFonts()
        
        self.attentionStyle = styleOfAttention
        self.attentionType = typeOfAttention
        
        self.prepareAttentionByType(type: typeOfAttention)
        self.prepareAttentionByStyle(style: styleOfAttention)
        
        self.setupViews()
        
        self.setupConstraints()
    }

    private func setupViews() {
        switch self.attentionType {
        case .normal:
            self.textStackView.addArrangedSubview(self.infoTitle)
        case .detailed:
            self.textStackView.addArrangedSubview(self.infoTitle)
            self.textStackView.addArrangedSubview(self.infoBody)
        }
    }

    private func setupConstraints() {
        
        switch self.attentionType {
        case .normal:
            NSLayoutConstraint.activate([
                self.heightAnchor.constraint(equalToConstant: 48.0)
            ])
        case .detailed:
            NSLayoutConstraint.activate([
                self.heightAnchor.constraint(equalToConstant: 66.0)
            ])
        }
        
        NSLayoutConstraint.activate([
            self.infoIcon.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16.0),
            self.infoIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.textStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.textStackView.leftAnchor.constraint(equalTo: self.infoIcon.rightAnchor, constant: 12),
            self.textStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
        ])
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
    }

    /// Sets informational text and its level for atttenion view.
    ///
    /// - Parameters:
    ///  - localizedTitle: informational text
    ///  - attentionType: attention type default value is normal
    ///
    
    func prepareAttentionByType(type: AttentionType) {
        switch type {
        case .normal(let localizedTitle):
            self.infoTitle.text = localizedTitle
        case .detailed(let localizedTitle, let localizedDetailText):
            self.infoTitle.text = localizedTitle
            self.infoBody.text = localizedDetailText
        }
    }
    
    func prepareAttentionByStyle(style: AttentionStyle) {
        self.layer.cornerRadius = 12.0
        self.infoTitle.font = UIFont.sfProText(ofSize: 15, weight: .medium)
        self.infoTitle.textColor = UIColor.Colors.SMEInfoTitle
        self.infoBody.font = UIFont.sfProText(ofSize: 13, weight: .regular)
        self.infoBody.textColor = UIColor.Colors.SMEInfoDescription
        switch style {
        case .info:
            self.backgroundColor = UIColor.Colors.SMEInfoGrayBackground
            self.infoIcon.image = UIImage.Images.icSMEInfoGray
        case .waiting:
            self.backgroundColor = UIColor.Colors.SMEInfoYellowBackground
            self.infoIcon.image = UIImage.Images.icSMEInfoYellow
        case .inprogress:
            self.backgroundColor = UIColor.Colors.SMEInfoBlueBackground
            self.infoIcon.image = UIImage.Images.icSMEInfoBlue
        case .error:
            self.backgroundColor = UIColor.Colors.SMEInfoRedBackground
            self.infoIcon.image = UIImage.Images.icSMEInfoRed
        case .done:
            self.backgroundColor = UIColor.Colors.SMEInfoGreenBackground
            self.infoIcon.image = UIImage.Images.icSMEInfoGreen
        }
    }
}
