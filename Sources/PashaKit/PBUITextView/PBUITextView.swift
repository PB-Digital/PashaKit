//
//  PBUITextView.swift
//  
//
//  Created by Murad on 23.07.23.
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

public class PBUITextView: UIView {

    /// Placeholder of text view.
    ///
    /// If not specified, placeholder will be just empty string. It's recommended to set
    /// placeholdertext for visual clarity of text field.
    ///
    public var placeholderText: String = "" {
        didSet {
            self.customPlaceholder.text = self.placeholderText
        }
    }

    /// The text which is displayed under the text view.
    ///
    /// By default text view doesn't create footer label text. If you specify it, text field will be
    /// created with the `UILabel` under it.
    ///
    public var footerLabelText: String? = nil {
        didSet {
            self.footerLabel.text = self.footerLabelText
        }
    }

    /// The theme for the text view's appearance.
    ///
    /// `PBUITextView` is using theme parameter for defining its color palette for components. These include view's
    /// * Border color for `bordered` style, underline color for `underlined` style
    /// * Cursor color
    /// * Tint color for right icon
    ///
    public var theme: PBUITextFieldTheme = .regular {
        didSet {
            self.setTheme()
        }
    }

    /// Defines cursor color of textview.
    ///
    public  var placeholderCursorColor: UIColor = UIColor.Colors.PBGreen {
        didSet {
            self.textView.tintColor = self.placeholderCursorColor
        }
    }

    /// Sets the border color for text view when it's in `notEditing` state.
    ///
    /// By default this property will apply PBGraySecondary color to border.
    ///
    public var defaultBorderColor: UIColor = UIColor.Colors.PBGraySecondary {
        didSet {
            if self.defaultBorderColor != oldValue {
                self.updateUI()
            }
        }
    }

    /// Sets the border color for text view when it's in `editing` state for `bordered` style.
    ///
    /// By default this property will apply proper theme color to both types of border.
    ///
    public  var editingBorderColor: UIColor = UIColor.Colors.PBGreen {
        didSet {
            if self.editingBorderColor != oldValue {
                self.updateUI()
            }
        }
    }

    /// Sets the color for text view's `invalid` state.
    ///
    ///  By default this property will apply system red color to border, placeholder and footer label text color.
    ///
    public var errorStateColor: UIColor = UIColor.systemRed {
        didSet {
            if self.errorStateColor != oldValue {
                self.updateUI()
            }
        }
    }

    /// Sets color for placeholder text.
    ///
    /// By default this property will apply black color with alpha value of `0.6`.
    ///
    public var placeholderTextColor: UIColor = UIColor.black.withAlphaComponent(0.6) {
        didSet {
            if self.placeholderTextColor != oldValue {
                self.customPlaceholder.textColor = self.placeholderTextColor
                self.setNeedsLayout()
            }
        }
    }

    /// Sets color for input text.
    ///
    /// By defualt this property will apply native darkText color.
    ///
    public var textViewTextColor: UIColor = UIColor.darkText {
        didSet {
            if self.textViewTextColor != oldValue {
                self.textView.textColor = self.textViewTextColor
                self.setNeedsLayout()
            }
        }
    }

    /// Sets text view validity.
    ///
    /// Changing these property causes textview change its border, placeholder and footer label text color
    /// to predefined `errorStateColor`.
    ///
    public var isValid: PBTextFieldValidity = .valid {
        didSet {
            self.updateUI()
        }
    }

    private var textViewState: TextFieldState = .notEditing {
        didSet {
            self.updateUI()
            self.animatePlaceholderIfNeeded()
        }
    }

    private let leftPadding: CGFloat = 16

    private let placeholderFont = UIFont.systemFont(ofSize: 17, weight: .regular)
    private let placeholderSizeFactor: CGFloat = 0.73

    private var editingConstraints: [NSLayoutConstraint] = []
    private var notEditingConstraints: [NSLayoutConstraint] = []
    private var activeConstraints: [NSLayoutConstraint] = []

    private lazy var customPlaceholder: UILabel = {
        let placeholder = UILabel()

        placeholder.translatesAutoresizingMaskIntoConstraints = false
        placeholder.textAlignment = .left
        placeholder.font = self.placeholderFont
        placeholder.textColor = self.placeholderTextColor

        return placeholder
    }()

    private lazy var textView: UITextView = {
        let view = UITextView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.textContainerInset = UIEdgeInsets(top: 24, left: 12, bottom: 16, right: 16)
        view.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        view.layer.cornerRadius = 12.0
        view.layer.borderWidth = 1.0
        view.layer.borderColor = self.defaultBorderColor.cgColor
        view.backgroundColor = .clear
        view.isScrollEnabled = false
        view.delegate = self
        view.textColor = self.textViewTextColor

        return view
    }()

    private lazy var footerLabel: UILabel = {
        let view = UILabel()

        view.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        view.numberOfLines = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = self.placeholderTextColor

        return view
    }()

    public convenience init() {
        self.init(frame: .zero)

        self.setupViews()
        self.setupConstraints()

        self.textView.tintColor = self.placeholderCursorColor
        self.textView.textColor = self.textViewTextColor
    }

    private func setupViews() {
        self.addSubview(self.textView)
        self.textView.addSubview(self.customPlaceholder)
        self.addSubview(self.footerLabel)
    }

    private func setupConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.textView.topAnchor.constraint(equalTo: self.topAnchor),
            self.textView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.textView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24.0),
            self.textView.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])

        NSLayoutConstraint.activate([
            self.footerLabel.topAnchor.constraint(equalTo: self.textView.bottomAnchor, constant: 6),
            self.footerLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: self.leftPadding),
            self.footerLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -self.leftPadding)
        ])

        NSLayoutConstraint.activate([
            self.customPlaceholder.widthAnchor.constraint(equalTo: self.textView.widthAnchor)
        ])

        self.notEditingConstraints = [
            self.customPlaceholder.topAnchor.constraint(equalTo: self.textView.topAnchor, constant: 16.0),
            self.customPlaceholder.leftAnchor.constraint(equalTo: self.textView.leftAnchor, constant: self.leftPadding),
        ]

        self.activeConstraints = self.notEditingConstraints
        NSLayoutConstraint.activate(self.activeConstraints)
    }

    private func animatePlaceholderIfNeeded(animationEnabled: Bool = true) {
        switch self.textViewState {
        case .editing:
            self.animatePlaceholderToActivePosition()
        case .notEditing:
            guard let text = self.textView.text else { return }

            if text.isEmpty {
                self.animatePlaceholderToInactivePosition(animated: animationEnabled)
            } else {
                self.animatePlaceholderToActivePosition(animated: animationEnabled)
            }
        }
    }

    private func animatePlaceholderToActivePosition(animated: Bool = true) {
        NSLayoutConstraint.deactivate(self.activeConstraints)
        self.activeConstraints = self.calculateEditingConstraints()
        NSLayoutConstraint.activate(self.activeConstraints)

        if animated {
            self.performAnimation {
                self.layoutIfNeeded()

                self.customPlaceholder.transform = CGAffineTransform(
                    scaleX: self.placeholderSizeFactor,
                    y: self.placeholderSizeFactor
                )
            }
        } else {
            self.layoutIfNeeded()

            self.customPlaceholder.transform = CGAffineTransform(
                scaleX: self.placeholderSizeFactor,
                y: self.placeholderSizeFactor
            )
        }
    }

    private func animatePlaceholderToInactivePosition(animated: Bool = true) {
        NSLayoutConstraint.deactivate(self.activeConstraints)
        self.activeConstraints = self.notEditingConstraints
        NSLayoutConstraint.activate(self.activeConstraints)

        if animated {
            self.performAnimation {
                self.customPlaceholder.transform = .identity
                self.textView.transform = .identity

                self.layoutIfNeeded()
            }
        } else {
            self.customPlaceholder.transform = .identity
            self.textView.transform = .identity

            self.layoutIfNeeded()
        }
    }

    private func updateUI() {
        self.updateInputBorder()

        switch self.isValid {
        case .valid:
            self.footerLabel.textColor = self.placeholderTextColor
            self.footerLabel.text = self.footerLabelText
        case .invalid(let error):
            self.footerLabel.textColor = self.errorStateColor
            self.footerLabel.text = error
        }
    }

    private func updateInputBorder() {
        switch self.isValid {
        case .valid:
            switch self.textViewState {
            case .editing:
                self.performAnimation { [weak self] in
                    guard let self = self else { return }
                    self.customPlaceholder.textColor = self.editingBorderColor
                    self.textView.layer.borderColor = self.editingBorderColor.cgColor
                    self.textView.layer.borderWidth = 2.0
                }
            case .notEditing:
                self.performAnimation { [weak self] in
                    guard let self = self else { return }
                    self.customPlaceholder.textColor = self.placeholderTextColor
                    self.textView.layer.borderColor = self.defaultBorderColor.cgColor
                    self.textView.layer.borderWidth = 1.0
                }
            }
        case .invalid:
            self.performAnimation { [weak self] in
                guard let self = self else { return }
                self.customPlaceholder.textColor = self.errorStateColor
                self.textView.layer.borderColor = self.errorStateColor.cgColor
                self.textView.layer.borderWidth = 1.0
            }
        }
    }

    private func calculateEditingConstraints() -> [NSLayoutConstraint] {
        let originalWidth = customPlaceholder.bounds.width
        let xOffset = (originalWidth - (originalWidth * placeholderSizeFactor)) / 2

        return [
            self.customPlaceholder.topAnchor.constraint(equalTo: self.topAnchor, constant: 6.0),
            self.customPlaceholder.leftAnchor.constraint(equalTo: self.textView.leftAnchor, constant: -(xOffset - self.leftPadding))
        ]
    }

    private func setTheme() {
        self.placeholderCursorColor = self.theme.getPrimaryColor()
        self.editingBorderColor = self.theme.getPrimaryColor()
    }

    /// Returns the current text from text field. If there's no text, this method
    /// will return empty string literal.
    @available(*, deprecated, renamed: "text")
    public func getText() -> String {
        return self.textView.text ?? ""
    }

    public var text: String {
        get {
            self.textView.text ?? ""
        } set {
            self.textView.text = newValue
        }
    }

    // MARK: - INPUT DELEGATES

    /// Gets called when textview gets resigned from being first responder.
    public var onDidEnd: (() -> Void)?

    /// Gets called when editing did begin.
    public var onDidBegin: (() -> Void)?
}

extension PBUITextView: UITextViewDelegate {
    public func textViewDidBeginEditing(_ textView: UITextView) {
        self.textViewState = .editing
        self.onDidBegin?()
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        self.textViewState = .notEditing
        self.onDidEnd?()
    }
}
