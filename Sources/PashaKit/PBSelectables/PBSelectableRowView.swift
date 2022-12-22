//
//  PBSelectableRowView.swift
//  
//
//  Created by Murad on 11.12.22.
//

import UIKit

protocol PBSelectableRowViewRepresentable {
    var data: SelectableRowViewData { get }
}

public struct SelectableRowViewData {
    var titleText: String
    var subtitleText: String?

    public init(titleText: String, subtitleText: String? = nil) {
        self.titleText = titleText
        self.subtitleText = subtitleText
    }
}

public class PBSelectableRowView: PBBaseSelectableView {

    public enum CheckboxVerticalPosition {
        case top
        case middle
        case bottom
    }

    public enum CheckboxHorizontalPosition {
        case left
        case right
    }

    public var secondaryIcon: UIImage? {
        didSet {
            if self.secondaryIcon != oldValue {
                self.secondaryIconView.image = self.secondaryIcon
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

    public var checkboxHorizontalPosition: CheckboxHorizontalPosition = .left {
        didSet {
            switch self.checkboxHorizontalPosition {
            case .left:
                self.locateCheckboxToLeft()
            case .right:
                self.locateCheckboxToRight()
            }
        }
    }

    public var selectedCheckboxIcon: UIImage? = UIImage(named: "ic_checkbox_selected", in: Bundle.module, compatibleWith: nil){
        didSet {
            self.checkBoxSelected.image = self.selectedCheckboxIcon
        }
    }

    public var defaultCheckboxIcon: UIImage? = UIImage(named: "ic_checkbox_default", in: Bundle.module, compatibleWith: nil) {
        didSet {
            self.checkBoxDefault.image = self.defaultCheckboxIcon
        }
    }

    public var titleText: String? {
        didSet {
            if self.titleText != oldValue {
                self.titleLabel.text = self.titleText
                self.setupViews()
            }
        }
    }

    public var titleFont: UIFont?  = UIFont.systemFont(ofSize: 17.0, weight: .semibold) {
        didSet {
            self.titleLabel.font = self.titleFont
        }
    }

    public var titleTextColor: UIColor = .darkText {
        didSet {
            self.titleLabel.textColor = self.titleTextColor
        }
    }

    public var subtitleText: String? {
        didSet {
            if self.subtitleText != oldValue {
                self.subtitleLabel.text = self.subtitleText
                self.setupViews()
            }
        }
    }

    public var subtitleFont: UIFont? = UIFont.systemFont(ofSize: 13.0, weight: .regular) {
        didSet {
            self.subtitleLabel.font = self.subtitleFont
        }
    }

    private let iconsSize: CGSize = CGSize(width: 24.0, height: 24.0)
    private let checkboxSize: CGSize = CGSize(width: 20.0, height: 20.0)

    private lazy var contentStackView: UIStackView = {
        let view = UIStackView()

        self.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false

        view.alignment = .center
        view.axis = .horizontal
        view.spacing = 12.0

        return view
    }()

    private lazy var primaryStackView: UIStackView = {
        let view = UIStackView()

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
        view.spacing = 2.0

        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()

        self.addSubview(label)

        label.font = self.titleFont
        label.textColor = self.titleTextColor

        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false

        label.font = self.subtitleFont
        label.textColor = UIColor.black.withAlphaComponent(0.6)
        label.numberOfLines = 0

        return label
    }()

    private lazy var secondaryIconWrapperView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false

        view.heightAnchor.constraint(equalToConstant: iconsSize.height).isActive = true
        view.widthAnchor.constraint(equalToConstant: iconsSize.width).isActive = true

        return view
    }()

    lazy var secondaryIconView: UIImageView = {
        let view = UIImageView()

        self.secondaryIconWrapperView.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit

        view.heightAnchor.constraint(equalToConstant: iconsSize.height).isActive = true
        view.widthAnchor.constraint(equalToConstant: iconsSize.width).isActive = true

        return view
    }()

    private lazy var checkboxWrapperView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false

        view.heightAnchor.constraint(equalToConstant: checkboxSize.height).isActive = true
        view.widthAnchor.constraint(equalToConstant: checkboxSize.width).isActive = true

        return view
    }()

    private lazy var checkBoxDefault: UIImageView = {
        let view = UIImageView()

        self.checkboxWrapperView.addSubview(view)

        view.image = self.defaultCheckboxIcon
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false

        view.heightAnchor.constraint(equalToConstant: checkboxSize.height).isActive = true
        view.widthAnchor.constraint(equalToConstant: checkboxSize.width).isActive = true

        return view
    }()

    private lazy var checkBoxSelected: UIImageView = {
        let view = UIImageView()

        self.checkboxWrapperView.addSubview(view)

        view.image = self.selectedCheckboxIcon
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false

        view.heightAnchor.constraint(equalToConstant: checkboxSize.height).isActive = true
        view.widthAnchor.constraint(equalToConstant: checkboxSize.width).isActive = true

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

    public func setData(titleText: String, subtitleText: String? = nil, secondaryIcon: UIImage? = nil) {
        self.titleText = titleText
        self.subtitleText = subtitleText
        self.secondaryIcon = secondaryIcon
    }

    override func setupViews() {
        super.setupViews()

        self.translatesAutoresizingMaskIntoConstraints = false

        self.setupDefaults()

        self.updateUI()

        switch self.checkboxHorizontalPosition {
        case .left:
            self.locateCheckboxToLeft()
        case .right:
            self.locateCheckboxToRight()
        }

        self.setupConstraints()
    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([
            self.contentStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8.0),
            self.contentStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16.0),
            self.contentStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8.0),
            self.contentStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16.0)
        ])

        NSLayoutConstraint.activate([
            self.checkBoxDefault.topAnchor.constraint(equalTo: self.checkboxWrapperView.topAnchor),
            self.checkBoxDefault.leftAnchor.constraint(equalTo: self.checkboxWrapperView.leftAnchor),
            self.checkBoxDefault.bottomAnchor.constraint(equalTo: self.checkboxWrapperView.bottomAnchor),
            self.checkBoxDefault.rightAnchor.constraint(equalTo: self.checkboxWrapperView.rightAnchor),
            self.checkBoxSelected.topAnchor.constraint(equalTo: self.checkboxWrapperView.topAnchor),
            self.checkBoxSelected.leftAnchor.constraint(equalTo: self.checkboxWrapperView.leftAnchor),
            self.checkBoxSelected.bottomAnchor.constraint(equalTo: self.checkboxWrapperView.bottomAnchor),
            self.checkBoxSelected.rightAnchor.constraint(equalTo: self.checkboxWrapperView.rightAnchor)
        ])

        NSLayoutConstraint.activate([
            self.secondaryIconView.topAnchor.constraint(equalTo: self.secondaryIconWrapperView.topAnchor),
            self.secondaryIconView.leftAnchor.constraint(equalTo: self.secondaryIconWrapperView.leftAnchor),
            self.secondaryIconView.bottomAnchor.constraint(equalTo: self.secondaryIconWrapperView.bottomAnchor),
            self.secondaryIconView.rightAnchor.constraint(equalTo: self.secondaryIconWrapperView.rightAnchor)
        ])
    }

    public override func draw(_ rect: CGRect) {
        super.draw(rect)

        if self.frame.height > 64.0 {
            self.contentStackView.alignment = .top
        } else {
            self.contentStackView.alignment = .center
        }
    }

    private func locateCheckboxToLeft() {

        switch self.textLayoutPreference {
        case .titleFirst:
            self.secondaryStackView.addArrangedSubview(self.titleLabel)

            if self.titleText != nil {
                self.secondaryStackView.addArrangedSubview(self.subtitleLabel)
            }
        case .subtitleFirst:
            if self.titleText != nil {
                self.secondaryStackView.addArrangedSubview(self.subtitleLabel)
            }

            self.secondaryStackView.addArrangedSubview(self.titleLabel)
        }

        self.primaryStackView.addArrangedSubview(self.secondaryStackView)

        if self.secondaryIcon != nil {
            self.primaryStackView.addArrangedSubview(self.secondaryIconWrapperView)
        }

        self.contentStackView.addArrangedSubview(self.checkboxWrapperView)
        self.contentStackView.addArrangedSubview(self.primaryStackView)
    }

    private func locateCheckboxToRight() {
        switch self.textLayoutPreference {
        case .titleFirst:
            self.secondaryStackView.addArrangedSubview(self.titleLabel)

            if self.titleText != nil {
                self.secondaryStackView.addArrangedSubview(self.subtitleLabel)
            }
        case .subtitleFirst:
            if self.titleText != nil {
                self.secondaryStackView.addArrangedSubview(self.subtitleLabel)
            }

            self.secondaryStackView.addArrangedSubview(self.titleLabel)
        }

        if self.secondaryIcon != nil {
            self.primaryStackView.addArrangedSubview(self.secondaryIconWrapperView)
        }

        self.primaryStackView.addArrangedSubview(self.secondaryStackView)

        self.contentStackView.addArrangedSubview(self.primaryStackView)
        self.contentStackView.addArrangedSubview(self.checkboxWrapperView)
    }

    override func updateUI() {
        super.updateUI()

        if self.isSelected {
            self.checkBoxSelected.alpha = 1.0
            self.checkboxWrapperView.bringSubviewToFront(self.checkBoxSelected)
        } else {
            self.checkBoxSelected.alpha = 0.0
            self.checkboxWrapperView.bringSubviewToFront(self.checkBoxDefault)
        }
    }

    override func setTheme() {
        super.setTheme()

        switch self.theme {
        case .regular:
            self.checkBoxSelected.image = UIImage(named: "ic_checkbox_selected", in: Bundle.module, compatibleWith: nil)
        case .dark:
            self.checkBoxSelected.image = UIImage(named: "ic_checkbox_selected_private", in: Bundle.module, compatibleWith: nil)
        }
    }

    private func setupDefaults() {
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(greaterThanOrEqualToConstant: 64.0)
        ])
    }
}
