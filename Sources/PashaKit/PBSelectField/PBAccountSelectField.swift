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

/// `PBAccountSelectField` is a subclass of `UIView` made for displaying card and general account of user.
///
/// Its appearance and view structure is very similar to `PBUITextField`, but differs from it when data sets into.
///
/// `PBTemplateView` consists of two main parts and their subviews:
/// - `customBorder`- wrapper view for template icon
/// - `leftIconView`- icon on the left side of view
/// - `placeholderLabel`- placeholder view for representing placeholder of uitextfield
/// - `textLabel`- label for holding the string that will be setted
/// - `dropdownIcon`- indicator icon for reminding user this view will open list if you tap it.
/// - `footerLabel`- label for displaying under `customBorder`. It can be either be visible
/// and hidden at its initial state and invalid state
///
/// When adding a template view to your interface, perform the following actions: 140
///
/// * Set the height anchor
/// * Supply left icon to display on the left side of view
/// * Set text to `text` property for displaying given string
///
/// - Note: PBUIButton is optimized for looking as expected with default adjustments at the `height` and `width` of `80.0pt`.
///         However feel free to customize it the way you want.
///
open class PBAccountSelectField: UIView {

    /// Image on the left side of the view.
    ///
    /// If not specified `PBAccountSelectField` will setup it its left view without image.
    ///
    public var leftIcon: UIImage? {
        didSet {
            self.leftIconView.image = self.leftIcon
            self.updateVisibility()
        }
    }

    /// Set texts to the field.
    ///
    /// By default `PBAccountSelectField` will be created without specifying its title text.
    /// Instead, it will display placeholder text.
    ///
    /// If you change this text to arbitrary string view will call its `updateVisibility()` function
    /// to set subviews based on their defined states.
    ///
    public var text: String? {
        didSet {
            self.textLabel.text = self.text
            self.updateVisibility()
        }
    }

    /// Sets texts to footerLabel of text field.
    ///
    /// Since `footerLabelText` is`nil` by default, `footerLabel` won't be visible under `customBorder`.
    ///
    /// If you change this text to arbitrary string `footerLabel` will be visible under `customBorder` with the text
    /// color based on its `isValid` state
    ///
    public var footerLabelText: String? = nil {
        didSet {
            self.footerLabel.text = self.footerLabelText
            self.setNeedsLayout()
        }
    }

    /// A boolean value for indicating input validity.
    ///
    /// By default view will be created with `valid` input state. However changes to `isValid` property will call
    /// `updateUI()` method for styling view based on `isValid` value.
    ///
    public var isValid: PBTextFieldValidity = .valid {
        didSet {
            self.updateUI()
        }
    }

    /// Placeholder of select field.
    ///
    /// If not specified, placeholder will be just empty string. It's recommended to set
    /// placeholdertext for visual clarity of select field.
    ///
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
