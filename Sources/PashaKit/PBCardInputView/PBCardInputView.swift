//
//  PBCardInputView.swift
//  
//
//  Created by Murad on 09.12.22.
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

/// `PBCardInputView` is subclass of `UIView` used for entering card information.
///
/// As a component it's designed to resemble real bank card with textfields for entering card details.
/// Depending on the user type card's color changes to black, green.
///
open class PBCardInputView: UIView {

    /// An enum for specifying the main components of card input
    ///
    public enum CardInputComponents {
        case pan
        case expiryDate
        case cvv
        case scanner
    }

    /// Theme for `PBCardInputView`
    ///
    /// If not specified card will created with `regular` theme.
    ///
    public var theme: PBCardInputViewTheme = .regular {
        didSet {
            self.setTheme()
        }
    }

    private let cornerRadius: CGFloat = 12.0

    private lazy var bankLogo: UIImageView = {
        let view = UIImageView()

        self.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.isHidden = true

        view.heightAnchor.constraint(equalToConstant: 32.0).isActive = true

        return view
    }()

    private lazy var cardScan: UIButton = {
        let button = UIButton()

        self.addSubview(button)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage.Images.icCardScan, for: .normal)
        button.addTarget(self, action: #selector(onScanButton), for: .touchUpInside)

        button.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40.0).isActive = true

        return button
    }()

    private lazy var cardNumberTitle: UILabel = {
        let view = UILabel()

        self.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        view.textColor = UIColor.Colors.PBGraySecondary

        view.widthAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true

        return view
    }()

    private lazy var cardNumberField: PBMaskableUITextField = {
        let view =  PBMaskableUITextField()

        self.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 24.0)
        view.keyboardType = .numberPad
        view.maskFormat = "[NNNN] [NNNN] [NNNN] [NNNN]"
        view.attributedPlaceholder = NSAttributedString(
            string: "0000 0000 0000 0000",
            attributes: [
                .foregroundColor: UIColor.Colors.PBGraySecondary
            ]
        )
        view.textColor = .white

        view.onMaskComplete = { [weak self] complete in
            if complete {
                self?.cardExpirationDateField.becomeFirstResponder()
            }
        }

        return view
    }()

    private lazy var cardExpirationDateTitle: UILabel = {
        let view = UILabel()

        self.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        view.textColor = UIColor.Colors.PBGraySecondary

        view.widthAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true

        return view
    }()

    private lazy var cardExpirationDateField: PBMaskableUITextField = {
        let view =  PBMaskableUITextField()

        self.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 24.0)
        view.maskFormat = "[00] / [00]"
        view.keyboardType = .numberPad
        view.placeholder = "00 / 00"
        view.attributedPlaceholder = NSAttributedString(
            string: "00 / 00",
            attributes: [
                .foregroundColor: UIColor.Colors.PBGraySecondary
            ]
        )
        view.textColor = .white

        view.onMaskComplete = { [weak self] complete in
            if complete {
                self?.cardCVVField.becomeFirstResponder()
            }
        }

        return view
    }()

    private lazy var cardCVVTitle: UILabel = {
        let view = UILabel()

        self.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        view.textColor = UIColor.Colors.PBGraySecondary

        view.widthAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true

        return view
    }()

    private lazy var cardCVVField: PBMaskableUITextField = {
        let view =  PBMaskableUITextField()

        self.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 24.0)
        view.keyboardType = .numberPad
        view.maskFormat = "[000]"
        view.placeholder = "000"
        view.isSecured = true
        view.hasBottomBorder = true
        view.attributedPlaceholder = NSAttributedString(
            string: "***",
            attributes: [
                .foregroundColor: UIColor.Colors.PBGraySecondary
            ]
        )
        view.textColor = .white

        view.onMaskComplete = { [weak self] complete in
            if complete {
                self?.cardCVVField.resignFirstResponder()
            }
        }

        return view
    }()

    private lazy var issuerLogo: UIImageView = {
        let view = UIImageView()

        self.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.isHidden = true

        return view
    }()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews()
    }

    /// Creates `PBCardInputView` with proper title texts for entering input
    ///
    public convenience init(
        localizableCardNumberTitle: String,
        localizableCardExpirationDateTitle: String,
        localizableCardCVVTitle: String
    ) {
        self.init(frame: .zero)
        self.cardNumberTitle.text = localizableCardNumberTitle
        self.cardExpirationDateTitle.text = localizableCardExpirationDateTitle
        self.cardCVVTitle.text = localizableCardCVVTitle
    }

    private func setupViews() {
        self.layer.cornerRadius = self.cornerRadius
        self.layer.masksToBounds = true
        
        self.setTheme()
        self.setupConstraints()
    }

    private func setTheme() {
        self.backgroundColor = theme.getPrimaryColor()

        switch self.theme {
        case .regular:
            self.cardScan.setImage(UIImage.Images.icCardScan, for: .normal)
        case .dark:
            self.cardScan.setImage(UIImage.Images.icCardScanPrivateBlack, for: .normal)
        }
    }

    private func setupConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.cardScan.topAnchor.constraint(equalTo: self.topAnchor, constant: 16.0),
            self.cardScan.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16.0)
        ])

        NSLayoutConstraint.activate([
            self.bankLogo.topAnchor.constraint(equalTo: self.topAnchor, constant: 20.0),
            self.bankLogo.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16.0)
        ])

        NSLayoutConstraint.activate([
            self.cardNumberTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 68.0),
            self.cardNumberTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16.0)
        ])

        NSLayoutConstraint.activate([
            self.cardNumberField.topAnchor.constraint(equalTo: self.cardNumberTitle.bottomAnchor),
            self.cardNumberField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16.0),
            self.cardNumberField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16.0)
        ])

        NSLayoutConstraint.activate([
            self.cardExpirationDateTitle.bottomAnchor.constraint(equalTo: self.cardExpirationDateField.topAnchor),
            self.cardExpirationDateTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16.0)
        ])

        NSLayoutConstraint.activate([
            self.cardExpirationDateField.widthAnchor.constraint(equalToConstant: 80.0),
            self.cardExpirationDateField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16.0),
            self.cardExpirationDateField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16.0)
        ])

        NSLayoutConstraint.activate([
            self.cardCVVTitle.bottomAnchor.constraint(equalTo: self.cardCVVField.topAnchor),
            self.cardCVVTitle.leftAnchor.constraint(equalTo: self.cardCVVField.leftAnchor)
        ])

        NSLayoutConstraint.activate([
            self.cardCVVField.widthAnchor.constraint(equalToConstant: 48.0),
            self.cardCVVField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16.0),
            self.cardCVVField.leftAnchor.constraint(equalTo: self.cardExpirationDateField.rightAnchor, constant: 56.0)
        ])

        NSLayoutConstraint.activate([
            self.issuerLogo.widthAnchor.constraint(equalToConstant: 74.0),
            self.issuerLogo.heightAnchor.constraint(equalToConstant: 42.0),
            self.issuerLogo.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16.0),
            self.issuerLogo.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16.0)
        ])
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        self.cardNumberField.tintColor = self.theme.getCursorColor()
        self.cardExpirationDateField.tintColor = self.theme.getCursorColor()
        self.cardCVVField.tintColor = self.theme.getCursorColor()
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: self.bounds.width * (472/750))
        ])
    }

    /// Defines validation state of input fields based on `validation` parameter
    ///
    /// - Parameters:
    ///  - `validation`: Contains valid states of all input fields. All of them are separately evaluated.
    ///  For example, pan field may be invalid, while others still being valid
    ///
    ///  Depending on such kind of states, input fields' text colors will change to `systemRed` or `PBGraySecondary`
    ///
    public func set(validation: PBCardInputValidatable) {
        self.updateUI(for: self.cardNumberField, with: validation.isPanValid)
        self.updateUI(for: self.cardExpirationDateField, with: validation.isExpireDateValid)
        self.updateUI(for: self.cardCVVField, with: validation.isCVVValid)
    }

    private func updateUI(
        for textField: PBMaskableUITextField,
        with isValid: Bool
    ) {
        textField.textColor = isValid ? UIColor.Colors.PBGraySecondary : .systemRed
        textField.isValid = isValid
    }

    /// Puts `number` into card number input field
    ///
    public func setCard(number: String) {
        self.cardNumberField.set(text: number)
    }

    /// Puts `expiryDate` into card expiration date field
    ///
    public func setCard(expiryDate: String) {
        self.cardExpirationDateField.set(text: expiryDate)
    }

    /// Sets issuer logo for view
    ///
    /// By default issuer image is set to`nil`
    ///
    public func setCard(issuerLogo: UIImage?) {
        self.issuerLogo.image = issuerLogo
    }

    /// Gets card info from input fields.
    ///
    public func getCard() -> PBCardInfoRepresentable {
        let cardNumber = self.cardNumberField.text?.replacingOccurrences(of: " ", with: "") ?? ""
        let expirationDate = self.cardExpirationDateField.text?.replacingOccurrences(of: " ", with: "") ?? ""
        let cvvNumber = self.cardCVVField.text?.replacingOccurrences(of: " ", with: "") ?? ""

        return CardInput(panNumber: cardNumber, expireDate: expirationDate, cvvNumber: cvvNumber)
    }

    /// A helper method for toggling  `isHidden` property of components..
    ///
    public func updateVisibility(for component: CardInputComponents, to isVisible: Bool) {
        switch component {
        case .pan:
            self.cardNumberTitle.isHidden = !isVisible
            self.cardNumberField.isHidden = !isVisible
        case .expiryDate:
            self.cardExpirationDateTitle.isHidden = !isVisible
            self.cardExpirationDateField.isHidden = !isVisible
        case .cvv:
            self.cardCVVTitle.isHidden = !isVisible
            self.cardCVVField.isHidden = !isVisible
        case .scanner:
            self.cardScan.isHidden = !isVisible
        }
    }

    /// A helper method for toggling  `isUserInteractionEnabled` property of components...
    ///
    public func updateUserInteractionAllowance(for component: CardInputComponents, to isEnabled: Bool) {
        switch component {
        case .pan:
            self.cardNumberField.isUserInteractionEnabled = isEnabled
        case .expiryDate:
            self.cardExpirationDateField.isUserInteractionEnabled = isEnabled
        case .cvv:
            self.cardCVVField.isUserInteractionEnabled = isEnabled
        case .scanner:
            self.cardCVVField.isUserInteractionEnabled = isEnabled
        }
    }

    public func addDoneButtonOnKeyboard(title: String) {
        self.cardNumberField.addDoneButtonOnKeyboard(title: title)
        self.cardExpirationDateField.addDoneButtonOnKeyboard(title: title)
        self.cardCVVField.addDoneButtonOnKeyboard(title: title)
    }

    @objc func onScanButton(_ sender: UIButton) {
        self.onCardScanClicked?()
    }

    // MARK: - CALLBACKS
    public var onCardScanClicked: (() -> Void)?
}

extension PBCardInputView {
    private struct CardInput: PBCardInfoRepresentable {
        var panNumber: String
        var expireDate: String
        var cvvNumber: String
    }
}
