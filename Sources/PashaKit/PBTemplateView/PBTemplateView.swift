//
//  PBTemplateView.swift
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

public class PBTemplateView: UIView {

    public enum ViewType {
        case payment
        case template
    }

    public enum IconViewSize {
        case small
        case medium
    }

    public var viewType: ViewType = .template {
        didSet {
            switch self.viewType {
            case .payment:
                self.iconView.layer.cornerRadius = 24.0
            case .template:
                self.iconView.layer.cornerRadius = 8.0
            }
        }
    }

    public var icon: UIImage? {
        didSet {
            self.iconView.image = self.icon
        }
    }

    public var iconViewSize: IconViewSize = .small {
        didSet {
            switch self.iconViewSize {
            case .small:
                NSLayoutConstraint.activate(self.smallSizeConstraints)
                NSLayoutConstraint.deactivate(self.mediumSizeConstraints)
            case .medium:
                NSLayoutConstraint.activate(self.mediumSizeConstraints)
                NSLayoutConstraint.deactivate(self.smallSizeConstraints)
            }
        }
    }

    var smallSizeConstraints: [NSLayoutConstraint] = []
    var mediumSizeConstraints: [NSLayoutConstraint] = []

    public var title: String? = "" {
        didSet {
            self.titleLabel.text = self.title
        }
    }

    public var subtitle: String? = "" {
        didSet {
            self.subtitleLabel.text = self.subtitle
        }
    }

    private lazy var iconWrapperView: UIView = {
        let view = UIView()

        self.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false

        view.backgroundColor = UIColor(red: 0.604, green: 0.608, blue: 0.612, alpha: 0.08)
        view.layer.cornerRadius = 24.0

        view.widthAnchor.constraint(equalToConstant: 48.0).isActive = true
        view.heightAnchor.constraint(equalToConstant: 48.0).isActive = true

        return view
    }()

    private lazy var iconView: UIImageView  = {
        let view = UIImageView()

        self.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false

        view.contentMode = .scaleAspectFit

        return view
    }()


    private lazy var contentStackView: UIStackView = {
        let view = UIStackView()

        self.addSubview(view)

        view.axis = .vertical
        view.distribution = .equalSpacing
        view.spacing = 0

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .darkText
        label.textAlignment = .center
        label.text = self.title

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(red: 0.502, green: 0.502, blue: 0.514, alpha: 1)
        label.textAlignment = .center
        label.text = self.subtitle

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()


    required override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public convenience init(type: ViewType) {
        self.init(frame: .zero)
        self.setupViews(for: type)
    }

    private func setupViews(for type: ViewType) {
        self.backgroundColor = .clear
        self.layer.cornerRadius = 16.0
        self.layer.masksToBounds = true
        self.contentStackView.addArrangedSubview(self.titleLabel)
        self.contentStackView.addArrangedSubview(self.subtitleLabel)
        self.setupConstraints(for: type)

        switch type {
        case .payment:
            self.iconWrapperView.layer.cornerRadius = 24.0
        case .template:
            self.iconWrapperView.layer.cornerRadius = 8.0
        }
    }

    public func setData(template: PBTemplateRepresentable) {
        self.title = template.templateName
        self.subtitle = template.descriptionText
    }

    private func setupConstraints(for type: ViewType) {
        NSLayoutConstraint.activate([
            self.iconWrapperView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16.0),
            self.iconWrapperView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])

        self.smallSizeConstraints = [
            self.iconView.topAnchor.constraint(equalTo: self.iconWrapperView.topAnchor, constant: 8.0),
            self.iconView.leftAnchor.constraint(equalTo: self.iconWrapperView.leftAnchor, constant: 8.0),
            self.iconView.bottomAnchor.constraint(equalTo: self.iconWrapperView.bottomAnchor, constant: -8.0),
            self.iconView.rightAnchor.constraint(equalTo: self.iconWrapperView.rightAnchor, constant: -8.0)
        ]

        self.mediumSizeConstraints = [
            self.iconView.topAnchor.constraint(equalTo: self.iconWrapperView.topAnchor),
            self.iconView.leftAnchor.constraint(equalTo: self.iconWrapperView.leftAnchor),
            self.iconView.bottomAnchor.constraint(equalTo: self.iconWrapperView.bottomAnchor),
            self.iconView.rightAnchor.constraint(equalTo: self.iconWrapperView.rightAnchor)
        ]

        switch type {
        case .payment:
            NSLayoutConstraint.activate(self.mediumSizeConstraints)
            NSLayoutConstraint.deactivate(self.smallSizeConstraints)
        case .template:
            NSLayoutConstraint.activate(self.smallSizeConstraints)
            NSLayoutConstraint.deactivate(self.mediumSizeConstraints)
        }

        NSLayoutConstraint.activate([
            self.contentStackView.topAnchor.constraint(equalTo: self.iconWrapperView.bottomAnchor, constant: 16.0),
            self.contentStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8.0),
            self.contentStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8.0)
        ])
    }
}
