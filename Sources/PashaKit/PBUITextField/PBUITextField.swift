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

/// Wrapper view of UITexField with custom animation and overall style.
///
/// PBUITextField differs from native `UITextField` by its custom placeholder animation and border style.
/// Under the hood PBUITextField has 3 distinct components. These are
/// * UIView named `customBorder` which is used for border style.
/// * UILabel named `footerLabel` for displaying text under bordered view
/// * UILabel named `customPlaceholder` which replaces the traditional placeholder of UITextField
///
/// When adding a button to your interface, perform the following actions:
///
/// * Set the border style of the text field at creation time.
/// * Supply a placeholder string or image.
/// * Optional: Set right icon and its size.
/// * Optional: Set input mask format for formatting and limiting the entered text in text field.
/// * Optional: Supply a footer label text.
/// * Optional: Define its validity.
///
/// - Note: PBUIButton is optimized for looking as expected with default adjustments at the `height` of `80.0pt`.
///         However feel free to customize it.
///
public class PBUITextField: UIView {

    /// Specifies the border style for the text field.
    ///
    public enum TextFieldStyle {
        /// Sets text field style to bordered.
        ///
        /// In the bordered style textfield appears with rectangle around it with defined corner radius. If not editing this custom
        /// border will be in gray color with thin borders. However if it's changing its state to editing the color and radius of
        /// text field will change with animating placeholder parallelly.
        ///
        case bordered

        /// Sets text field style to underlined.
        case underlined
    }

    /// Defines the view size for the icon on the right side.
    ///
    /// Based on frequent usage of similar sized icons, we defined 3 case:
    ///  - `small`
    ///  - `regular`
    ///  - `custom` with given size parameter
    ///
    public enum RightIconSize {
        /// Constraints an icon to `16pt` width and `16pt` height
        ///
        case small

        /// Constraints an icon to `24pt` width and `24pt` height
        ///
        case regular

        /// Constraints an icon to given `CGSize`
        ///
        case custom(CGSize)
    }

    // MARK: - PUBLIC PROPERTIES

    public var id: String = ""

    /// Placeholder of text field.
    ///
    /// If not specified, placeholder will be just empty string. It's recommended to set
    /// placeholdertext for visual clarity of text field.
    ///
    public var placeholderText: String = "" {
        didSet {
            self.customPlaceholder.text = self.placeholderText
        }
    }

    /// The text which is displayed under the text field.
    ///
    /// By default text field doesn't create footer label text. If you specify it, text field will be
    /// created with the `UILabel` under it.
    ///
    public var footerLabelText: String? = nil {
        didSet {
            self.footerLabel.text = self.footerLabelText
        }
    }

    /// Sets the icon for displaying at the right end of text field.
    ///
    /// If not specified, text field will be created without icon on the right.
    ///
    public var icon: UIImage? {
        didSet {
            self.rightIconView.image = self.icon
            self.rightIconView.isHidden = self.icon == nil
        }
    }

    /// Decides whether entered text if confidential or not.
    ///
    /// Since the value of this property is false by default, you won't see any difference. However
    /// setting this property to true, adds button to `hide` and `show` password with secured text.
    ///
    /// Secured text basically is traditional text field entry which replaces input info circular symbols for each letter.
    ///
    public var isSecured: Bool = false {
        didSet {
            self.updateSecureEntry()
        }
    }

    /// The theme for the text field's appearance.
    ///
    /// `PBUITextField` is using theme parameter for defining its color palette for components. These include field's
    /// * Border color for `bordered` style, underline color for `underlined` style
    /// * Cursor color
    /// * Tint color for right icon
    ///
    public var theme: PBUITextFieldTheme = .regular {
        didSet {
            self.setTheme()
        }
    }

    /// Specifies the size for right side icon.
    ///
    /// By defualt icon size set to `regular` which means its size is 24.0 pt both for width and height.
    ///
    public var iconSize: RightIconSize = .regular {
        didSet {
            self.setupRightIconConstraints(for: self.iconSize)
        }
    }

    /// Sets text field input validity.
    ///
    /// Changing these property causes textfield change its border, placeholder and footer label text color
    /// to predefined `errorStateColor`.
    ///
    /// Invalid case also requires you to enter invalid case text which will be displayed under field
    ///
    /// Change this property when having valid input enter is critical. Such cases include checking
    /// - card number with Luhn algorithm
    /// - email
    /// - password
    ///
    public var isValid: PBTextFieldValidity = .valid {
        didSet {
            self.updateUI()
        }
    }

    /// Defines cursor color of textfield.
    ///
    public  var placeholderCursorColor: UIColor = UIColor.Colors.PBGreen {
        didSet {
            self.customTextField.tintColor = self.placeholderCursorColor
        }
    }

    /// Sets the border color for text field when it's in `notEditing` state.
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

    /// Sets the border color for text field when it's in `editing` state for `bordered` style.
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

    /// Sets the border color for text field when it's in `editing` state for `underlined` style.
    ///
    /// By default this property will apply proper theme color to both types of border.
    ///
    public var textFieldBottomBorderColor: UIColor = UIColor.Colors.PBGreen {
        didSet {
            if self.textFieldBottomBorderColor != oldValue {
                self.updateUI()
            }
        }
    }

    /// Sets the color for text field's `invalid` state.
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
    public var textFieldTextColor: UIColor = UIColor.darkText {
        didSet {
            if self.textFieldTextColor != oldValue {
                self.customTextField.textColor = self.textFieldTextColor
                self.setNeedsLayout()
            }
        }
    }

    /// Sets masking format for input text.
    ///
    /// If not specified custom maskFormat will be applied to accept all types of symbols to enter.
    ///
    /// Change this property based on your desires. Following input mask formats are widely used in our application:
    /// - [0000] [0000] [0000] [0000] - for card pan number input. It will limit your input to maximum 16 numbers which are
    /// grouped by 4 number resembling real card number appearance in text field.
    /// ---
    /// - +994 [00] [000] [000] - for number input. It will limit your input to maximum 8 characters. When you start typing predefined
    /// +994 will automatically be inserted into field. This country code is optional. For different country code, just change it with theirs.
    ///
    /// If you want to learn more about maskFormats, please check their GitHub [repository](https://github.com/RedMadRobot/input-mask-ios).
    ///
    public var maskFormat: String = "[N…]" {
        didSet {
            if self.maskFormat.isEmpty {
                self.inputMaskDelegate.primaryMaskFormat = "[N…]"
            } else {
                self.inputMaskDelegate.primaryMaskFormat = self.maskFormat
            }
        }
    }

    /// Disables entering text into field.
    ///
    /// This property just changes `isUserInteractionEnabled` property of base text field to `false`
    ///
    /// When you need your PBUITextField to be open to gestures, but closed to manual input, just change the
    /// value of this property to `true`.
    ///
    public var disableManualInput: Bool = false {
        didSet {
            self.customTextField.isUserInteractionEnabled = !self.disableManualInput
        }
    }

    public var shouldGrayifyBackgroundWhenDisabled: Bool = false {
        didSet {
            if self.disableManualInput && shouldGrayifyBackgroundWhenDisabled {
                self.performAnimation {
                    self.customBorder.backgroundColor = .black.withAlphaComponent(0.06)
                }
            } else {
                self.performAnimation {
                    self.customBorder.backgroundColor = .white
                }
            }
        }
    }

    /// Returns the current text from text field. If there's no text, this method
    /// will return empty string literal.
    ///
    public func getText(format: TextFieldTextFormat = .whiteSpacesRemoved) -> String {
        switch format {
        case .whiteSpacesRemoved:
            return self.customTextField.text?.replacingOccurrences(of: " ", with: "") ?? ""
        case .raw:
            return self.customTextField.text ?? ""
        }
    }

    /// Sets the given text into textfield.
    ///
    /// - Parameters:
    ///     - text: The string literal you want to put into field
    ///     - animated: Boolean value defining whether text will be set with animation or not.
    ///     By default this value will be `false`.
    ///
    public func set(text: String, animated: Bool = false) {
        guard text != self.customTextField.text else { return }

        self.inputMaskDelegate.put(text: text, into: self.customTextField)

        if text.isEmpty {
            self.animatePlaceholderToInactivePosition(animated: animated)
        } else {
            self.animatePlaceholderToActivePosition(animated: animated)
        }

        self.onTextSetted?(text)
    }

    /// The keyboard type for text field.
    ///
    /// Text objects can be targeted for specific types of input, such as plain text, email, numeric entry, and so on.
    /// 
    /// The keyboard style identifies what keys are available on the keyboard and which ones appear by default.
    /// The default value for this property is UIKeyboardType.default.
    ///
    public func setKeyboardType(_ type: UIKeyboardType) {
        self.customTextField.keyboardType = type
    }

    // MARK: - PRIVATE PROPERTIES

    private var isRevealed: Bool = false {
        didSet {
            self.updateSecureEntry()
        }
    }

    private var textFieldState: TextFieldState = .notEditing {
        didSet {
            self.updateUI()
            self.animatePlaceholderIfNeeded()
        }
    }

    private lazy var inputMaskDelegate: MaskedTextFieldDelegate = {
        let delegate = MaskedTextFieldDelegate()

        delegate.primaryMaskFormat = self.maskFormat
        delegate.delegate = self
        delegate.autocomplete = false

        return delegate
    }()

    private var activeRightIconConstraints: [NSLayoutConstraint] = []

    private var textFieldStyle: TextFieldStyle = .bordered {
        didSet {
            self.prepareTextField(for: textFieldStyle)
        }
    }

    private var isComplete: Bool = false

    // MARK: - VIEW HIERARCHY

    private lazy var customBorder: UIView = {
        let customBorder = UIView()

        customBorder.translatesAutoresizingMaskIntoConstraints = false

        customBorder.layer.cornerRadius = 12.0
        customBorder.layer.borderWidth = 1.0
        customBorder.layer.borderColor = self.defaultBorderColor.cgColor
        customBorder.layer.cornerCurve = .continuous

        return customBorder
    }()

    private lazy var customPlaceholder: PBMorphingLabel = {
        let placeholder = PBMorphingLabel()

        placeholder.isOpaque = true
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        placeholder.textColor = self.placeholderTextColor

        return placeholder
    }()

    private lazy var textFieldStack: UIStackView = {
        let view = UIStackView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 8.0
        view.alignment = .center
        view.distribution = .fill

        return view
    }()

    private lazy var customTextField: PBBaseUITextField = {
        let textField = PBBaseUITextField()

        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.textColor = self.textFieldTextColor

        return textField
    }()

    private lazy var rightIconView: UIImageView = {
        let view = UIImageView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        view.layer.masksToBounds = true
        view.tintColor = self.theme.getPrimaryColor()
        view.isHidden = true

        let tapGestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(onIconTap))
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

    /// Creates a new text field of specified style.
    ///
    /// - Parameters:
    ///    - style: The style for field.
    ///
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
        self.customBorder.addSubview(self.textFieldStack)

        self.textFieldStack.addArrangedSubview(self.customTextField)
        self.textFieldStack.addArrangedSubview(self.rightIconView)

        self.addSubview(self.footerLabel)
    }

    private func setupStyleOfTextField(basedOn style: TextFieldStyle) {
        switch style {
        case .bordered:
            self.textFieldStack.removeExistingBottomBorder()
        case .underlined:
            self.textFieldStack.addBottomBorder(thickness: 1.0, color: self.textFieldBottomBorderColor)
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
                self.textFieldStack.topAnchor.constraint(greaterThanOrEqualTo: self.customBorder.topAnchor),
                self.textFieldStack.leftAnchor.constraint(equalTo: self.customBorder.leftAnchor, constant: 16.0),
                self.textFieldStack.rightAnchor.constraint(equalTo: self.customBorder.rightAnchor, constant: -16.0),
                self.textFieldStack.centerYAnchor.constraint(equalTo: self.customBorder.centerYAnchor),
                self.textFieldStack.bottomAnchor.constraint(lessThanOrEqualTo: self.customBorder.bottomAnchor),
            ])

            NSLayoutConstraint.activate([
                self.customPlaceholder.topAnchor.constraint(equalTo: self.textFieldStack.topAnchor),
                self.customPlaceholder.leftAnchor.constraint(equalTo: self.customTextField.leftAnchor),
                self.customPlaceholder.rightAnchor.constraint(equalTo: self.customTextField.rightAnchor),
                self.customPlaceholder.bottomAnchor.constraint(equalTo: self.textFieldStack.bottomAnchor)
            ])

            NSLayoutConstraint.activate([
                self.footerLabel.topAnchor.constraint(equalTo: self.customBorder.bottomAnchor, constant: 6),
                self.footerLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16.0),
                self.footerLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16.0),
                self.footerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])

        case .underlined:
            NSLayoutConstraint.activate([
                self.textFieldStack.leftAnchor.constraint(equalTo: self.customBorder.leftAnchor),
                self.textFieldStack.rightAnchor.constraint(equalTo: self.customBorder.rightAnchor),
                self.textFieldStack.bottomAnchor.constraint(equalTo: self.customBorder.bottomAnchor)
            ])

            NSLayoutConstraint.activate([
                self.customPlaceholder.topAnchor.constraint(equalTo: self.topAnchor, constant: 12.0),
                self.customPlaceholder.leftAnchor.constraint(equalTo: self.customTextField.leftAnchor),
                self.customPlaceholder.rightAnchor.constraint(equalTo: self.customTextField.rightAnchor),
                self.customPlaceholder.bottomAnchor.constraint(equalTo: self.customBorder.bottomAnchor)
            ])

            NSLayoutConstraint.activate([
                self.footerLabel.topAnchor.constraint(equalTo: self.customBorder.bottomAnchor, constant: 6.0),
                self.footerLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
                self.footerLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
                self.footerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        }

        self.activeRightIconConstraints = [
            self.rightIconView.heightAnchor.constraint(equalToConstant: 24.0),
            self.rightIconView.widthAnchor.constraint(equalToConstant: 24.0)
        ]

        NSLayoutConstraint.activate(self.activeRightIconConstraints)
    }

    private func setupRightIconConstraints(for iconSize: RightIconSize) {
        NSLayoutConstraint.deactivate(self.activeRightIconConstraints)

        switch iconSize {
        case .small:
            self.activeRightIconConstraints = [
                self.rightIconView.heightAnchor.constraint(equalToConstant: 16.0),
                self.rightIconView.widthAnchor.constraint(equalToConstant: 16.0)
            ]

        case .regular:
            self.activeRightIconConstraints = [
                self.rightIconView.heightAnchor.constraint(equalToConstant: 24.0),
                self.rightIconView.widthAnchor.constraint(equalToConstant: 24.0)
            ]

        case .custom(let iconSize):
            self.activeRightIconConstraints = [
                self.rightIconView.heightAnchor.constraint(equalToConstant: iconSize.height),
                self.rightIconView.widthAnchor.constraint(equalToConstant: iconSize.width)
            ]
        }

        NSLayoutConstraint.activate(self.activeRightIconConstraints)
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
        case .invalid:
            self.performAnimation { [weak self] in
                guard let self = self else { return }
                self.customPlaceholder.textColor = self.errorStateColor
                self.customBorder.layer.borderColor = self.errorStateColor.cgColor
                self.customBorder.layer.borderWidth = 1.0
            }
        }
    }

    private func updateBottomBorder() {
        switch self.isValid {
        case .valid:
            switch self.textFieldState {
            case .editing:
                self.performAnimation { [weak self] in
                    guard let self = self else { return }
                    self.customPlaceholder.textColor = self.editingBorderColor
                    self.textFieldStack.updateExistingBottomBorderThickness(to: 2.0)
                    self.textFieldStack.updateExistingBottomBorderColor(to: self.editingBorderColor)
                }
            case .notEditing:
                self.performAnimation { [weak self] in
                    guard let self = self else { return }
                    self.customPlaceholder.textColor = self.placeholderTextColor
                    self.textFieldStack.updateExistingBottomBorderThickness(to: 1.0)
                    self.textFieldStack.updateExistingBottomBorderColor(to: self.textFieldBottomBorderColor)
                }
            }
        case .invalid:
            self.performAnimation { [weak self] in
                guard let self = self else { return }
                self.customPlaceholder.textColor = self.errorStateColor
                self.customBorder.layer.borderColor = self.errorStateColor.cgColor
                self.textFieldStack.updateExistingBottomBorderThickness(to: 1.0)
                self.textFieldStack.updateExistingBottomBorderColor(to: self.errorStateColor)
            }
        }
    }

    private func updatePlaceholderState(animated: Bool) {
        let state = PBTextInputState(hasText: self.hasText, firstResponder: self.isFirstResponder)
        self.customPlaceholder.setState(state, animated: animated)
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
    }

    private func animatePlaceholderToActivePosition(animated: Bool = true) {
        self.updatePlaceholderState(animated: animated)

        if animated {
            self.performAnimation {
                if self.textFieldStyle == .bordered {
                    self.customTextField.transform = CGAffineTransform(translationX: 0, y: 8)
                }

                self.layoutIfNeeded()
            }
        } else {
            if self.textFieldStyle == .bordered {
                self.customTextField.transform = CGAffineTransform(translationX: 0, y: 8)
            }

            self.layoutIfNeeded()
        }
    }

    private func animatePlaceholderToInactivePosition(animated: Bool = true) {
        self.updatePlaceholderState(animated: animated)

        if animated {
            self.performAnimation {
                self.customTextField.transform = .identity
                self.layoutIfNeeded()
            }
        } else {
            self.customTextField.transform = .identity
            self.layoutIfNeeded()
        }
    }

    private func setTheme() {
        self.placeholderCursorColor = self.theme.getPrimaryColor()
        self.editingBorderColor = self.theme.getPrimaryColor()
        self.textFieldBottomBorderColor = self.theme.getPrimaryColor()
        self.rightIconView.tintColor = self.theme.getPrimaryColor()
    }

    private func updateSecureEntry() {
        self.customTextField.isSecureTextEntry = self.isSecured && !self.isRevealed

        if self.isSecured {
            if self.isRevealed {
                self.icon = UIImage.Images.icRevealOpen
            }
            else {
                self.icon = UIImage.Images.icRevealClosed
            }
        }
    }

    @objc private func onIconTap() {
        self.onActionIcon?()
        self.isRevealed = !self.isRevealed
    }

    /// Changes input accessory view with given view
    ///
    /// - Parameters:
    ///     - view: New `inputAccessoryView` which will be displayed on top of `inputView`.
    ///
    public func setInputAccessoryView(view: UIView) {
        self.customTextField.inputAccessoryView = view
    }

    /// Changes input view with given view
    ///
    /// - Parameters:
    ///     - view: New `inputView` which will be displayed on top of `inputView`.
    ///  This option allows you customize the input view which will be displayed when the text field becomes the first responder.
    ///
    public func setInputView(view: UIView) {
        self.customTextField.inputView = view
    }

    /// Sets the contentType for text field
    ///
    /// - Parameters:
    ///     - type: The semantic meaning for a text input area.
    ///
    /// This method allows you choose `textContentType` for text field.
    ///
    /// Use this property to give the keyboard and the system information about
    /// the expected semantic meaning for the content that users enter
    public func setTextContentType(_ type: UITextContentType) {
        self.customTextField.textContentType = type
    }

    /// Sets the autocapitalization style for the text object.
    ///
    public func setCapitalizationRule(_ rule: UITextAutocapitalizationType)  {
        self.customTextField.autocapitalizationType = rule
    }

    /// Returns whether user completed mandatory characters with input mask
    ///
    /// If you have defined masking format for text field, `inputMaskDelegate` of it will notify whether
    /// all mandatory characters are filled or not.
    public func isMaskComplete() -> Bool {
        return self.isComplete
    }

    /// Makes text field become first responder.
    ///
    @available(*, deprecated, renamed: "becomeFirstResponder")
    public func makeFirstResponder() {
        self.customTextField.becomeFirstResponder()
    }

    public override func becomeFirstResponder() -> Bool {
        self.customTextField.becomeFirstResponder()
    }

    /// Resigns text field from being first responder.
    ///
    @available(*, deprecated, renamed: "resignFirstResponder")
    public func undoFirstResponder() {
        self.customTextField.resignFirstResponder()
    }

    override public func resignFirstResponder() -> Bool {
        self.customTextField.resignFirstResponder()
    }

    /// Resets text field to its initial form at the beginning
    ///
    public func resetField() {
        self.customTextField.text = nil
        self.customTextField.resignFirstResponder()
        self.footerLabel.text = self.footerLabelText
        self.isValid = .valid
        self.animatePlaceholderToInactivePosition(animated: false)
    }

    public func addDoneButtonOnKeyboard(title: String) {
        self.customTextField.addDoneButtonOnKeyboard(title: title)
    }

    // MARK: - INPUT DELEGATES

    /// Get called when entered text updates.
    ///
    public var onTextUpdate: ((String) -> Void)?

    /// Gets called when text is setted to field.
    ///
    public var onTextSetted: ((String) -> Void)?

    /// Gets called when user taps on right icon.
    public var onActionIcon: (() -> Void)?

    /// Gets called when textfield becomes first responder.
    ///
    public var onType: ((String) -> Void)?

    /// Gets called when textfield gets resigned from being first responder.
    public var onDidEnd: (() -> Void)?

    /// Gets called when editing did begin.
    public var onDidBegin: (() -> Void)?

    public var hasText: Bool {
        return self.customTextField.hasText
    }

    public override var isFirstResponder: Bool {
        return self.customTextField.isFirstResponder
    }
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
