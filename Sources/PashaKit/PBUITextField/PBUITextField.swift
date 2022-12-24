//
//  PBUITextField.swift
//  
//
//  Created by Murad on 10.12.22.
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
import InputMask

public class PBUITextField: UIView {

    public enum TextFieldState {
        case editing
        case notEditing
    }

    public enum TextFieldStyle {
        case bordered
        case underlined
    }

    public enum RightIconSize {
        case small, regular
        case custom(CGSize)
    }

    public var id: String = ""

    public var placeholderText: String = "" {
        didSet {
            self.customPlaceholder.text = self.placeholderText
            self.animatePlaceholderIfNeeded(animationEnabled: false)
        }
    }

    public var footerLabelText: String? = nil {
        didSet {
            self.footerLabel.text = self.footerLabelText
            self.setNeedsLayout()
        }
    }

    public var icon: UIImage? = nil {
        didSet {
            self.iconImage.image = self.icon
            self.setupRightIconConstraints(for: self.iconSize)

            if self.iconImage.image == nil {
                self.customRightView.isHidden = true
                self.customTextField.textFieldType = .plain
            } else {
                self.customRightView.isHidden = false
                self.customTextField.textFieldType = .withRightImage
            }

            self.setNeedsLayout()
        }
    }

    public var isSecured: Bool = false {
        didSet {
            self.updateSecureEntry()
        }
    }

    private var isRevealed: Bool = false {
        didSet {
            self.updateSecureEntry()
        }
    }

    public var theme: PBUITextFieldTheme = .regular {
        didSet {
            self.setTheme()
        }
    }

    public var iconSize: RightIconSize = .regular {
        didSet {
            self.setupRightIconConstraints(for: self.iconSize)
            self.setNeedsLayout()
        }
    }

    public var isValid: PBTextFieldValidity = .valid {
        didSet {
            self.updateUI()
            self.setNeedsLayout()
        }
    }

    public  var placeholderCursorColor: UIColor = UIColor.Colors.PBGreen {
        didSet {
            self.customTextField.tintColor = self.placeholderCursorColor
            self.setNeedsLayout()
        }
    }

    public var defaultBorderColor: UIColor = UIColor.Colors.PBGraySecondary {
        didSet {
            if self.defaultBorderColor != oldValue {
                self.updateUI()
                self.setNeedsLayout()
            }
        }
    }

    public  var editingBorderColor: UIColor = UIColor.Colors.PBGreen {
        didSet {
            if self.editingBorderColor != oldValue {
                self.updateUI()
                self.setNeedsLayout()
            }
        }
    }

    public var textFieldBottomBorderColor: UIColor = UIColor.Colors.PBGreen {
        didSet {
            if self.textFieldBottomBorderColor != oldValue {
                self.updateUI()
                self.setNeedsLayout()
            }
        }
    }

    public var errorStateColor: UIColor = UIColor.systemRed {
        didSet {
            if self.errorStateColor != oldValue {
                self.updateUI()
                self.setNeedsLayout()
            }
        }
    }

    public var placeholderTextColor: UIColor = UIColor.black.withAlphaComponent(0.6) {
        didSet {
            if self.placeholderTextColor != oldValue {
                self.customPlaceholder.textColor = self.placeholderTextColor
                self.setNeedsLayout()
            }
        }
    }

    public var textFieldTextColor: UIColor = UIColor.darkText {
        didSet {
            if self.textFieldTextColor != oldValue {
                self.customTextField.textColor = self.textFieldTextColor
                self.setNeedsLayout()
            }
        }
    }

    public var maskFormat: String = "[N…]" {
        didSet {
            if self.maskFormat.isEmpty {
                self.inputMaskDelegate.primaryMaskFormat = "[N…]"
            } else {
                self.inputMaskDelegate.primaryMaskFormat = self.maskFormat
            }
        }
    }

    public var disableManualInput: Bool = false {
        didSet {
            self.customTextField.isUserInteractionEnabled = false
        }
    }

    public func getText() -> String {
        return self.customTextField.text?.replacingOccurrences(of: " ", with: "") ?? ""
    }

    public func set(text: String, animated: Bool = false) {
        guard !text.isEmpty else { return }

        self.inputMaskDelegate.put(text: text, into: self.customTextField)
        self.animatePlaceholderToActivePosition(animated: animated)
        self.onTextSetted?(text)
    }

    public func setKeyboardType(_ type: UIKeyboardType) {
        self.customTextField.setKeyboardType(type)
    }

    private var textFieldState: TextFieldState = .notEditing {
        didSet {
            self.updateUI()
            self.animatePlaceholderIfNeeded()
        }
    }

    private let inputMaskDelegate = MaskedTextFieldDelegate()
    private let topPadding: CGFloat = 8.0
    private let placeholderFont = UIFont.systemFont(ofSize: 17, weight: .regular)
    private let placeholderSizeFactor: CGFloat = 0.73
    private let leftPadding: CGFloat = 16
    private let animationDuration = 0.3

    private var editingConstraints: [NSLayoutConstraint] = []
    private var notEditingConstraints: [NSLayoutConstraint] = []
    private var activeConstraints: [NSLayoutConstraint] = []
    private var activeRightIconConstraints: [NSLayoutConstraint] = []

    private var textFieldStyle: TextFieldStyle = .bordered {
        didSet {
            self.prepareTextField(for: textFieldStyle)
        }
    }

    private var isComplete: Bool = false

    private lazy var customBorder: UIView = {
        let customBorder = UIView()

        customBorder.frame = CGRect()
        customBorder.layer.cornerRadius = 8
        customBorder.layer.borderWidth = 1.0
        customBorder.layer.borderColor = UIColor.Colors.PBGraySecondary.cgColor
        customBorder.backgroundColor = .clear
        customBorder.translatesAutoresizingMaskIntoConstraints = false

        return customBorder
    }()

    private lazy var customPlaceholder: UILabel = {
        let placeholder = UILabel()

        placeholder.textAlignment = .left
        placeholder.translatesAutoresizingMaskIntoConstraints = false

        return placeholder
    }()

    private lazy var customTextField: PBBaseUITextField = {
        let textField = PBBaseUITextField()

        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.backgroundColor = .clear

        return textField
    }()

    private lazy var customRightView: UIView = {
        let view = UIView()

        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var iconImage: UIImageView = {
        let view = UIImageView()

        self.customRightView.addSubview(view)
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        view.tintColor = self.theme.getPrimaryColor()
        view.translatesAutoresizingMaskIntoConstraints = false

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onIconTap))
        view.addGestureRecognizer(tapGestureRecognizer)

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

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public convenience init(style: TextFieldStyle) {
        self.init(frame: .zero)

        self.inputMaskDelegate.customNotations = [
            Notation(
                character: "N",
                characterSet: CharacterSet.symbols
                    .subtracting(CharacterSetHelper.emojiCharacterSet)
                    .union(CharacterSet.whitespaces)
                    .union(CharacterSet.decimalDigits)
                    .union(CharacterSet.letters)
                    .union(CharacterSet.punctuationCharacters),
                isOptional: false
            ),
        ]
        
        self.setupViews()
        self.textFieldStyle = style
        self.prepareTextField(for: style)
        self.inputMaskDelegate.primaryMaskFormat = self.maskFormat
        self.inputMaskDelegate.delegate = self
        self.inputMaskDelegate.autocomplete = false
        self.customTextField.delegate = self.inputMaskDelegate

        self.customTextField.tintColor = self.placeholderCursorColor
        self.customTextField.textColor = self.textFieldTextColor
    }

    public convenience init() {
        self.init(style: .bordered)
    }

    private func prepareTextField(for style: TextFieldStyle) {
        self.setupConstraints(for: style)
        self.setupStyleOfTextField(basedOn: style)
    }

    private func setupViews() {

        self.addSubview(self.customBorder)
        self.customBorder.addSubview(self.customPlaceholder)
        self.customBorder.addSubview(self.customTextField)
        self.customBorder.addSubview(self.customRightView)
        self.customRightView.addSubview(self.iconImage)
        self.addSubview(self.footerLabel)
    }

    private func setupStyleOfTextField(basedOn style: TextFieldStyle) {

        self.customPlaceholder.font = self.placeholderFont
        self.customPlaceholder.textColor = self.placeholderTextColor
        self.customPlaceholder.text = self.placeholderText
        self.customTextField.textColor = self.textFieldTextColor

        switch style {
        case .bordered:
            self.customTextField.hasBottomBorder = false
        case .underlined:
            self.customTextField.hasBottomBorder = true
            self.customBorder.layer.borderWidth = 0.0
            self.customBorder.layer.borderColor = UIColor.clear.cgColor
        }
    }

    private func setupConstraints(for style: TextFieldStyle) {

        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.customBorder.topAnchor.constraint(equalTo: self.topAnchor),
            self.customBorder.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.customBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24.0),
            self.customBorder.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])

        switch style {
        case .bordered:
            NSLayoutConstraint.activate([
                self.customTextField.leftAnchor.constraint(equalTo: self.customBorder.leftAnchor, constant: self.leftPadding),
                self.customTextField.rightAnchor.constraint(equalTo: self.customBorder.rightAnchor, constant: -self.leftPadding),
                self.customTextField.centerYAnchor.constraint(equalTo: self.customBorder.centerYAnchor)
            ])

            NSLayoutConstraint.activate([
                self.footerLabel.topAnchor.constraint(equalTo: self.customBorder.bottomAnchor, constant: 6),
                self.footerLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: self.leftPadding),
                self.footerLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -self.leftPadding)
            ])

            NSLayoutConstraint.activate([
                self.customRightView.heightAnchor.constraint(equalToConstant: 24.0),
                self.customRightView.widthAnchor.constraint(equalToConstant: 24.0),
                self.customRightView.centerYAnchor.constraint(equalTo: self.customTextField.centerYAnchor),
                self.customRightView.rightAnchor.constraint(equalTo: self.customBorder.rightAnchor, constant: -self.leftPadding)
            ])

            self.notEditingConstraints = [
                self.customPlaceholder.leftAnchor.constraint(equalTo: self.customTextField.leftAnchor),
                self.customPlaceholder.centerYAnchor.constraint(equalTo: self.customTextField.centerYAnchor)
            ]

        case .underlined:
            NSLayoutConstraint.activate([
                self.customTextField.leftAnchor.constraint(equalTo: self.customBorder.leftAnchor),
                self.customTextField.rightAnchor.constraint(equalTo: self.customBorder.rightAnchor),
                self.customTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])

            NSLayoutConstraint.activate([
                self.footerLabel.topAnchor.constraint(equalTo: self.customBorder.bottomAnchor),
                self.footerLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
                self.footerLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
                self.footerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])

            NSLayoutConstraint.activate([
                self.customRightView.heightAnchor.constraint(equalToConstant: 24.0),
                self.customRightView.widthAnchor.constraint(equalToConstant: 24.0),
                self.customRightView.centerYAnchor.constraint(equalTo: self.customTextField.centerYAnchor),
                self.customRightView.rightAnchor.constraint(equalTo: self.customBorder.rightAnchor)
            ])

            self.notEditingConstraints = [
                self.customPlaceholder.leftAnchor.constraint(equalTo: self.customTextField.leftAnchor),
                self.customPlaceholder.centerYAnchor.constraint(equalTo: self.customTextField.centerYAnchor)
            ]
        }

        NSLayoutConstraint.activate(self.notEditingConstraints)
        self.activeConstraints = self.notEditingConstraints

        self.setNeedsLayout()
    }

    private func setupRightIconConstraints(for iconSize: RightIconSize) {
        NSLayoutConstraint.deactivate(self.activeRightIconConstraints)

        switch iconSize {
        case .regular:
            self.activeRightIconConstraints = [
                self.iconImage.heightAnchor.constraint(equalToConstant: 24.0),
                self.iconImage.widthAnchor.constraint(equalToConstant: 24.0),
                self.iconImage.centerYAnchor.constraint(equalTo: self.customRightView.centerYAnchor),
                self.iconImage.centerXAnchor.constraint(equalTo: self.customRightView.centerXAnchor)
            ]
        case .small:
            self.activeRightIconConstraints = [
                self.iconImage.heightAnchor.constraint(equalToConstant: 16.0),
                self.iconImage.widthAnchor.constraint(equalToConstant: 16.0),
                self.iconImage.centerYAnchor.constraint(equalTo: self.customRightView.centerYAnchor),
                self.iconImage.centerXAnchor.constraint(equalTo: self.customRightView.centerXAnchor)
            ]

        case .custom(let iconSize):
            self.activeRightIconConstraints = [
                self.iconImage.heightAnchor.constraint(equalToConstant: iconSize.height),
                self.iconImage.widthAnchor.constraint(equalToConstant: iconSize.width),
                self.iconImage.centerYAnchor.constraint(equalTo: self.customRightView.centerYAnchor),
                self.iconImage.centerXAnchor.constraint(equalTo: self.customRightView.centerXAnchor)
            ]
        }

        NSLayoutConstraint.activate(self.activeRightIconConstraints)
        self.customRightView.layoutIfNeeded()
    }

    private func updateUI() {
        switch self.textFieldStyle {
        case .bordered:
            self.updateInputBorder()
        case .underlined:
            self.updateBottomBorder()
        }

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
            self.customPlaceholder.textColor = self.placeholderTextColor

            switch self.textFieldState {
            case .editing:
                self.performAnimation { [weak self] in
                    guard let self = self else { return }
                    self.customPlaceholder.textColor = self.editingBorderColor
                    self.customBorder.layer.borderColor = self.editingBorderColor.cgColor
                    self.customBorder.layer.borderWidth = 2.0
                }
            case .notEditing:
                self.performAnimation { [weak self] in
                    guard let self = self else { return }
                    self.customPlaceholder.textColor = self.placeholderTextColor
                    self.customBorder.layer.borderColor = self.defaultBorderColor.cgColor
                    self.customBorder.layer.borderWidth = 1.0
                }
            }
        case .invalid(_):
            self.performAnimation { [weak self] in
                guard let self = self else { return }
                self.customPlaceholder.textColor = self.errorStateColor
                self.customBorder.layer.borderColor = self.errorStateColor.cgColor
                self.customBorder.layer.borderWidth = 1.0
                self.customPlaceholder.textColor = self.errorStateColor
            }
        }
    }

    private func updateBottomBorder() {
        switch self.isValid {
        case .valid:
            self.customPlaceholder.textColor = self.placeholderTextColor

            switch self.textFieldState {
            case .editing:
                self.performAnimation { [weak self] in
                    guard let self = self else { return }
                    self.customPlaceholder.textColor = self.editingBorderColor
                    self.customTextField.bottomBorderThickness = 2.0
                    self.customTextField.bottomBorderColor = self.textFieldBottomBorderColor
                }
            case .notEditing:
                self.performAnimation { [weak self] in
                    guard let self = self else { return }
                    self.customPlaceholder.textColor = self.placeholderTextColor
                    self.customTextField.bottomBorderThickness = 1.0
                    self.customTextField.bottomBorderColor = self.textFieldBottomBorderColor
                }
            }
        case .invalid(_):
            self.performAnimation { [weak self] in
                guard let self = self else { return }
                self.customPlaceholder.textColor = self.errorStateColor
                self.customBorder.layer.borderColor = self.errorStateColor.cgColor
                self.customTextField.bottomBorderThickness = 1.0
                self.customPlaceholder.textColor = self.errorStateColor
                self.customTextField.bottomBorderColor = self.errorStateColor
            }
        }
    }

    private func calculateEditingConstraints() {
        let attributedStringPlaceholder = NSAttributedString(string: (self.placeholderText), attributes: [
            NSAttributedString.Key.font : self.placeholderFont
        ])
        let originalWidth = attributedStringPlaceholder.boundingRect(with: CGSize(width: .greatestFiniteMagnitude, height: self.frame.height), options: [], context: nil).width

        let xOffset = (originalWidth - (originalWidth * placeholderSizeFactor)) / 2

        switch self.textFieldStyle {
        case .bordered:
            self.editingConstraints = [
                self.customPlaceholder.topAnchor.constraint(equalTo: self.topAnchor, constant: 6.0),
                self.customPlaceholder.leftAnchor.constraint(equalTo: self.leftAnchor, constant: -xOffset + self.leftPadding)
            ]
        case .underlined:
            self.editingConstraints = [
                self.customPlaceholder.bottomAnchor.constraint(equalTo: self.customTextField.topAnchor, constant: self.topPadding),
                self.customPlaceholder.leftAnchor.constraint(equalTo: self.leftAnchor, constant: -xOffset)
            ]
        }
    }

    private func animatePlaceholderIfNeeded(animationEnabled: Bool = true) {

        switch self.textFieldState {
        case .editing:
            self.animatePlaceholderToActivePosition()
        case .notEditing:
            guard let text = self.customTextField.text else { return }

            if text.isEmpty {
                self.animatePlaceholderToInactivePosition(animated: animationEnabled)
            } else {
                self.animatePlaceholderToActivePosition(animated: animationEnabled)
            }
        }

        self.setNeedsLayout()
    }

    private func animatePlaceholderToActivePosition(animated: Bool = true) {
        self.calculateEditingConstraints()
        self.layoutIfNeeded()
        NSLayoutConstraint.deactivate(self.activeConstraints)
        NSLayoutConstraint.activate(self.editingConstraints)
        self.activeConstraints = self.editingConstraints

        if animated {
            self.performAnimation {
                self.layoutIfNeeded()
                self.customPlaceholder.transform = CGAffineTransform(scaleX: self.placeholderSizeFactor, y: self.placeholderSizeFactor)
                if self.textFieldStyle == .bordered {
                    self.customTextField.transform = CGAffineTransform(translationX: 0, y: 8)
                } else {
                    return
                }
            }
        } else {
            self.layoutIfNeeded()
            self.customPlaceholder.transform = CGAffineTransform(scaleX: self.placeholderSizeFactor, y: self.placeholderSizeFactor)
            if self.textFieldStyle == .bordered {
                self.customTextField.transform = CGAffineTransform(translationX: 0, y: 8)
            } else {
                return
            }
        }
    }

    private func animatePlaceholderToInactivePosition(animated: Bool = true) {
        self.layoutIfNeeded()
        NSLayoutConstraint.deactivate(self.activeConstraints)
        NSLayoutConstraint.activate(self.notEditingConstraints)
        self.activeConstraints = self.notEditingConstraints

        if animated {
            self.performAnimation {
                self.layoutIfNeeded()
                self.customPlaceholder.transform = .identity
                self.customTextField.transform = .identity
            }
        } else {
            self.layoutIfNeeded()
            self.customPlaceholder.transform = .identity
            self.customTextField.transform = .identity
        }
    }

    private func setTheme() {
        self.placeholderCursorColor = self.theme.getPrimaryColor()
        self.editingBorderColor = self.theme.getPrimaryColor()
        self.textFieldBottomBorderColor = self.theme.getPrimaryColor()
        self.iconImage.tintColor = self.theme.getPrimaryColor()
    }

    private func updateSecureEntry() {
        self.customTextField.isSecureTextEntry = self.isSecured && !self.isRevealed

        if self.isSecured {
            if self.isRevealed {
                self.icon = UIImage(named: "ic_reveal_open", in: Bundle.module, compatibleWith: nil)
            }
            else {
                self.icon = UIImage(named: "ic_reveal_closed", in: Bundle.module, compatibleWith: nil)
            }
        }
    }

    public func setInputAccessoryView(view: UIView) {
        self.customTextField.inputAccessoryView = view
    }

    public func setInputView(view: UIView) {
        self.customTextField.inputView = view
    }

    public func setTextContentType(_ type: UITextContentType) {
        self.customTextField.textContentType = type
    }

    public func setCapitalizationRule(_ rule: UITextAutocapitalizationType)  {
        self.customTextField.autocapitalizationType = rule
    }

    public func isMaskComplete() -> Bool {
        return self.isComplete
    }

    @objc private func onIconTap() {
        self.onActionIcon?()
        self.isRevealed = !self.isRevealed
    }

    public func makeFirstResponder() {
        self.customTextField.becomeFirstResponder()
    }

    public func undoFirstResponder() {
        self.customTextField.resignFirstResponder()
    }

    override public func resignFirstResponder() -> Bool {
        self.customTextField.resignFirstResponder()
    }

    public var onTextUpdate: ((String) -> Void)?
    public var onTextSetted: ((String) -> Void)?
    public var onActionIcon: (() -> Void)?
    public var onType: ((String) -> Void)?
    public var onDidEnd: (() -> Void)?
    public var onDidBegin: (() -> Void)?
}

extension PBUITextField: MaskedTextFieldDelegateListener {

    open func textField(
            _ textField: UITextField,
            didFillMandatoryCharacters complete: Bool,
            didExtractValue value: String
        )
    {
        let cleanText = value
            .replacingOccurrences(of: " ", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        self.onType?(value)
        self.onTextUpdate?(cleanText)
        self.isComplete = complete
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.textFieldState = .editing
        self.onDidBegin?()
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.textFieldState = .notEditing
        self.onDidEnd?()
    }
}
