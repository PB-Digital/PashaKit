//
//  PBRowView.swift
//  
//
//  Created by Murad on 07.12.22.
//

import UIKit

open class PBRowView: UIView, PBSkeletonable {

    public enum IsNew {
        case `true`(localizableTitle: String)
        case `false`
    }

    public var rightIcon: UIImage? {
        didSet {
            if self.rightIcon != oldValue {
                self.rightIconView.image = self.rightIcon
                self.setupViews()
            }
        }
    }

    public var leftIcon: UIImage? {
        didSet {
            if self.leftIcon != oldValue {
                self.leftIconView.image = self.leftIcon
                self.setupViews()
            }
        }
    }

    public var titleText: String? {
        didSet {
            self.titleLabel.text = self.titleText
        }
    }

    public var titleFont: UIFont? {
        didSet {
            self.titleLabel.font = self.titleFont
        }
    }

    public var titleTextColor: UIColor = .darkText{
        didSet {
            self.titleLabel.textColor = self.titleTextColor
        }
    }

    public var subtitleText: String? {
        didSet {
            self.subtitleLabel.text = self.subtitleText
        }
    }

    public var subtitleFont: UIFont? {
        didSet {
            self.subtitleLabel.font = self.subtitleFont
        }
    }

    public var leftIconBackgroundColor: UIColor? {
        didSet {
            self.leftIconWrapperView.backgroundColor = self.leftIconBackgroundColor
        }
    }

    public var leftIconStyle: Style = .circle {
        didSet {
            self.setupViews()
        }
    }

    public var isNewFeature: IsNew = .false {
        didSet {
            self.setupNewView(state: self.isNewFeature)
        }
    }

    public var leftIconContentInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
            if self.leftIconContentInsets != oldValue {
                self.setupLeftIconConstraints()
            }
        }
    }

    public var leftViewSize: CGSize = CGSizeMake(40, 40) {
        didSet {
            if self.leftViewSize != oldValue {
                self.setupViews()
            }
        }
    }

    public var textLayoutPreference: PreferredTextPlacement = .titleFirst {
        didSet {
            self.secondaryStackView.removeArrangedSubview(self.titleLabel)
            self.secondaryStackView.removeArrangedSubview(self.subtitleLabel)

            switch self.textLayoutPreference {
            case .titleFirst:
                self.secondaryStackView.addArrangedSubview(self.titleLabel)
                self.secondaryStackView.addArrangedSubview(self.subtitleLabel)
            case .subtitleFirst:
                self.secondaryStackView.addArrangedSubview(self.subtitleLabel)
                self.secondaryStackView.addArrangedSubview(self.titleLabel)
            }
        }
    }

    public var titleTextWeight: UIFont.Weight = .semibold {
        didSet {
            switch self.titleTextWeight {
            case .regular:
                self.titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            case .medium:
                self.titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            case .semibold:
                self.titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            default:
                self.titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            }
        }
    }

    public var isChevronIconVisible: Bool = true {
        didSet {
            if self.isChevronIconVisible {
                self.primaryStackView.addArrangedSubview(self.rightIconWrapperView)
                self.rightIconWrapperView.isHidden = false
            } else {
                self.primaryStackView.removeArrangedSubview(self.rightIconWrapperView)
                self.rightIconWrapperView.isHidden = true
            }

            self.setupConstraints()
        }
    }

    public var showsDivider: Bool = false {
        didSet {
            self.divider.isHidden = !showsDivider
        }
    }

    private var activeLeftIconConstraints: [NSLayoutConstraint] = []
    private var activeLeftIconWrapperConstraints: [NSLayoutConstraint] = []

    private lazy var primaryStackView: UIStackView = {
        let view = UIStackView()

        self.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false

        view.alignment = .center
        view.axis = .horizontal
        view.spacing = 12.0

        return view
    }()

    private lazy var secondaryStackView: UIStackView = {
        let view = UIStackView()

        self.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false

        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 4.0

        return view
    }()

    private lazy var leftIconWrapperView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false

        view.backgroundColor = UIColor(red: 0.604, green: 0.608, blue: 0.612, alpha: 0.08)
        view.isSkeletonable = true

        return view
    }()

    private lazy var leftIconView: UIImageView = {
        let view = UIImageView()

        self.leftIconWrapperView.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false

        view.contentMode = .scaleAspectFit

        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false

        label.font = UIFont.systemFont(ofSize: 17, weight: self.titleTextWeight)
        label.textColor = self.titleTextColor
        label.numberOfLines = 1
        label.sizeToFit()
        label.isSkeletonable = true

        return label
    }()

    private lazy var isNewView: PBPaddingLabel = {
        let label = PBPaddingLabel(topInset: 4, leftInset: 8, bottomInset: 4, rightInset: 8)

        label.translatesAutoresizingMaskIntoConstraints = false

        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.backgroundColor = UIColor.Colors.PBRed8
        label.textColor = UIColor.Colors.PBRed
        label.textAlignment = .center
        label.layer.cornerRadius = 6.0
        label.clipsToBounds = true
        label.sizeToFit()

        label.heightAnchor.constraint(equalToConstant: 24.0).isActive = true

        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false

        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        label.numberOfLines = 1
        label.isSkeletonable = true

        return label
    }()

    private lazy var rightIconWrapperView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false

        view.isSkeletonable = true

        view.heightAnchor.constraint(equalToConstant: 18.0).isActive = true
        view.widthAnchor.constraint(equalToConstant: 18.0).isActive = true

        return view
    }()

    lazy var rightIconView: UIImageView = {
        let view = UIImageView()

        self.rightIconWrapperView.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false

        view.setImage(withName: "ic_chevron_right")
        view.contentMode = .scaleAspectFit

        return view
    }()

    lazy var divider: UIView = {
        let view = UIView()

        self.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false

        view.backgroundColor = UIColor(red: 0.812, green: 0.812, blue: 0.812, alpha: 1)
        view.isHidden = !self.showsDivider
        view.isSkeletonable = true

        view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true

        return view
    }()

    required public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }

    required public init?(coder aCoder: NSCoder) {
        super.init(coder: aCoder)
        self.setupViews()
    }

    public convenience init(titleText: String, subtitleText: String? = nil, isChevronIconVisible: Bool = false) {
        self.init(frame: .zero)

        self.titleLabel.text = titleText
        self.subtitleLabel.text = subtitleText
        self.isChevronIconVisible = isChevronIconVisible

        self.setupViews()
    }

    public func setDataFor(rowView: PBRowViewRepresentable, isNew: IsNew = .false) {
        self.titleText = rowView.data.titleText
        self.subtitleText = rowView.data.subtitleText
        self.rightIconWrapperView.isHidden = !rowView.data.isRightIconVisible
        self.setupNewView(state: isNew)

        self.setupViews()
    }

    public func setData(titleText: String? = nil, subtitleText: String? = nil, isChevronIconVisible: Bool = false) {
        self.titleText = titleText
        self.subtitleText = subtitleText
        self.isChevronIconVisible = isChevronIconVisible

        self.setupViews()
    }

    public func showSkeletonAnimation() {
        DispatchQueue.main.async {
            self.leftIconWrapperView.showAnimatedGradientSkeleton()
            self.titleLabel.showAnimatedGradientSkeleton()
            self.subtitleLabel.showAnimatedGradientSkeleton()
            self.rightIconWrapperView.showAnimatedGradientSkeleton()
        }
    }

    public func hideSkeletonAnimation() {
        self.leftIconWrapperView.hideSkeleton()
        self.titleLabel.hideSkeleton()
        self.subtitleLabel.hideSkeleton()
        self.rightIconWrapperView.hideSkeleton()
    }

    private func setupViews() {
        if self.leftIconView.image == nil {
            self.leftIconWrapperView.removeFromSuperview()
        } else {
            self.primaryStackView.addArrangedSubview(self.leftIconWrapperView)
        }

        switch self.leftIconStyle {
        case .roundedRect(cornerRadius: let cornerRadius):
            self.leftIconWrapperView.layer.cornerRadius = cornerRadius
        case .circle:
            self.leftIconWrapperView.layer.cornerRadius = self.leftViewSize.width / 2
        }

        self.primaryStackView.addArrangedSubview(self.secondaryStackView)
        self.setupTitleAndSubtitlePlacement()

        self.primaryStackView.addArrangedSubview(self.rightIconWrapperView)


        if self.isChevronIconVisible {
            self.primaryStackView.addArrangedSubview(self.rightIconWrapperView)
        } else {
            self.rightIconWrapperView.removeFromSuperview()
        }

        self.setupConstraints()
    }

    private func setupTitleAndSubtitlePlacement() {
        switch self.textLayoutPreference {
        case .titleFirst:
            self.secondaryStackView.addArrangedSubview(self.titleLabel)

            if self.subtitleLabel.text == nil {
                self.subtitleLabel.removeFromSuperview()
            } else {
                self.secondaryStackView.addArrangedSubview(self.subtitleLabel)
            }
        case .subtitleFirst:
            if self.subtitleLabel.text == nil {
                self.subtitleLabel.removeFromSuperview()
            } else {
                self.secondaryStackView.addArrangedSubview(self.subtitleLabel)
            }

            self.secondaryStackView.addArrangedSubview(self.titleLabel)
        }
    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([
            self.primaryStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8.0),
            self.primaryStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16.0),
            self.primaryStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8.0),
            self.primaryStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16.0)
        ])

        self.setupLeftIconWrapperConstraints(for: self.leftViewSize)
        self.setupLeftIconConstraints()
        self.setupIsNewConstraints()

        NSLayoutConstraint.activate([
            self.subtitleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 100.0)
        ])

        NSLayoutConstraint.activate([
            self.rightIconView.topAnchor.constraint(equalTo: self.rightIconWrapperView.topAnchor, constant: 3.0),
            self.rightIconView.leftAnchor.constraint(equalTo: self.rightIconWrapperView.leftAnchor, constant: 6.0),
            self.rightIconView.bottomAnchor.constraint(equalTo: self.rightIconWrapperView.bottomAnchor, constant: -3.0),
            self.rightIconView.rightAnchor.constraint(equalTo: self.rightIconWrapperView.rightAnchor)
        ])

        NSLayoutConstraint.activate([
            self.divider.leftAnchor.constraint(equalTo: self.titleLabel.leftAnchor),
            self.divider.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.divider.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    private func setupLeftIconConstraints() {
        NSLayoutConstraint.deactivate(self.activeLeftIconConstraints)

        self.activeLeftIconConstraints = [
            self.leftIconView.topAnchor.constraint(equalTo: self.leftIconWrapperView.topAnchor, constant: self.leftIconContentInsets.top),
            self.leftIconView.leftAnchor.constraint(equalTo: self.leftIconWrapperView.leftAnchor, constant: self.leftIconContentInsets.left),
            self.leftIconView.bottomAnchor.constraint(equalTo: self.leftIconWrapperView.bottomAnchor, constant: -self.leftIconContentInsets.bottom),
            self.leftIconView.rightAnchor.constraint(equalTo: self.leftIconWrapperView.rightAnchor, constant: -self.leftIconContentInsets.right)
        ]

        NSLayoutConstraint.activate(self.activeLeftIconConstraints)
    }

    private func setupIsNewConstraints() {
        if self.subviews.contains(self.isNewView) {
            NSLayoutConstraint.activate([
                self.isNewView.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor),
                self.isNewView.leftAnchor.constraint(equalTo: self.titleLabel.rightAnchor, constant: 16.0),
//                self.isNewView.rightAnchor.constraint(lessThanOrEqualTo: self.rightIconWrapperView.leftAnchor, constant: -16.0)
            ])
        }
    }

    private func setupLeftIconWrapperConstraints(for size: CGSize) {
        NSLayoutConstraint.deactivate(self.activeLeftIconWrapperConstraints)

        self.activeLeftIconWrapperConstraints =  [
            self.leftIconWrapperView.widthAnchor.constraint(equalToConstant: size.width),
            self.leftIconWrapperView.heightAnchor.constraint(equalToConstant: size.height)
        ]

        NSLayoutConstraint.activate(self.activeLeftIconWrapperConstraints)
    }

    private func setupDefaults() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupNewView(state: IsNew) {
        switch state {
        case .true(let localizableTitle):
            self.isNewView.text = localizableTitle
            self.addSubview(self.isNewView)
            self.setupIsNewConstraints()
        case .false:
            self.isNewView.removeFromSuperview()
        }
    }
}

