//
//  PBSelectableCardView.swift
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

/// `PBSelectableCardView` is a subclass of `PBBaseSelectableVie` made for
/// representing cards.
///
/// **View Structure**
/// `PBSelectableCardView` consists of different idnependent subviews. These are:
///  - `issuerLogo`- holds icon of card issuer. In most cases, this will be "Visa" or "MasterCard".
///  - `cardDetails` - includes masked card number, issuer logo and card type.
///  - `balanceLabel`- holds balance of card.
///  - `checkboxDefault`- holds default checkbox icon.
///  - `checkboxSelected`- holds selected checkbox icon.
///
/// While laying out subviews, checkbox default and checkbox selected been put in the same places. But depending
/// on `isSelected` state, these image's alpha changes respectively and creates "selection" effect.
/// 
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

        view.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
        view.widthAnchor.constraint(equalToConstant: 24.0).isActive = true

        return view
    }()

    private lazy var checkBoxSelected: UIImageView = {
        let view = UIImageView()

        self.addSubview(view)
        
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false

        view.image = UIImage.Images.icCheckedCircular

        view.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
        view.widthAnchor.constraint(equalToConstant: 24.0).isActive = true

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

    /// Sets card data for a selectable card view.
    ///
    /// - Parameters:
    ///    - data: gets card info as a struct which conforms to `PBCardRepresentable` protocol.
    ///    - isSelected: sets view selection state
    ///    - isValid: sets view validity
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
            self.checkBoxSelected.tintColor = UIColor.Colors.PBGreen
        case .dark:
            self.checkBoxSelected.tintColor = UIColor.Colors.PBFauxChestnut
        }
    }

    public func makeInvalid() {
        self.selectedBorderColor = UIColor.Colors.PBRed
        self.selectedStateColor = .systemRed.withAlphaComponent(0.1)
        self.checkBoxSelected.tintColor = UIColor.Colors.PBRed
    }
}

