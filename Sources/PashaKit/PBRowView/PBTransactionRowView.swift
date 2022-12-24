//
//  PBTransactionRowView.swift
//  
//
//  Created by Murad on 06.12.22.
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

public class PBTransactionRowView: UIView, PBSkeletonable {
    public var showsDivider: Bool = false {
        didSet {
            self.divider.isHidden = !showsDivider
        }
    }

    public var dividerStyle: DividerStyle = .partial {
        didSet {
            self.setupDividerConstraints(by: self.dividerStyle)
        }
    }

    public var categoryIcon: UIImage?  {
        didSet {
            if self.categoryIcon != oldValue {
                self.categoryImage.image = self.categoryIcon
                self.setupViews()
            }
        }
    }

    public var leftIconStyle: Style = .roundedRect(cornerRadius: 8.0) {
        didSet {
            switch self.leftIconStyle {
            case .roundedRect(cornerRadius: let cornerRadius):
                self.categoryImage.layer.cornerRadius = cornerRadius
            case .circle:
                self.categoryImage.layer.cornerRadius = 20.0
            }
        }
    }

    public var isChevronIconVisible: Bool = false {
        didSet {
            if self.isChevronIconVisible != oldValue {
                self.setupViews()
            }
        }
    }

    private var activeConstraints: [NSLayoutConstraint] = []

    private lazy var primaryStackView: UIStackView = {
        let view = UIStackView()

        self.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false

        view.alignment = .center
        view.axis = .horizontal
        view.spacing = 12.0

        return view
    }()

    private lazy var transactionInfoContainerView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var categoryImage: UIImageView = {
        let view = UIImageView()

        view.translatesAutoresizingMaskIntoConstraints = false

        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.Colors.PBGraySecondary
        view.isSkeletonable = true

        view.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        view.widthAnchor.constraint(equalToConstant: 40.0).isActive = true

        return view
    }()

    lazy var merchantLabel: UILabel = {
        let label = UILabel()

        self.transactionInfoContainerView.addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false

        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 1
        label.isSkeletonable = true

        return label
    }()

    lazy var descriptionLabel: UILabel = {
        let label = UILabel()

        self.transactionInfoContainerView.addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false

        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor.black.withAlphaComponent(0.6)
        label.numberOfLines = 1
        label.isSkeletonable = true

        return label
    }()

    lazy var amountLabel: UILabel = {
        let label = UILabel()

        self.transactionInfoContainerView.addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false

        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .black
        label.textAlignment = .right
        label.isSkeletonable = true

        return label
    }()

    lazy var dateLabel: UILabel = {
        let label = UILabel()

        self.transactionInfoContainerView.addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false

        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor.black.withAlphaComponent(0.6)
        label.textAlignment = .right
        label.numberOfLines = 1
        label.isSkeletonable = true

        return label
    }()

    private lazy var chevronView: UIImageView = {
        let view = UIImageView()

        view.translatesAutoresizingMaskIntoConstraints = false

        view.isSkeletonable = true
        view.setImage(withName: "ic_chevron_right")
        view.contentMode = .scaleAspectFit

        view.heightAnchor.constraint(equalToConstant: 10.0).isActive = true
        view.widthAnchor.constraint(equalToConstant: 10.0).isActive = true

        return view
    }()

    private lazy var divider: UIView = {
        let view = UIView()

        self.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false

        view.backgroundColor = UIColor(red: 0.812, green: 0.812, blue: 0.812, alpha: 1)
        view.isHidden = !self.showsDivider
        view.isSkeletonable = true

        view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true

        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }

    required init?(coder aCoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        self.primaryStackView.addArrangedSubview(self.categoryImage)
        
        if self.categoryIcon == nil {
            self.categoryImage.removeFromSuperview()
        } else {
            self.primaryStackView.addArrangedSubview(self.categoryImage)
        }

        self.primaryStackView.addArrangedSubview(self.transactionInfoContainerView)

        if self.isChevronIconVisible {
            self.primaryStackView.addArrangedSubview(self.chevronView)
        } else {
            self.chevronView.removeFromSuperview()
        }

        self.setupConstraints()
    }

    private func setupConstraints() {

        self.translatesAutoresizingMaskIntoConstraints = false

        self.amountLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        self.descriptionLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        self.merchantLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        self.dateLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        NSLayoutConstraint.activate([
            self.primaryStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12.0),
            self.primaryStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16.0),
            self.primaryStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12.0),
            self.primaryStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16.0)
        ])

        switch self.leftIconStyle {
        case .roundedRect(cornerRadius: let cornerRadius):
            self.categoryImage.layer.cornerRadius = cornerRadius
        case .circle:
            self.categoryImage.layer.cornerRadius = 20.0
        }

        NSLayoutConstraint.activate([
            self.transactionInfoContainerView.topAnchor.constraint(equalTo: self.primaryStackView.topAnchor),
            self.transactionInfoContainerView.bottomAnchor.constraint(equalTo: self.primaryStackView.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            self.merchantLabel.topAnchor.constraint(equalTo: self.transactionInfoContainerView.topAnchor),
            self.merchantLabel.leftAnchor.constraint(equalTo: self.transactionInfoContainerView.leftAnchor),
            self.merchantLabel.rightAnchor.constraint(equalTo: self.amountLabel.leftAnchor, constant: -8.0)
        ])

        NSLayoutConstraint.activate([
            self.descriptionLabel.topAnchor.constraint(equalTo: self.merchantLabel.bottomAnchor, constant: 4.0),
            self.descriptionLabel.leftAnchor.constraint(equalTo: self.transactionInfoContainerView.leftAnchor),
            self.descriptionLabel.bottomAnchor.constraint(equalTo: self.transactionInfoContainerView.bottomAnchor),
            self.descriptionLabel.rightAnchor.constraint(equalTo: self.dateLabel.leftAnchor, constant: -8.0)
        ])

        NSLayoutConstraint.activate([
            self.amountLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 100.0),
            self.amountLabel.topAnchor.constraint(equalTo: self.transactionInfoContainerView.topAnchor),
            self.amountLabel.rightAnchor.constraint(equalTo: self.transactionInfoContainerView.rightAnchor),
            self.amountLabel.leftAnchor.constraint(equalTo: self.merchantLabel.rightAnchor, constant: 8.0)
        ])

        NSLayoutConstraint.activate([
            self.dateLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 100.0),
            self.dateLabel.topAnchor.constraint(equalTo: self.amountLabel.bottomAnchor, constant: 4.0),
            self.dateLabel.leftAnchor.constraint(equalTo: self.descriptionLabel.rightAnchor, constant: 8.0),
            self.dateLabel.rightAnchor.constraint(equalTo: self.transactionInfoContainerView.rightAnchor),
            self.dateLabel.bottomAnchor.constraint(equalTo: self.transactionInfoContainerView.bottomAnchor),
        ])

        self.setupDividerConstraints(by: self.dividerStyle)
    }

    private func setupDividerConstraints(by dividerStyle: DividerStyle) {
        NSLayoutConstraint.deactivate(self.activeConstraints)

        switch dividerStyle {
        case .partial:
            self.activeConstraints = [
                self.divider.leftAnchor.constraint(equalTo: self.merchantLabel.leftAnchor),
                self.divider.rightAnchor.constraint(equalTo: self.rightAnchor),
                self.divider.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ]
        case .full:
            self.activeConstraints = [
                self.divider.leftAnchor.constraint(equalTo: self.leftAnchor),
                self.divider.rightAnchor.constraint(equalTo: self.rightAnchor),
                self.divider.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ]
        }

        NSLayoutConstraint.activate(self.activeConstraints)
        self.layoutIfNeeded()
    }

    public func setData(transaction: TransactionRepresentable, categoryName: String?) {
        self.merchantLabel.text = transaction.merchantName
        self.descriptionLabel.text = categoryName ?? transaction.descriptionText
        self.amountLabel.text = transaction.amountText
        self.amountLabel.textColor = transaction.amountTextColor
        self.dateLabel.text = transaction.dateText
    }

    public func showSkeletonAnimation() {

        self.merchantLabel.text = " "
        self.descriptionLabel.text = " "
        self.amountLabel.text = " "
        self.dateLabel.text = " "

        DispatchQueue.main.async {
            self.categoryImage.showAnimatedGradientSkeleton()
            self.merchantLabel.showAnimatedGradientSkeleton()
            self.descriptionLabel.showAnimatedGradientSkeleton()
            self.amountLabel.showAnimatedGradientSkeleton()
            self.dateLabel.showAnimatedGradientSkeleton()
            self.chevronView.showAnimatedGradientSkeleton()
        }
    }

    public func hideSkeletonAnimation() {
        DispatchQueue.main.async {
            self.categoryImage.hideSkeleton()
            self.merchantLabel.hideSkeleton()
            self.descriptionLabel.hideSkeleton()
            self.amountLabel.hideSkeleton()
            self.dateLabel.hideSkeleton()
            self.chevronView.hideSkeleton()
        }
    }
}

