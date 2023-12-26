//
//  SMETextField.swift
//
//
//  Created by Farid Valiyev on 03.08.23
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
import InputMask

/// Wrapper view of UITexField with custom animation and overall style.
///
/// PBUITextField differs from native `UITextField` by its custom placeholder animation and border style.
/// Under the hood SMEITextField has 3 distinct components. These are
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
/// - Note: SMEUIButton is optimized for looking as expected with default adjustments at the `height` of `64.0pt`.
///         However feel free to customize it.
///
public class SMETextField: UIView {

    /// Specifies the state of textfield.
    ///
    public enum SMETextFieldState {
        /// The state when text field has focus.
        ///
        case editing

        /// The state when text field has no focus.
        ///
        case notEditing
        
        /// The state when text field disabled.
        ///
        case disabled
    }

    /// Specifies the border style for the text field.
    ///
    public enum SMETextFieldStyle {
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
    
    /// Specifies the input type style for the text field.
    ///
    public enum SMETextFieldInputType {
        /// Sets text field input type.
        ///
        /// In the bordered style textfield appears with rectangle around it with defined corner radius. If not editing this custom
        /// border will be in gray color with thin borders. However if it's changing its state to editing the color and radius of
        /// text field will change with animating placeholder parallelly.
        ///
        case text

        /// Sets text field input type.
        case amount
        case pan(localizedErrorMessage: String)
        case iban
        case number
        case phone
        case azPhone(localizedErrorMessage: String)
        case email(localizedErrorMessage: String)
        case date
        case password
        case select
        case custom(maskFormat: String = "",
                    keyboardType: UIKeyboardType,
                    minChar: Int = 0,
                    maxChar: Int = 0,
                    regex: String = "",
                    localizedErrorMessage: String)
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

    /// Option for getting the text from field.
    ///
    /// In general, we use `whiteSpacesRemoved`
    /// for sending the data to our back-end. However, there is time we need to send
    /// input as it is shown on the screen. For that reason we are using `raw` case.
    ///
    public enum TextFieldTextFormat {
        /// Returns the text inside of textfield by removing any whitespaces.
        ///
        case whiteSpacesRemoved

        /// Returns the text inside of textfield as it is displayed to user
        ///
        case raw
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
    
    /// The text which is displayed under the text field.
    ///
    /// By default text field doesn't create footer label text. If you specify it, text field will be
    /// created with the `UILabel` under it.
    ///
    public var errorLabelText: String? = nil {
        didSet {
            self.errorLabel.text = self.errorLabelText
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
    
    /// Decides whether entered text if confidential or not.
    ///
    /// Since the value of this property is valid by default, you won't see any difference. However
    /// setting this property to true, validate input to `valid` and `invalid`
    ///
    public var validationCredentials: (regex: String, localizedErrorMessage: String) = ("", "")

    /// The theme for the text field's appearance.
    ///
    /// `SMETextField` is using theme parameter for defining its color palette for components. These include field's
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
    /// By defualt icon size set to `small` which means its size is 16.0 pt both for width and height.
    ///
    public var iconSize: RightIconSize = .small {
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
    public  var placeholderCursorColor: UIColor = UIColor.Colors.SMEGreen {
        didSet {
            self.customTextField.tintColor = self.placeholderCursorColor
        }
    }

    /// Sets the border color for text field when it's in `notEditing` state.
    ///
    /// By default this property will apply PBGraySecondary color to border.
    ///
    public var defaultBorderColor: UIColor = UIColor.Colors.PBGraySecondary { //TODO: Change color SME colors
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
    public  var editingBorderColor: UIColor = UIColor.Colors.SMEGreen {
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
    public var textFieldBottomBorderColor: UIColor = UIColor.Colors.SMEGray {
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
    /// When you need your SMETextField to be open to gestures, but closed to manual input, just change the
    /// value of this property to `true`.
    ///
    public var disableManualInput: Bool = false {
        didSet {
            self.customTextField.isUserInteractionEnabled = false
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

        self.layoutCompletionBlock = {
            if text.isEmpty {
                self.animatePlaceholderToInactivePosition(animated: animated)
            } else {
                self.animatePlaceholderToActivePosition(animated: animated)
            }
        }

        self.onTextSetted?(text)
        self.layoutSubviews()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutCompletionBlock?()
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
    
    private var textFieldInputType: SMETextFieldInputType = .text {
        didSet {
            self.updateUI()
            self.animatePlaceholderIfNeeded()
        }
    }

    private var textFieldState: SMETextFieldState = .notEditing {
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

    private let topPadding: CGFloat = 8.0
    private let placeholderFont = UIFont.systemFont(ofSize: 17, weight: .regular)
    private let placeholderSizeFactor: CGFloat = 0.73
    private let leftPadding: CGFloat = 16
    private let animationDuration = 0.3

    private var editingConstraints: [NSLayoutConstraint] = []
    private var notEditingConstraints: [NSLayoutConstraint] = []
    private var activeConstraints: [NSLayoutConstraint] = []
    private var activeRightIconConstraints: [NSLayoutConstraint] = []
    private var footerLabelConstraints: [NSLayoutConstraint] = []
    private var activeValidationLabelConstraints: [NSLayoutConstraint] = []
    private var validConstraints: [NSLayoutConstraint] = []
    private var invalidConstraints: [NSLayoutConstraint] = []
    private var validWithLabelConstraints: [NSLayoutConstraint] = []
    private var invalidWithLabelConstraints: [NSLayoutConstraint] = []
    
    private var textFieldStyle: SMETextFieldStyle = .underlined {
        didSet {
            self.prepareTextFieldByStyle(for: textFieldStyle)
        }
    }

    private var isComplete: Bool = false
    private var layoutCompletionBlock: (() -> Void)?

    // MARK: - VIEW HIERARCHY

    private lazy var customBorder: UIView = {
        let customBorder = UIView()

        customBorder.translatesAutoresizingMaskIntoConstraints = false

        customBorder.layer.cornerRadius = 12.0
        customBorder.layer.borderWidth = 1.0
        customBorder.layer.borderColor = self.defaultBorderColor.cgColor
        customBorder.backgroundColor = .clear

        return customBorder
    }()

    private lazy var customPlaceholder: UILabel = {
        let placeholder = UILabel()

        placeholder.font = UIFont.sfProText(ofSize: 17, weight: .regular)
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        placeholder.textAlignment = .left
        placeholder.font = self.placeholderFont
        placeholder.textColor = self.placeholderTextColor
        placeholder.text = self.placeholderText
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
        view.tintColor = UIColor.Colors.SMETextFieldLabel
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onIconTap))
        view.addGestureRecognizer(tapGestureRecognizer)

        return view
    }()
    
    private lazy var rightIconWrapperView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var footerLabel: UILabel = {
        let view = UILabel()

        view.font = UIFont.sfProText(ofSize: 12, weight: .regular)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = self.placeholderTextColor

        return view
    }()
    
    private lazy var errorLabel: UILabel = {
        let view = UILabel()

        view.font = UIFont.sfProText(ofSize: 12, weight: .regular)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = self.errorStateColor

        return view
    }()

    /// Creates a new text field of specified style.
    ///
    /// - Parameters:
    ///    - style: The style for field.
    ///
    public convenience init(localizedPlaceholder: String,
                            type: SMETextFieldInputType = .text) {
        self.init(frame: .zero)

        self.placeholderTextColor = UIColor.Colors.SMETextFieldLabel
        
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
        
        self.placeholderText = localizedPlaceholder
        
        self.setupViews()
        
        self.textFieldInputType = type
        
        self.prepareTextFieldByStyle(for: self.textFieldStyle)
        self.prepareTextFieldByType(for: type)
        
        self.customTextField.delegate = self.inputMaskDelegate

        self.customTextField.tintColor = self.placeholderCursorColor
        self.customTextField.textColor = self.textFieldTextColor
    }
    
    public convenience init(localizedPlaceholder: String,
                            type: SMETextFieldInputType = .text,
                            state: SMETextFieldState = .editing,
                            style: SMETextFieldStyle = .underlined) {
        self.init(frame: .zero)
        
        self.placeholderTextColor = UIColor.Colors.SMETextFieldLabel
        
        self.textFieldInputType = type
//        self.textFieldStyle = style
        
        self.placeholderText = localizedPlaceholder
        
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
        
        self.prepareTextFieldByStyle(for: style)
        self.prepareTextFieldByType(for: type)

        self.customTextField.delegate = self.inputMaskDelegate

        self.customTextField.tintColor = self.placeholderCursorColor
        self.customTextField.textColor = self.textFieldTextColor
        
        self.textFieldState = state
    }

    public convenience init() {
        self.init(frame: .zero)
    }
    
    private func prepareTextFieldByType(for type: SMETextFieldInputType) {
       
        switch type {
        case .text:
            self.customTextField.keyboardType = .alphabet
        case .number:
            self.customTextField.keyboardType = .numberPad
        case .amount:
            self.customTextField.keyboardType = .decimalPad
            self.maskFormat = "[0999999999]{.}[00]"
        case .phone:
            self.customTextField.keyboardType = .phonePad
        case .azPhone:
            self.customTextField.keyboardType = .phonePad
            self.maskFormat = "+994 [99] [999] [99] [99]"
        case .email:
            self.customTextField.keyboardType = .emailAddress
        case .date:
            self.customTextField.keyboardType = .numberPad
            self.maskFormat = "[00]{.}[00]{.}[0000]"
        case .password:
            self.customTextField.keyboardType = .default
            self.isSecured = true
            self.isRevealed = false
        case .select:
            self.textFieldState = .notEditing
            self.rightIconView.image = UIImage.Images.icSMEChevronBottom
//            self.customTextField.isUserInteractionEnabled = false
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onIconTap))
            self.customTextField.addGestureRecognizer(tapGestureRecognizer)
        // TODO: set bottom arrow Icon with state and dark mode
        case .pan:
            self.maskFormat = "[0000] [0000] [0000] [0000]"
            self.customTextField.keyboardType = .numberPad
        case .iban:
            self.maskFormat = "[AZ][00] [AZAZ] [0000] [0000] [0000] [0000]"
            self.customTextField.keyboardType = .numberPad
        case .custom(let maskFormat, let keyboardType, _, _, _, _):
            self.maskFormat = maskFormat
            self.customTextField.keyboardType = keyboardType
        }
        
    }
    
    private func validationByInputType() {
        switch self.textFieldInputType {
        case .email(let localizedError):
            self.isValid = SMETextFieldValidations.validateEmail(for: self.customTextField.text ?? "") ? .valid : .invalid(localizedError)
        case .azPhone(let localizedError):
            self.isValid = SMETextFieldValidations.validatePhone(for: self.customTextField.text?.components(separatedBy: .whitespaces).joined() ?? "") ? .valid : .invalid(localizedError)
        case .pan(let localizedError):
            self.isValid = SMETextFieldValidations.validateCardNumber(for: self.customTextField.text?.components(separatedBy: .whitespaces).joined() ?? "") ? .valid : .invalid(localizedError)
        case .custom(_, _, let minChar, let maxChar, let regex, let localizedMessage):
            self.isValid = SMETextFieldValidations.validateWithCustomRegex(for: self.customTextField.text ?? "", regex: regex) ? .valid : .invalid(localizedMessage)
            self.isValid = SMETextFieldValidations.validateCountRage(for: self.customTextField.text ?? "", minChar: minChar, maxChar: maxChar) ? .valid : .invalid(localizedMessage)
        default: break
        }
    }

    private func prepareTextFieldByStyle(for style: SMETextFieldStyle) {
        self.setupConstraints(for: style)
        self.setupStyleOfTextField(basedOn: style)
    }

    private func setupViews() {
        self.addSubview(self.customBorder)

        self.customBorder.addSubview(self.textFieldStack)
        self.rightIconWrapperView.addSubview(self.rightIconView)
        self.textFieldStack.addArrangedSubview(self.customTextField)
        self.textFieldStack.addArrangedSubview(self.rightIconWrapperView)

        self.customBorder.addSubview(self.customPlaceholder)
        
        self.addSubview(self.errorLabel)
        self.addSubview(self.footerLabel)
    }

    private func setupStyleOfTextField(basedOn style: SMETextFieldStyle) {
        switch style {
        case .bordered:
            self.textFieldStack.removeExistingBottomBorder()
        case .underlined:
            self.textFieldStack.addBottomBorder(thickness: 1.0, color: self.textFieldBottomBorderColor)
            self.customBorder.layer.borderWidth = 0.0
            self.customBorder.layer.borderColor = UIColor.clear.cgColor
        }
    }

    private func setupConstraints(for style: SMETextFieldStyle) {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
//            self.heightAnchor.constraint(equalToConstant: 64),
            self.customBorder.heightAnchor.constraint(equalToConstant: 50),
            self.customBorder.topAnchor.constraint(equalTo: self.topAnchor),
            self.customBorder.leftAnchor.constraint(equalTo: self.leftAnchor),
//            self.customBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.customBorder.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])

        switch style {
        case .bordered:
            NSLayoutConstraint.activate([
                self.textFieldStack.leftAnchor.constraint(equalTo: self.customBorder.leftAnchor, constant: self.leftPadding),
                self.textFieldStack.rightAnchor.constraint(equalTo: self.customBorder.rightAnchor, constant: -self.leftPadding),
                self.textFieldStack.centerYAnchor.constraint(equalTo: self.customBorder.centerYAnchor)
            ])

            NSLayoutConstraint.activate([
                self.errorLabel.topAnchor.constraint(equalTo: self.customBorder.bottomAnchor, constant: 4),
                self.errorLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: self.leftPadding),
                self.errorLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -self.leftPadding),
                self.footerLabel.topAnchor.constraint(equalTo: self.errorLabel.bottomAnchor, constant: 4),
                self.footerLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: self.leftPadding),
                self.footerLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -self.leftPadding)
            ])

        case .underlined:
            NSLayoutConstraint.activate([
                self.textFieldStack.leftAnchor.constraint(equalTo: self.customBorder.leftAnchor),
                self.textFieldStack.rightAnchor.constraint(equalTo: self.customBorder.rightAnchor),
                self.textFieldStack.bottomAnchor.constraint(equalTo: self.customBorder.bottomAnchor)
            ])

            NSLayoutConstraint.activate([
                self.errorLabel.topAnchor.constraint(equalTo: self.customBorder.bottomAnchor, constant: 4),
                self.errorLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
                self.errorLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
//                self.errorLabel.bottomAnchor.constraint(equalTo: self.footerLabel.topAnchor),
                
                self.footerLabel.topAnchor.constraint(equalTo: self.errorLabel.bottomAnchor, constant: 4),
                self.footerLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
                self.footerLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
//                self.footerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        }
        print("ERROR STP:::---")
        
        NSLayoutConstraint.activate([
            self.customPlaceholder.widthAnchor.constraint(equalTo: self.customTextField.widthAnchor)
        ])
        
//        NSLayoutConstraint.activate([
//            self.heightAnchor.constraint(equalToConstant: 64),
//            self.errorLabel.heightAnchor.constraint(equalToConstant: 0)
//        ])
        
        self.validConstraints = [
            self.heightAnchor.constraint(equalToConstant: 64),
            self.errorLabel.heightAnchor.constraint(equalToConstant: 0)
        ]
        
        self.invalidConstraints = [
            self.heightAnchor.constraint(equalToConstant: 84),
            self.errorLabel.heightAnchor.constraint(equalToConstant: 16)
        ]
        
        self.validWithLabelConstraints = [
            self.heightAnchor.constraint(equalToConstant: 100),
            self.errorLabel.heightAnchor.constraint(equalToConstant: 0)
        ]
        
        self.invalidWithLabelConstraints = [
            self.heightAnchor.constraint(equalToConstant: 120),
            self.errorLabel.heightAnchor.constraint(equalToConstant: 16)
        ]
        
        self.activeValidationLabelConstraints = self.validConstraints
        NSLayoutConstraint.activate(self.activeValidationLabelConstraints)
        
        self.notEditingConstraints = [
            self.customPlaceholder.leftAnchor.constraint(equalTo: self.customTextField.leftAnchor),
            self.customPlaceholder.centerYAnchor.constraint(equalTo: self.customTextField.centerYAnchor)
        ]
        
        self.activeConstraints = self.notEditingConstraints
        NSLayoutConstraint.activate(self.activeConstraints)
        
        self.setupRightIconConstraints(for: self.iconSize)
    }

    private func setupRightIconConstraints(for iconSize: RightIconSize) {
        NSLayoutConstraint.deactivate(self.activeRightIconConstraints)

        switch iconSize {
        case .small:
            self.activeRightIconConstraints = [
                self.rightIconView.heightAnchor.constraint(equalToConstant: 16.0),
                self.rightIconView.widthAnchor.constraint(equalToConstant: 16.0),
                self.rightIconView.centerXAnchor.constraint(equalTo: self.rightIconWrapperView.centerXAnchor),
                self.rightIconView.centerYAnchor.constraint(equalTo: self.rightIconWrapperView.centerYAnchor),
                self.rightIconWrapperView.heightAnchor.constraint(equalTo: self.rightIconView.heightAnchor, constant: 8),
                self.rightIconWrapperView.widthAnchor.constraint(equalTo: self.rightIconView.widthAnchor, constant: 8),
            ]

        case .regular:
            self.activeRightIconConstraints = [
                self.rightIconView.heightAnchor.constraint(equalToConstant: 24.0),
                self.rightIconView.widthAnchor.constraint(equalToConstant: 24.0),
                self.rightIconView.centerXAnchor.constraint(equalTo: self.rightIconWrapperView.centerXAnchor),
                self.rightIconView.centerYAnchor.constraint(equalTo: self.rightIconWrapperView.centerYAnchor),
                self.rightIconWrapperView.heightAnchor.constraint(equalTo: self.rightIconView.heightAnchor, constant: 8),
                self.rightIconWrapperView.widthAnchor.constraint(equalTo: self.rightIconView.widthAnchor, constant: 8),
            ]

        case .custom(let iconSize):
            self.activeRightIconConstraints = [
                self.rightIconView.heightAnchor.constraint(equalToConstant: iconSize.height),
                self.rightIconView.widthAnchor.constraint(equalToConstant: iconSize.width),
                self.rightIconView.centerXAnchor.constraint(equalTo: self.rightIconWrapperView.centerXAnchor),
                self.rightIconView.centerYAnchor.constraint(equalTo: self.rightIconWrapperView.centerYAnchor),
                self.rightIconWrapperView.heightAnchor.constraint(equalTo: self.rightIconView.heightAnchor, constant: 8),
                self.rightIconWrapperView.widthAnchor.constraint(equalTo: self.rightIconView.widthAnchor, constant: 8),
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
        
        NSLayoutConstraint.deactivate(self.activeValidationLabelConstraints)

        switch self.isValid {
        case .valid:
            self.errorLabel.isHidden = true
            
            if let footerLabelText = self.footerLabelText {
                self.activeValidationLabelConstraints = self.validWithLabelConstraints
            } else {
                self.activeValidationLabelConstraints = self.validConstraints
            }
//            self.layoutIfNeeded()
        case .invalid(let error):
            self.errorLabel.isHidden = false
            self.errorLabel.textColor = self.errorStateColor
            self.errorLabel.text = error
            
            if let footerLabelText = self.footerLabelText {
                self.activeValidationLabelConstraints = self.invalidWithLabelConstraints
            } else {
                self.activeValidationLabelConstraints = self.invalidConstraints
            }
            
//            self.layoutIfNeeded()
        }
        
        NSLayoutConstraint.activate(self.activeValidationLabelConstraints)
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
            case .disabled:
                print("DISABLED:::---")
                self.customPlaceholder.textColor = self.placeholderTextColor.withAlphaComponent(0.3)
                self.customTextField.isEnabled = false
                self.textFieldTextColor = self.placeholderTextColor.withAlphaComponent(0.3)
                self.customTextField.textColor = self.placeholderTextColor.withAlphaComponent(0.3)
            }
        case .invalid:
            self.performAnimation { [weak self] in
                guard let self = self else { return }
//                self.customPlaceholder.textColor = self.errorStateColor
                self.customPlaceholder.textColor = self.placeholderTextColor
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
                    self.rightIconView.tintColor = UIColor.Colors.SMETextFieldLabel
                }
            case .disabled: 
                print("DISABLED:::---")
                self.customPlaceholder.textColor = self.placeholderTextColor.withAlphaComponent(0.3)
                self.customTextField.isEnabled = false
                self.customTextField.textColor = self.placeholderTextColor.withAlphaComponent(0.3)
                self.textFieldTextColor = self.placeholderTextColor.withAlphaComponent(0.3)
            }
        case .invalid:
            self.performAnimation { [weak self] in
                guard let self = self else { return }
//                self.customPlaceholder.textColor = self.errorStateColor
                self.customPlaceholder.textColor = self.placeholderTextColor
                self.customBorder.layer.borderColor = self.errorStateColor.cgColor
                self.textFieldStack.updateExistingBottomBorderThickness(to: 1.0)
                self.textFieldStack.updateExistingBottomBorderColor(to: self.errorStateColor)
            }
        }
    }

    private func calculateEditingConstraints() -> [NSLayoutConstraint] {
        let originalWidth = customPlaceholder.bounds.width
        let xOffset = (originalWidth - (originalWidth * placeholderSizeFactor)) / 2

        switch self.textFieldStyle {
        case .bordered:
            return [
                self.customPlaceholder.topAnchor.constraint(equalTo: self.topAnchor, constant: 6.0),
                self.customPlaceholder.leftAnchor.constraint(equalTo: self.textFieldStack.leftAnchor, constant: -xOffset)
            ]
        case .underlined:
            return [
                self.customPlaceholder.bottomAnchor.constraint(equalTo: self.textFieldStack.topAnchor, constant: self.topPadding),
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
        case .disabled:
            print("DISABLED:::---")
            self.customPlaceholder.textColor = self.placeholderTextColor.withAlphaComponent(0.3)
            self.customTextField.isEnabled = false
            self.customTextField.textColor = self.placeholderTextColor.withAlphaComponent(0.3)
            self.textFieldTextColor = self.placeholderTextColor.withAlphaComponent(0.3)
        }
    }

    private func animatePlaceholderToActivePosition(animated: Bool = true) {
        NSLayoutConstraint.deactivate(self.activeConstraints)
        self.activeConstraints = self.calculateEditingConstraints()
        NSLayoutConstraint.activate(self.activeConstraints)

        if animated {
            self.performAnimation {
                self.layoutIfNeeded()
                
                self.customPlaceholder.transform = CGAffineTransform(scaleX: self.placeholderSizeFactor, y: self.placeholderSizeFactor)

                if self.textFieldStyle == .bordered {
                    self.customTextField.transform = CGAffineTransform(translationX: 0, y: 8)
                }
            }
        } else {
            self.layoutIfNeeded()

            self.customPlaceholder.transform = CGAffineTransform(scaleX: self.placeholderSizeFactor, y: self.placeholderSizeFactor)
            
            if self.textFieldStyle == .bordered {
                self.customTextField.transform = CGAffineTransform(translationX: 0, y: 8)
            }
        }
    }

    private func animatePlaceholderToInactivePosition(animated: Bool = true) {
        NSLayoutConstraint.deactivate(self.activeConstraints)
        self.activeConstraints = self.notEditingConstraints
        NSLayoutConstraint.activate(self.activeConstraints)

        if animated {
            self.performAnimation {
                self.customPlaceholder.transform = .identity
                self.customTextField.transform = .identity

                self.layoutIfNeeded()
            }
        } else {
            self.customPlaceholder.transform = .identity
            self.customTextField.transform = .identity

            self.layoutIfNeeded()
        }
    }

    private func setTheme() {
        self.placeholderCursorColor = self.theme.getPrimaryColor()
        self.editingBorderColor = self.theme.getPrimaryColor()
        self.textFieldBottomBorderColor = UIColor.Colors.SMEBackgroundGray
    }

    private func updateSecureEntry() {
        self.customTextField.isSecureTextEntry = self.isSecured && !self.isRevealed

        if self.isSecured {
            if self.isRevealed {
                self.rightIconView.image = UIImage.Images.icRevealOpen
            }
            else {
                self.rightIconView.image = UIImage.Images.icRevealClosed
            }
        }
    }
    
    private func validateField() {
        if self.validationCredentials.regex != "" {
            self.isValid = SMETextFieldValidations.validateWithCustomRegex(for: self.customTextField.text ?? "", regex: self.validationCredentials.regex) ? .valid : .invalid(self.validationCredentials.localizedErrorMessage)
        }
    }

    @objc private func onIconTap() {
        self.onActionIcon?()
        
        switch self.textFieldInputType {
        case .password:
            self.isRevealed = !self.isRevealed
        default:
            break
        }
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
    public func makeFirstResponder() {
        self.customTextField.becomeFirstResponder()
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

    /// Resigns text field from being first responder.
    ///
    public func undoFirstResponder() {
        self.customTextField.resignFirstResponder()
    }

    override public func resignFirstResponder() -> Bool {
        self.customTextField.resignFirstResponder()
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
}

extension SMETextField: MaskedTextFieldDelegateListener {
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
        if cleanText.count > 1 {
            self.validateField()
        }
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
        self.validationByInputType()
        self.validateField()
    }
}
