//
//  PBSelectableCardView.swift
//  
//
//  Created by Murad on 11.12.22.
//

import UIKit

public class PBSelectableCardView: PBBaseSelectableView {

    private lazy var issuerLogo: UIImageView = {
        let view = UIImageView()

        self.addSubview(view)

        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false

        view.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        view.heightAnchor.constraint(equalToConstant: 24.0).isActive = true

        return view
    }()

    private lazy var cardDetails: UILabel = {
        let label = UILabel()

        self.addSubview(label)

        label.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var balanceLabel: UILabel = {
        let label = UILabel()

        self.addSubview(label)

        label.textColor = .darkText
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var checkBoxDefault: UIImageView = {
        let view = UIImageView()

        self.addSubview(view)

        view.image = UIImage()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false

        view.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        view.widthAnchor.constraint(equalToConstant: 20.0).isActive = true

        return view
    }()

    private lazy var checkBoxSelected: UIImageView = {
        let view = UIImageView()

        self.addSubview(view)
        
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false

        view.image = UIImage(named: "ic_checked_circular", in: Bundle.module, compatibleWith: nil)

        view.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        view.widthAnchor.constraint(equalToConstant: 20.0).isActive = true

        return view
    }()

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public convenience init() {
        self.init(frame: .zero)
        self.setupViews()
    }

    override func setupViews() {
        super.setupViews()

        self.setupConstraints()
        self.checkBoxDefault.alpha = 1.0
        self.checkBoxSelected.alpha = 0.0
    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([
            self.issuerLogo.topAnchor.constraint(equalTo: self.topAnchor, constant: 12.0),
            self.issuerLogo.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12.0)
        ])

        NSLayoutConstraint.activate([
            self.checkBoxDefault.topAnchor.constraint(equalTo: self.topAnchor, constant: 12.0),
            self.checkBoxDefault.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12.0),
        ])

        NSLayoutConstraint.activate([
            self.checkBoxSelected.topAnchor.constraint(equalTo: self.topAnchor, constant: 12.0),
            self.checkBoxSelected.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12.0)
        ])

        NSLayoutConstraint.activate([
            self.balanceLabel.topAnchor.constraint(equalTo: self.issuerLogo.bottomAnchor, constant: 4.0),
            self.balanceLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12.0),
            self.balanceLabel.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -12.0)
        ])

        NSLayoutConstraint.activate([
            self.cardDetails.topAnchor.constraint(equalTo: self.balanceLabel.bottomAnchor, constant: 4.0),
            self.cardDetails.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12.0),
            self.cardDetails.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -12.0),
            self.cardDetails.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12.0)
        ])
    }

    public func setData(data: PBCardRepresentable, isSelected: Bool, isValid: Bool) {
        self.issuerLogo.image = data.issuerLogoColored
        self.balanceLabel.text = data.balance
        self.cardDetails.text = data.displayName
        self.isSelected = isSelected
    }

    override func updateUI() {
        super.updateUI()

        if self.isSelected {
            self.checkBoxDefault.alpha = 0.0
            self.checkBoxSelected.alpha = 1.0
        } else {
            self.checkBoxDefault.alpha = 1.0
            self.checkBoxSelected.alpha = 0.0
        }
    }

    public override func setTheme() {
        super.setTheme()

        switch self.theme {
        case .regular:
            self.checkBoxSelected.image = UIImage(named: "ic_checked_circular", in: Bundle.module, compatibleWith: nil)
        case .dark:
            self.checkBoxSelected.image = UIImage(named: "ic_checked_circular_private", in: Bundle.module, compatibleWith: nil)
        }
    }

    public func makeInvalid() {
        self.selectedBorderColor = .systemRed
        self.selectedStateColor = .systemRed.withAlphaComponent(0.1)
        self.checkBoxSelected.image = UIImage(named: "ic_checked_circular_red", in: Bundle.module, compatibleWith: nil)
    }
}

