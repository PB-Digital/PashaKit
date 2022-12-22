//
//  PBContactRowView.swift
//  
//
//  Created by Murad on 12.12.22.
//

import UIKit

open class PBContactRowView: UIView {

    public var showsCardInfo: Bool = false {
        didSet {
            if self.showsCardInfo {
                self.cardInfoStackView.isHidden = false
            } else {
                self.cardInfoStackView.isHidden = true
            }
        }
    }

    public var cardID: String = "" {
        didSet {
            if self.cardID.prefix(1) == "4" {
                self.issuerLogo.image = UIImage(named: "ic_master_logo_colored", in: Bundle.module, compatibleWith: nil)
            } else {
                self.issuerLogo.image = UIImage(named: "ic_visa_logo_colored", in: Bundle.module, compatibleWith: nil)
            }

            self.cardNumberLabel.text = cardID.lastFourDigits
        }
    }

    public var shortLabelBackgroundColor: UIColor? {
        didSet {
            self.letterLabel.backgroundColor =  self.shortLabelBackgroundColor
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
        label.layer.cornerRadius = 20.0
        label.layer.masksToBounds = true

        label.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        label.heightAnchor.constraint(equalToConstant: 40.0).isActive = true

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var contactName: UILabel = {
        let label = UILabel()

        self.addSubview(label)

        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .darkText
        label.textAlignment = .left

        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)

        return label
    }()

    private lazy var contactNumber: UILabel = {
        let label = UILabel()

        self.addSubview(label)

        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(red: 0.529, green: 0.529, blue: 0.545, alpha: 1)
        label.textAlignment = .left

        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)

        return label
    }()

    private lazy var issuerLogo: UIImageView = {
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

    public func setData(contact: PBContactRepresentable, cardID: String = "") {
        self.contactName.text = contact.name + " " + contact.lastName
        self.contactNumber.text = contact.phoneNumber
        self.letterLabel.text = "\(contact.name.prefix(1))\(contact.lastName.prefix(1))"
        self.cardID = cardID
    }

    private func setupViews() {

        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10.0

        self.primaryStackView.addArrangedSubview(self.letterLabel)
        self.primaryStackView.addArrangedSubview(self.contactInfoStackView)
        self.primaryStackView.addArrangedSubview(self.cardInfoStackView)

        self.contactInfoStackView.addArrangedSubview(self.contactName)
        self.contactInfoStackView.addArrangedSubview(self.contactNumber)
        self.cardInfoStackView.addArrangedSubview(self.issuerLogo)
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
