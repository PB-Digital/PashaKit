//
//  PBRowView.swift
//  
//
//  Created by Murad on 07.12.22.
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

///
/// `PBRowView` is `UIView` subclass made for displaying row representable data.
///
/// **View Structure**
///
/// `PBRowView` packs up its contents in its `primaryStackView`. Primary stack view consists of
/// - `leftIconWrapperView`. This view is superview of `leftIconView` which holds left icon of
/// row view
/// - `secondaryStackView`. This stack view holds title and subtitle labels.
/// - `rightIconWrapperView`. This view is superview of `rightIconView` which holds right icon of
/// row view. Using this view as indicator for navigation is recommended.
/// - `divider`. This view is outside of `primaryStackView` and snapped to the bottom of view.
///
/// It comes with hightly customizable settings such as
/// - options to have right and left icon
/// - adding subtitle
/// - changing title and subtitle color
/// - setting text layout preference
/// - defining left icon style
/// - changing left icon size and content insets
/// - showing and hiding divider
/// 
open class PBRowView: UIView, PBSkeletonable {

    /// Checker for whether the row view is new.
    ///
    /// This enum was made our mobile design system in mind. Since in our mobile app
    /// there are some feature which are introduced newly and displayed as row view
    /// we have added an option for setting it.
    ///
    public enum IsNew: Equatable {
        case `true`(localizableTitle: String)
        case `false`

        public static func == (lhs: IsNew, rhs: IsNew) -> Bool {
            switch(lhs, rhs) {
            case (.true, .true):
                return true
            case (.false, .false):
                return true
            default:
                return false
            }
        }
    }

    /// Sets the icon to the left side of view.
    ///
    /// By default the image of left view is set to `nil`. While creating row view if this property wasnt specified, it won't be added
    /// to content stack view. Add image to this property if needed.
    ///
    public var leftIcon: UIImage? {
        didSet {
            self.leftIconView.image = nil
            self.leftIconView.image = self.leftIcon
        }
    }

    /// Returns the `UIImageView` of icon on the lefthandside.
    ///
    /// With the access to the holder view, you can customize its layer, image setting
    /// behaviors such as setting an image with the url using `Kingfisher`'s
    /// methods.
    ///
    public var leftView: UIImageView {
        return self.leftIconView
    }

    /// Sets the icon to the right side of view.
    ///
    /// By default the `image` of left view is set to be chevron icon. While creating row view if this property wasnt changed,
    /// rowview may display chevron icon dependending on value of `isChevronIconVisible`.
    ///
    /// Add image to this property if you need different kind of icon for indicating navigation to other pages.
    ///
    public var rightIcon: UIImage? {
        didSet {
            self.rightIconView.image = nil
            self.rightIconView.image = self.leftIcon
            self.setupViews()
        }
    }

    /// Sets the given string to `titleLabel` of row view.
    ///
    /// By default this property is set to `nil`. Depending on how you want to fill your row view it can be set directly
    /// via this property. Alternatively you can do it by adding when initializing it or using `setData` `setDataFor`
    /// methods.
    ///
    public var titleText: String? {
        didSet {
            self.titleLabel.text = self.titleText
        }
    }

    /// Sets the font for `titleLabel`.
    ///
    /// By default its font size is `17.0`.
    ///
    public var titleFont: UIFont? {
        didSet {
            self.titleLabel.font = self.titleFont
        }
    }

    /// Sets the color for text of `titleLabel`.
    ///
    /// By default text color of `titleLabel` is `darkText`
    ///
    public var titleTextColor: UIColor = .darkText{
        didSet {
            self.titleLabel.textColor = self.titleTextColor
        }
    }

    /// Toggles the multiline support for title and subtitle labels.
    ///
    /// By default `PBRowView` does not support 
    /// multiline content
    ///
    public var supportsMultilineContent: Bool = false {
        didSet {
            self.updateMultilineSupport(to: self.supportsMultilineContent)
        }
    }

    /// Sets the given string to `subtitleLabel` of row view.
    ///
    /// By default this property is set to `nil`. Depending on how you want to fill your row view it can be set directly
    /// via this property. Alternatively you can do it by adding when initializing it or using `setData` `setDataFor`
    /// methods.
    ///
    public var subtitleText: String? {
        didSet {
            self.subtitleLabel.text = self.subtitleText
            self.setupTitleAndSubtitlePlacement()
        }
    }

    /// Sets the color for the text of `subtitleLabel`.
    ///
    /// By default text color of `subtitleLabel` is `.black` with alpha of `0.6`
    ///
    public var subtitleTextColor: UIColor = .black.withAlphaComponent(0.6) {
        didSet {
            self.subtitleLabel.textColor = self.subtitleTextColor
        }
    }

    /// Sets the font for `subtitleLabel`.
    ///
    /// By default its font size is `15.0`.
    ///
    public var subtitleFont: UIFont? {
        didSet {
            self.subtitleLabel.font = self.subtitleFont
        }
    }

    /// The background color for `leftIconWrapperView`.
    ///
    /// By default the background color of `leftIconWrapperView` is `PBGrayTransparent`.
    ///
    public var leftIconBackgroundColor: UIColor? {
        didSet {
            self.leftIconWrapperView.backgroundColor = self.leftIconBackgroundColor
        }
    }

    /// The style for `leftIconWrapperView`.
    ///
    /// By default its value is `circle`.
    ///
    public var leftIconStyle: Style = .circle {
        didSet {
            if self.leftIconStyle != oldValue {
                self.setupLeftIconCornerRadius(style: self.leftIconStyle)
            }
        }
    }

    /// The indicator for rowView whether it's new.
    ///
    /// If not specified the value of this property is set to `false`. If its value changed to `true`
    /// `isNewView` will be added to the right side of `titleLabel`.
    ///
    public var isNewFeature: IsNew = .false {
        didSet {
            if self.isNewFeature != oldValue {
                self.setupNewView(state: self.isNewFeature)
            }
        }
    }

    /// The parameter for setting edge insets for `leftIconView`.
    ///
    /// By default edgeInsets will be `0` from all sides. Changing this property
    /// will affect `leftIconView` by proper insets for each side.
    ///
    public var leftIconContentInsets: UIEdgeInsets = UIEdgeInsets(all: 0.0) {
        didSet {
            if self.leftIconContentInsets != oldValue {
                self.setupLeftIconConstraints(for: self.leftIconContentInsets)
            }
        }
    }

    ///  The size for `leftIconWrapperView`.
    ///
    ///  By default the size for `leftIconWrapperView` is `40.0` both for width and height.
    ///
    public var leftViewSize: CGSize = CGSize(width: 40.0, height: 40.0) {
        didSet {
            if self.leftViewSize != oldValue {
                self.setupLeftIconWrapperConstraints(for: self.leftViewSize)
                self.setupLeftIconCornerRadius(style: self.leftIconStyle)
                self.setupDividerConstraints(by: self.leftPaddingForDivider)
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
            self.setupTitleAndSubtitlePlacement()
        }
    }

    ///  The indicator for title text weight.
    ///
    ///  By default text weight of `titleLabel` is `semibold`.
    ///
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

    /// A boolean value for deciding whether chevron icon should be visible.
    ///
    /// By default the value of this property is `true`. Since in our mobile app we have
    /// a lot row views with visible chevron icon, we kept this property value at `true`
    /// for ease of access.
    ///
    /// Changing its value to `false` removes it from row view.
    ///
    @available(*, deprecated, renamed: "isRightIconVisible")
    public var isChevronIconVisible: Bool = true {
        didSet {
            if self.isChevronIconVisible {
                self.rightIconWrapperView.isHidden = false
            } else {
                self.rightIconWrapperView.isHidden = true
            }
        }
    }
    
    /// A boolean value for deciding whether right icon should be visible.
    ///
    /// By default the value of this property is `true`. Since in our mobile app we have
    /// a lot row views with visible chevron icon, we kept this property value at `true`
    /// for ease of access.
    ///
    /// Changing its value to `false` removes it from row view.
    ///
    public var isRightIconVisible: Bool = true {
        didSet {
            if self.isRightIconVisible {
                self.rightIconWrapperView.isHidden = false
            } else {
                self.rightIconWrapperView.isHidden = true
            }
        }
    }

    /// The visual state of divider.
    ///
    /// By default row view will be created with divider is hidden.
    ///
    /// If you need a divider change it to `true`. It will show a divider with the thickness of `0.5 pt`.
    ///
    public var showsDivider: Bool = false {
        didSet {
            self.divider.isHidden = !showsDivider
        }
    }

    private var leftPaddingForDivider: CGFloat {
        return self.layoutMargins.left + self.leftViewSize.width + 12.0
    }

    private var activeLeftIconConstraints: [NSLayoutConstraint] = []
    private var activeLeftIconWrapperConstraints: [NSLayoutConstraint] = []
    private var activeDividerConstraints: [NSLayoutConstraint] = []

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
        view.image = nil
        view.contentMode = .scaleAspectFit

        return view
    }()

    private lazy var titleStack: UIStackView = {
        let view = UIStackView()

        view.translatesAutoresizingMaskIntoConstraints = false

        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 16.0

        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false

        label.font = UIFont.systemFont(ofSize: 17, weight: self.titleTextWeight)
        label.textColor = self.titleTextColor
        label.numberOfLines = 1
        label.isSkeletonable = true

        return label
    }()

    private lazy var isNewView: PBPaddingLabel = {
        let label = PBPaddingLabel(edgeInsets: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8))

        label.translatesAutoresizingMaskIntoConstraints = false

        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.backgroundColor = UIColor.Colors.PBRed8
        label.textColor = UIColor.Colors.PBRed
        label.textAlignment = .center

        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false

        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = self.subtitleTextColor
        label.numberOfLines = 1
        label.isSkeletonable = true

        return label
    }()

    private lazy var rightSideContentStack: UIStackView = {
        let view = UIStackView()

        self.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false

        view.alignment = .center
        view.axis = .horizontal
        view.spacing = 8.0

        return view
    }()

    private lazy var rightIconWrapperView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false

        view.isSkeletonable = true

        view.heightAnchor.constraint(equalToConstant: 18.0).isActive = true
        view.widthAnchor.constraint(equalToConstant: 18.0).isActive = true

        return view
    }()

    private lazy var rightIconView: UIImageView = {
        let view = UIImageView()

        self.rightIconWrapperView.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false

        view.image = UIImage.Images.icChevronRight
        view.contentMode = .scaleAspectFit

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

    required public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }

    required public init?(coder aCoder: NSCoder) {
        super.init(coder: aCoder)
        self.setupViews()
    }

    /// Creates a row view.
    ///
    /// - Parameters:
    ///    - titleText: Sets the title text for row view.
    ///    - subtitleText: Sets subtitle text for row view.
    ///    - isChevronIconVisible: Decides whether chevron icon should be visible or not.
    ///
    public convenience init(titleText: String, subtitleText: String? = nil, isChevronIconVisible: Bool = false) {
        self.init(frame: .zero)

        self.titleLabel.text = titleText
        self.subtitleLabel.text = subtitleText
        self.isRightIconVisible = isChevronIconVisible

        self.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        self.setupViews()
    }

    public init() {
        super.init(frame: .zero)

        self.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        self.setupViews()
    }

    /// Sets data for a row view.
    ///
    /// - Parameters:
    ///    - rowView: Protocol for representing `rowView`.
    ///    - isNew: Decides whether isNewView should be added.
    ///
    public func setDataFor(rowView: PBRowViewRepresentable, isNew: IsNew = .false) {
        self.titleText = rowView.data.titleText
        self.subtitleText = rowView.data.subtitleText
        self.rightIconWrapperView.isHidden = !rowView.data.isRightIconVisible
        self.setupNewView(state: isNew)

        self.setupViews()
    }

    /// Sets data for a row view.
    ///
    /// - Parameters:
    ///    - titleText: Sets the title text for row view.
    ///    - subtitleText: Sets subtitle text for row view.
    ///    - isChevronIconVisible: Decides whether chevron icon should be visible or not.
    ///
    public func setData(titleText: String? = nil, subtitleText: String? = nil, isChevronIconVisible: Bool = false) {
        self.titleText = titleText
        self.subtitleText = subtitleText
        self.isRightIconVisible = isChevronIconVisible

        self.setupViews()
    }

    /// Starts showing animated skeleton view
    ///
    /// If you call this method it will replace your row view components with their skeletoned versions
    /// with defined adjustments. It won't be removed until you call `hideSkeletonAnimation()`
    /// method.
    ///
    public func showSkeletonAnimation() {
        DispatchQueue.main.async {
            self.leftIconWrapperView.showAnimatedGradientSkeleton()
            self.titleLabel.showAnimatedGradientSkeleton()
            self.subtitleLabel.showAnimatedGradientSkeleton()
            self.rightIconWrapperView.showAnimatedGradientSkeleton()
        }
    }

    /// Stops showing animated skeleton view
    ///
    /// If you call this method it will remove currently applied skeleton view from row view and
    /// start showing setted row view data.
    /// 
    public func hideSkeletonAnimation() {
        self.leftIconWrapperView.hideSkeleton()
        self.titleLabel.hideSkeleton()
        self.subtitleLabel.hideSkeleton()
        self.rightIconWrapperView.hideSkeleton()
    }

    private func setupViews() {
        self.primaryStackView.addArrangedSubview(self.leftIconWrapperView)
        self.primaryStackView.addArrangedSubview(self.secondaryStackView)
        self.primaryStackView.addArrangedSubview(self.rightSideContentStack)

        self.titleStack.addArrangedSubview(self.titleLabel)
        self.rightSideContentStack.addArrangedSubview(self.rightIconWrapperView)

        self.setupLeftIconCornerRadius(style: self.leftIconStyle)
        self.setupTitleAndSubtitlePlacement()
        self.setupConstraints()
    }

    private func setupTitleAndSubtitlePlacement() {
        self.secondaryStackView.removeAllArrangedSubviews()

        switch self.textLayoutPreference {
        case .titleFirst:
            self.secondaryStackView.addArrangedSubview(self.titleStack)

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

            self.secondaryStackView.addArrangedSubview(self.titleStack)
        }
    }

    private func setupNewView(state: IsNew) {
        switch state {
        case .true(let localizableTitle):
            self.isNewView.text = localizableTitle
            self.titleStack.addArrangedSubview(self.isNewView)
            self.setupIsNewConstraints()
        case .false:
            self.isNewView.removeFromSuperview()
        }
    }

    public func add(bagde paddingLabel: PBPaddingLabel) {
        self.rightSideContentStack.addArrangedSubview(paddingLabel)

        NSLayoutConstraint.activate([
            paddingLabel.widthAnchor.constraint(equalToConstant: paddingLabel.intrinsicContentSize.width),
            paddingLabel.heightAnchor.constraint(equalToConstant: paddingLabel.intrinsicContentSize.height),
        ])

        self.rightSideContentStack.semanticContentAttribute = .forceRightToLeft
    }

    private func updateMultilineSupport(to isEnabled: Bool) {
        if isEnabled {
            self.titleLabel.numberOfLines = 0
            self.subtitleLabel.numberOfLines = 0
        } else {
            self.titleLabel.numberOfLines = 1
            self.subtitleLabel.numberOfLines = 1
        }
    }

    private func setupConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.primaryStackView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            self.primaryStackView.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor),
            self.primaryStackView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor),
            self.primaryStackView.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor)
        ])

        self.setupLeftIconWrapperConstraints(for: self.leftViewSize)
        self.setupLeftIconConstraints(for: self.leftIconContentInsets)
        self.setupDividerConstraints(by: self.leftPaddingForDivider)

        NSLayoutConstraint.activate([
            self.rightIconView.topAnchor.constraint(equalTo: self.rightIconWrapperView.topAnchor, constant: 3.0),
            self.rightIconView.leftAnchor.constraint(equalTo: self.rightIconWrapperView.leftAnchor, constant: 6.0),
            self.rightIconView.bottomAnchor.constraint(equalTo: self.rightIconWrapperView.bottomAnchor, constant: -3.0),
            self.rightIconView.rightAnchor.constraint(equalTo: self.rightIconWrapperView.rightAnchor)
        ])

        self.setNeedsUpdateConstraints()
    }

    private func setupLeftIconWrapperConstraints(for size: CGSize) {
        NSLayoutConstraint.deactivate(self.activeLeftIconWrapperConstraints)

        self.activeLeftIconWrapperConstraints =  [
            self.leftIconWrapperView.widthAnchor.constraint(equalToConstant: size.width),
            self.leftIconWrapperView.heightAnchor.constraint(equalToConstant: size.height)
        ]

        NSLayoutConstraint.activate(self.activeLeftIconWrapperConstraints)
    }

    private func setupLeftIconConstraints(for contentInsets: UIEdgeInsets) {
        NSLayoutConstraint.deactivate(self.activeLeftIconConstraints)

        self.activeLeftIconConstraints = [
            self.leftIconView.topAnchor.constraint(equalTo: self.leftIconWrapperView.topAnchor, constant: contentInsets.top),
            self.leftIconView.leftAnchor.constraint(equalTo: self.leftIconWrapperView.leftAnchor, constant: contentInsets.left),
            self.leftIconView.bottomAnchor.constraint(equalTo: self.leftIconWrapperView.bottomAnchor, constant: -contentInsets.bottom),
            self.leftIconView.rightAnchor.constraint(equalTo: self.leftIconWrapperView.rightAnchor, constant: -contentInsets.right)
        ]

        NSLayoutConstraint.activate(self.activeLeftIconConstraints)
    }

    private func setupIsNewConstraints() {
        NSLayoutConstraint.activate([
            self.isNewView.widthAnchor.constraint(equalToConstant: self.isNewView.intrinsicContentSize.width),
            self.isNewView.heightAnchor.constraint(equalToConstant: self.isNewView.intrinsicContentSize.height),
        ])

        self.setNeedsUpdateConstraints()
    }

    private func setupDividerConstraints(by padding: CGFloat) {
        NSLayoutConstraint.deactivate(self.activeDividerConstraints)

        self.activeDividerConstraints = [
            self.divider.leftAnchor.constraint(equalTo: self.leftAnchor, constant: padding),
            self.divider.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.divider.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]

        NSLayoutConstraint.activate(self.activeDividerConstraints)
    }

    private func setupLeftIconCornerRadius(style: Style) {
        switch style {
        case .roundedRect(cornerRadius: let cornerRadius):
            self.leftIconWrapperView.layer.cornerRadius = cornerRadius
        case .circle:
            self.leftIconWrapperView.layer.cornerRadius = self.leftViewSize.width / 2
        }
    }
}

