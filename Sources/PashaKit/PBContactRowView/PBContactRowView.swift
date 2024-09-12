//
//  PBContactRowView.swift
//  
//
//  Created by Murad on 12.12.22.
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

/// `PBContactRowView` is type of `UIView` used for representing contact information
/// while having an option to show card information.
///
/// Contact view has three main parts:
/// - `letterLabel` - `UILabel` instance which represents contact's first letters of name and last name with circular background
/// - `contactInfoStackView` - `UIStackView` instance which holds textual informations with contact's name and their numbers.
/// - `cardInfoStackView` - `UIStackView` instance which holds issuer logo and masked card number information of contact's available card
///
open class PBContactRowView: UIView {

    // MARK: - Public Properties

    /// A boolean value for showing card info
    ///
    /// If `showsCardInfo` is set to `true`, contact view will have info view. If card details are not
    /// entered, this view will empty view while keeping space at the right side of view.
    ///
    public var showsCardInfo: Bool = false {
        didSet {
            if self.showsCardInfo {
                self.cardInfoStackView.isHidden = false
            } else {
                self.cardInfoStackView.isHidden = true
            }
        }
    }

    /// Changes issuer logo based on its value's prefix.
    ///
    /// If first character of card is equal to 4, `issuerLogo` image will be MasterCard logo,
    /// elsewhere it will be setted with `Visa` logo
    ///
    public var cardID: String = "" {
        didSet {
            if self.cardID.prefix(1) == "4" {
                self.issuerLogoView.image = UIImage.Images.icVisaLogoColored
            } else {
                self.issuerLogoView.image = UIImage.Images.icMasterLogoColored
            }

            self.cardNumberLabel.text = cardID.lastFourDigits
        }
    }

    /// Background color for `letterLabel`
    ///
    /// By default `letterLabel` doesn't have any background color.
    ///
    public var shortLabelBackgroundColor: UIColor? {
        didSet {
            self.letterLabel.backgroundColor =  self.shortLabelBackgroundColor
        }
    }

    // MARK: - Private Properties

    private var contactName: String = "" {
        didSet {
            guard self.contactName.isEmpty == false else {
                self.contactNameLabel.removeFromSuperview()
                return
            }

            self.contactNameLabel.text = self.contactName
        }
    }

    private var contactNumber: String = "" {
        didSet {
            guard self.contactNumber.isEmpty == false else {
                self.contactNumberLabel.removeFromSuperview()
                return
            }

            self.contactNumberLabel.text = self.contactNumber
        }
    }

    private lazy var primaryStackView: UIStackView = {
        let view = UIStackView()

        self.addSubview(view)

        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 12

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var contactInfoStackView: UIStackView = {
        let view = UIStackView()

        self.addSubview(view)

        view.axis = .vertical
        view.alignment = .fill
        view.spacing = 2.0

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var cardInfoStackView: UIStackView = {
        let view = UIStackView()

        self.addSubview(view)

        view.axis = .vertical
        view.alignment = .fill
        view.spacing = 2.0

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var letterLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.backgroundColor = UIColor.Colors.PBGreen
        label.textColor = .white
        label.textAlignment = .center
        label.set(cornerRadius: 20.0)
        label.layer.masksToBounds = true

        label.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        label.heightAnchor.constraint(equalToConstant: 40.0).isActive = true

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var contactNameLabel: UILabel = {
        let label = UILabel()

        self.addSubview(label)

        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .darkText
        label.textAlignment = .left

        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)

        return label
    }()

    private lazy var contactNumberLabel: UILabel = {
        let label = UILabel()

        self.addSubview(label)

        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(red: 0.529, green: 0.529, blue: 0.545, alpha: 1)
        label.textAlignment = .left

        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)

        return label
    }()

    private lazy var issuerLogoView: UIImageView = {
        let view = UIImageView()

        view.contentMode = .scaleAspectFit

        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        return view
    }()

    private lazy var cardNumberLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .darkText
        label.textAlignment = .center

        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        return label
    }()

    public required override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupViews()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        if self.contactInfoStackView.arrangedSubviews.count == 1 {
            self.contactInfoStackView.spacing = 0
        } else {
            self.contactInfoStackView.spacing = 2.0
        }
    }

    /// Sets the contact and card information into row view components.
    ///
    /// - Parameters:
    ///  - contact: accepts any entity conforming to `PBContactRepresentable` protocol. It holds contact's name, lastName, phoneNumber
    ///  - cardID: wrapped pan number of card
    ///
    public func setData(contact: PBContactRepresentable, cardID: String = "", isContactNumberHidden: Bool = false) {
        self.contactName = contact.name + " " + contact.lastName

        if isContactNumberHidden {
            self.contactNumber = ""
        } else {
            self.contactNumber = contact.phoneNumber
        }

        self.letterLabel.text = "\(contact.name.prefix(1))\(contact.lastName.prefix(1))"
        self.cardID = cardID
    }

    private func setupViews() {

        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1)
        self.layer.masksToBounds = true
        self.set(cornerRadius: 10.0)

        self.primaryStackView.addArrangedSubview(self.letterLabel)
        self.primaryStackView.addArrangedSubview(self.contactInfoStackView)
        self.primaryStackView.addArrangedSubview(self.cardInfoStackView)

        self.contactInfoStackView.addArrangedSubview(self.contactNameLabel)
        self.contactInfoStackView.addArrangedSubview(self.contactNumberLabel)
        self.cardInfoStackView.addArrangedSubview(self.issuerLogoView)
        self.cardInfoStackView.addArrangedSubview(self.cardNumberLabel)

        self.setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.primaryStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12.0),
            self.primaryStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16.0),
            self.primaryStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12.0),
            self.primaryStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16.0)
        ])
    }
}
