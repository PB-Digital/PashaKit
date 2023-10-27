//
//  PBSelectableRowView.swift
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

/// `PBSelectableRowView` is a subclass of `PBBaseSelectableVie` made for
/// representing selectable row views. Visually it's similar to `PBRowView` but it also contains
/// checkbox for selection states
///
/// **View Structure**
///
/// `PBSelectableRowView` packs up its contents in its `contentStackView`. View hierarchy of it is as following:
/// - `primaryStackView`-  is superview of `leftIconView` which holds left icon of
/// row view
///     - `secondaryStackView`- holds `titleLabel` and `subtitleLabel`
///     - `secondaryIconWrapperView`- holds custom icon
/// - `checkboxWrapperView`- have two subviews:
///     - `checkboxDefault`- holds default checkbox icon
///     - `checkboxSelected`- holds selected checkbox icon
///
/// While laying out subviews, checkbox default and checkbox selected been put in the same places. But depending
/// on `isSelected` state, these image's alpha changes respectively and creates "selection" effect.
///
/// It comes with hightly customizable settings such as
/// - options to add subtite
/// - options to add secondary icon. This can be any icon you want. It will just sit near `secondaryStackView`
/// - changing built-in checkbox icons for both states.
///
public class PBSelectableRowView: PBBaseSelectableView {

    ///  Horizontal position of checkbox
    ///
    ///  It comes with 2 cases:
    ///  - `left`
    ///  - `right`
    ///
    ///  To place checkbox on the either of the sides you can use this enum
    ///  and property with named `checkboxHorizontalPosition`
    ///
    public enum CheckboxHorizontalPosition {
        case left
        case right
    }

    /// Sets the icon for row view.
    ///
    /// By default the image of secondary view is set to `nil`. While creating row view if this property wasnt specified,  it won't be added
    /// to content stack view. Add image to this property if you want to show image beside checkbox.
    ///
    public var secondaryIcon: UIImage? {
        didSet {
            if self.secondaryIcon != oldValue {
                self.secondaryIconView.image = self.secondaryIcon
                self.setupViews()
            }
        }
    }

    ///  The arranger for title and subtile labels.
    ///
    ///  When row view is created, `subtitleLabel` sits under `titleLabel`.
    ///  However there are some cases we needed to change their places.
    ///
    ///  Obviously, changing this property's value to `subtitleFirst`  will make `titleLabel`
    ///  to sit under `subtitleLabel`.
    ///
    public var textLayoutPreference: PreferredTextPlacement = .titleFirst {
        didSet {
            if self.textLayoutPreference != oldValue {
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
    }

    ///
    /// Changes textbox position from side to side
    ///
    /// In case you want to change position of checkbox from left tor right  or vice-versa, updating
    /// this property will do the things for you.
    ///
    /// By default checkbox is located on the left side when row view is created.
    ///
    public var checkboxHorizontalPosition: CheckboxHorizontalPosition = .left {
        didSet {
            if self.checkboxHorizontalPosition != oldValue {
                switch self.checkboxHorizontalPosition {
                case .left:
                    self.locateCheckboxToLeft()
                case .right:
                    self.locateCheckboxToRight()
                }
            }
        }
    }

    /// Sets the image for default checkbox state
    ///
    /// By default it will add our asset to it. If you are not comfortable with this icon,
    /// replace it.
    ///
    public var defaultCheckboxIcon: UIImage? = UIImage.Images.icCheckboxDefault {
        didSet {
            if self.defaultCheckboxIcon != oldValue {
                self.checkBoxDefault.image = self.defaultCheckboxIcon?.withRenderingMode(.alwaysTemplate)
            }
        }
    }

    /// Sets the image for selected checkbox state
    ///
    /// By default it will add our asset to it. If you are not comfortable with this icon,
    /// replace it.
    ///
    public var selectedCheckboxIcon: UIImage? = UIImage.Images.icCheckboxSelected {
        didSet {
            if self.selectedCheckboxIcon != oldValue {
                self.checkBoxSelected.image = self.selectedCheckboxIcon
            }
        }
    }

    /// Title text of checkbox
    ///
    /// If not specified checkbox will be created with empty title.
    ///
    public var titleText: String? {
        didSet {
            if self.titleText != oldValue {
                self.titleLabel.text = self.titleText
                self.setupViews()
            }
        }
    }

    /// Attributed text of title
    ///
    /// You can use this property for assigning custom attributed strings to title.
    ///
    public var titleAttributedText: NSAttributedString? {
        didSet {
            if self.titleAttributedText != oldValue {
                self.titleLabel.attributedText = self.titleAttributedText
                self.setupViews()
            }
        }
    }

    /// Font for the title of row view.
    ///
    /// By default `systemFont` of size `17.0` with `semibold` weight will be used.
    ///
    public var titleFont: UIFont  = UIFont.systemFont(ofSize: 17.0, weight: .semibold) {
        didSet {
            if self.titleFont != oldValue {
                self.titleLabel.font = self.titleFont
            }
        }
    }

    /// Sets the color for `titleLabel`
    ///
    /// If not specified `darkText` will be used.
    ///
    public var titleTextColor: UIColor = .darkText {
        didSet {
            if self.titleTextColor != oldValue {
                self.titleLabel.textColor = self.titleTextColor
            }
        }
    }

    /// Title text of checkbox
    ///
    /// If not specified checkbox will be created with empty title.
    ///
    public var subtitleText: String? {
        didSet {
            if self.subtitleText != oldValue {
                self.subtitleLabel.text = self.subtitleText
                self.setupViews()
            }
        }
    }

    /// Atributed text of subtitle
    ///
    /// You can use this property for assigning custom attributed strings to subtitle,
    /// such as partial font change.
    ///
    public var subtitleAttributedText: NSAttributedString? {
        didSet {
            if self.subtitleAttributedText != oldValue {
                self.subtitleLabel.attributedText = self.subtitleAttributedText
                self.setupViews()
            }
        }
    }

    /// Font for the title of row view.
    ///
    /// By default `systemFont` of size `13.0` with `semibold` weight will be used.
    ///
    public var subtitleFont: UIFont = UIFont.systemFont(ofSize: 13.0, weight: .regular) {
        didSet {
            if self.subtitleFont != oldValue {
                self.subtitleLabel.font = self.subtitleFont
            }
        }
    }

    /// Sets the color for `subtitleLabel`
    ///
    /// If not specified it will be set `black` color with the alpha of `0.6`
    ///
    public var subtitleTextColor: UIColor = UIColor.black.withAlphaComponent(0.6) {
        didSet {
            if self.subtitleTextColor != oldValue {
                self.subtitleLabel.textColor = self.subtitleTextColor
            }
        }
    }

    public var checkboxTintColor: UIColor = UIColor(resource: .grey800) {
        didSet {
            if self.checkboxTintColor != oldValue {
                self.checkBoxDefault.tintColor = self.checkboxTintColor
            }
        }
    }

    public var contentEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0) {
        didSet {
            if self.contentEdgeInsets != oldValue {
                self.setNeedsUpdateConstraints()
            }
        }
    }

    public var textualContentPadding: CGFloat = 2.0 {
        didSet {
            if self.textualContentPadding != oldValue {
                self.setNeedsUpdateConstraints()
            }
        }
    }

    private let iconsSize: CGSize = CGSize(width: 24.0, height: 24.0)
    private let checkboxSize: CGSize = CGSize(width: 24.0, height: 24.0)

    private lazy var contentStackView: UIStackView = {
        let view = UIStackView()

        self.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false

        view.alignment = .center
        view.axis = .horizontal
        view.spacing = 16.0

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

        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()

        label.font = self.titleFont
        label.textColor = self.titleTextColor
        label.numberOfLines = 0

        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false

        label.font = self.subtitleFont
        label.textColor = self.subtitleTextColor
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

        view.translatesAutoresizingMaskIntoConstraints = false

        view.image = self.defaultCheckboxIcon?.withRenderingMode(.alwaysTemplate)
        view.contentMode = .scaleAspectFit

        view.fillSuperview()
        view.heightAnchor.constraint(equalToConstant: checkboxSize.height).isActive = true
        view.widthAnchor.constraint(equalToConstant: checkboxSize.width).isActive = true

        return view
    }()

    private lazy var checkBoxSelected: UIImageView = {
        let view = UIImageView()

        self.checkboxWrapperView.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false

        view.image = self.selectedCheckboxIcon
        view.contentMode = .scaleAspectFit

        view.fillSuperview()
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

    public convenience init(selectionStyle: SelectionStyle) {
        self.init()
        self.selectionStyle = selectionStyle
    }

    /// Sets data for a row view.
    ///
    /// - Parameters:
    ///    - titleText: Sets the title text for row view.
    ///    - subtitleText: Sets subtitle text for row view.
    ///    - secondaryIcon: An option for setting secondary icon
    ///
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

        self.setNeedsUpdateConstraints()
    }

    public override func updateConstraints() {
        NSLayoutConstraint.activate([
            self.contentStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: self.contentEdgeInsets.top),
            self.contentStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: self.contentEdgeInsets.left),
            self.contentStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -self.contentEdgeInsets.bottom),
            self.contentStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -self.contentEdgeInsets.right)
        ])

        NSLayoutConstraint.activate([
            self.secondaryIconView.topAnchor.constraint(equalTo: self.secondaryIconWrapperView.topAnchor),
            self.secondaryIconView.leftAnchor.constraint(equalTo: self.secondaryIconWrapperView.leftAnchor),
            self.secondaryIconView.bottomAnchor.constraint(equalTo: self.secondaryIconWrapperView.bottomAnchor),
            self.secondaryIconView.rightAnchor.constraint(equalTo: self.secondaryIconWrapperView.rightAnchor)
        ])

        super.updateConstraints()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        if self.secondaryStackView.subviews.count == 1 {
            self.secondaryStackView.spacing = 0.0
        } else {
            self.secondaryStackView.spacing = self.textualContentPadding
        }
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

            if self.subtitleText != nil || self.subtitleAttributedText != nil {
                self.secondaryStackView.addArrangedSubview(self.subtitleLabel)
            }
        case .subtitleFirst:
            if self.subtitleText != nil || self.subtitleAttributedText != nil {
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
        self.setupDefaults()
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
            self.checkBoxSelected.image = UIImage.Images.icCheckboxSelected
        case .dark:
            self.checkBoxSelected.image = UIImage.Images.icCheckboxSelectedPrivate
        }
    }

    public override func setAlertState() {
        super.setAlertState()

        self.titleLabel.textColor = Colors.PBInvalidRed
        self.subtitleLabel.textColor = Colors.PBInvalidRed
        self.checkBoxDefault.tintColor = Colors.PBInvalidRed
    }

    private func setupDefaults() {
        self.titleLabel.textColor = self.titleTextColor
        self.subtitleLabel.textColor = self.subtitleTextColor
        self.checkBoxDefault.tintColor = self.checkboxTintColor
    }
}
