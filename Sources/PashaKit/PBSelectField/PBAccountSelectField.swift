//
//  PBAccountSelectField.swift
//  
//
//  Created by Murad on 11.12.22.
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

open class PBAccountSelectField: UIView {

    public var leftIcon: UIImage? {
        didSet {
            self.leftIconView.image = self.leftIcon
            self.updateVisibility()
        }
    }

    public var text: String? {
        didSet {
            self.textLabel.text = self.text
            self.updateVisibility()
        }
    }

    public var footerLabelText: String? = nil {
        didSet {
            self.footerLabel.text = self.footerLabelText
            self.setNeedsLayout()
        }
    }

    public var isValid: PBTextFieldValidity = .valid {
        didSet {
            self.updateUI()
        }
    }

    public var placeholderText: String = "" {
        didSet {
            self.placeholderLabel.text = self.placeholderText
        }
    }

    private lazy var customBorder: UIView = {
        let view = UIView()

        self.addSubview(view)

        view.frame = CGRect()
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.Colors.PBGraySecondary.cgColor
        view.layer.borderWidth = 1.0
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var leftIconView: UIImageView = {
        let view = UIImageView()

        self.customBorder.addSubview(view)

        view.contentMode = .scaleAspectFit

        view.translatesAutoresizingMaskIntoConstraints = false

        view.widthAnchor.constraint(equalToConstant: 24.0).isActive = true
        view.heightAnchor.constraint(equalToConstant: 24.0).isActive = true

        return view
    }()

    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()

        self.customBorder.addSubview(label)

        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor.black.withAlphaComponent(0.6)

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var textLabel: UILabel = {
        let label = UILabel()

        self.customBorder.addSubview(label)

        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .darkText
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var dropdownIcon: UIImageView = {
        let view = UIImageView()

        self.customBorder.addSubview(view)
        view.setImage(withName: "ic_chevron_bottom")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var footerLabel: UILabel = {
        let view = UILabel()

        self.addSubview(view)

        view.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        view.numberOfLines = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = ""

        view.heightAnchor.constraint(equalToConstant: 24.0).isActive = true

        return view
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
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leftIconView.isHidden = true
        self.textLabel.isHidden = true
        self.placeholderLabel.isHidden = false

        self.setupConstraints()
    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([
            self.customBorder.topAnchor.constraint(equalTo: self.topAnchor),
            self.customBorder.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.customBorder.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])

        NSLayoutConstraint.activate([
            self.leftIconView.topAnchor.constraint(equalTo: self.customBorder.topAnchor, constant: 16.0),
            self.leftIconView.leftAnchor.constraint(equalTo: self.customBorder.leftAnchor, constant: 16.0),
            self.leftIconView.bottomAnchor.constraint(equalTo: self.customBorder.bottomAnchor, constant: -16.0)
        ])

        NSLayoutConstraint.activate([
            self.placeholderLabel.leftAnchor.constraint(equalTo: self.customBorder.leftAnchor, constant: 16.0),
            self.placeholderLabel.centerYAnchor.constraint(equalTo: self.leftIconView.centerYAnchor),
            self.placeholderLabel.rightAnchor.constraint(equalTo: self.dropdownIcon.leftAnchor, constant: -12.0)
        ])

        NSLayoutConstraint.activate([
            self.textLabel.leftAnchor.constraint(equalTo: self.leftIconView.rightAnchor, constant: 12.0),
            self.textLabel.centerYAnchor.constraint(equalTo: self.leftIconView.centerYAnchor),
            self.textLabel.rightAnchor.constraint(lessThanOrEqualTo: self.dropdownIcon.leftAnchor, constant: -12.0)
        ])

        NSLayoutConstraint.activate([
            self.dropdownIcon.rightAnchor.constraint(equalTo: self.customBorder.rightAnchor, constant: -16.0),
            self.dropdownIcon.centerYAnchor.constraint(equalTo: self.leftIconView.centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            self.footerLabel.topAnchor.constraint(equalTo: self.customBorder.bottomAnchor, constant: 4.0),
            self.footerLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16.0),
            self.footerLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16.0),
            self.footerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    private func updateVisibility() {
        self.leftIconView.isHidden = false
        self.textLabel.isHidden = false
        self.placeholderLabel.isHidden = true
    }

    private func updateUI() {
        switch self.isValid {
        case .valid:
            self.customBorder.layer.borderColor = UIColor.Colors.PBGraySecondary.cgColor
            self.footerLabel.textColor = UIColor.black.withAlphaComponent(0.6)
            self.placeholderLabel.textColor = UIColor.black.withAlphaComponent(0.6)
            self.footerLabel.text = self.footerLabelText
        case .invalid(let error):
            self.customBorder.layer.borderColor = UIColor.systemRed.cgColor
            self.footerLabel.textColor = .systemRed
            self.placeholderLabel.textColor = .systemRed
            self.footerLabel.text = error
        }
    }
}
