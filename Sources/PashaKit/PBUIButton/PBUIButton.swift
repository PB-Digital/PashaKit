//
//  PBUIButton.swift
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

/// Subclass of UIButton with predefined and customizable style
///
///
/// When adding a button to your interface, perform the following actions:
///
/// * Set the style of the button at creation time.
/// * Supply a title string or image; size the button appropriately for your content.
/// * Connect one or more action methods to the button.
/// * Provide accessibility information and localized strings.
///
/// - Note: PBUIButton is optimized for looking as expected with minimum effort at the `height` of 56.0 pt.
///
/// However feel free to customize it.
///
public class PBUIButton: UIButton {

    /// Selection states for `PBUIButton`
    ///
    /// By default all the instances of the button will be created as in their `normal` states.
    /// However depending on the properties and user actions, the state of
    /// `PBUIButton` can change to `highlighted` or `disabled` states.
    ///
    public enum PBUIButtonState {
        /// Normal state of button. This will render `PBUIButton` based on its
        /// given style. Nothing will be added or configured on this state.
        ///
        case normal

        /// Selected or highlighted state of `PBUIButton`. This state will be set itself
        /// as a current state of `PBUIButton` when it will receive a touch from user.
        ///
        /// By default highlighted state will make selection effect by shrinking
        /// button's scale and making its color more tinted on its `normal` state.
        ///
        case highlighted

        /// Disabled state of `PBUIButton` applies specific color overlay to the button
        /// depending on the value of `disabledBackgroundColor`
        ///
        case disabled
    }

    /// Specifies the style of button
    public enum PBUIButtonStyle {

        /// A  button with clear background color and PBGreen title color
        ///
        /// By default title color of button will be in PBGreen color. However if theme option is used,
        /// its title color may be PBFauxChestnut depending on returned user type.
        ///
        case plain

        /// A button with 0.1 opacity PBGreen background color and PBGreen title color
        ///
        /// By default background color of button will be in PBGreen color with 0.1 opacity. However if theme option is used,
        /// its background color may be PBFauxChestnut depending on returned user type.
        ///
        case tinted

        /// A  button with PBGreen background color and white title color
        ///
        /// By default background color of button will be in PBGreen color. However if theme option is used,
        /// its background color may be PBFauxChestnut depending on returned user type.
        ///
        case filled

        /// A  button with PBGreen border and title color with clear background color
        ///
        /// By default border color of button will be in PBGreen color. However if theme option is used,
        /// its border color may be PBFauxChestnut depending on returned user type.
        ///
        case outlined
    }

    // MARK: - PUBLIC PROPERTIES

    /// The `buttonTitle` property of a `PBUIButton` allows you to manipulate 
    /// the title text displayed on the button in its normal state.
    ///
    /// This property is used to both set and retrieve the button's title text, providing a
    /// convenient way to customize the button's label.
    ///
    /// To retrieve the current title text:
    /// ```swift
    /// let currentTitle = myButton.buttonTitle
    /// ```
    ///
    /// To set a new title text:
    /// ```swift
    /// myButton.buttonTitle = "Click Me"
    /// ```
    ///
    /// - Note: The title text is displayed when the button is in its normal state, as defined by the UIControlState `.normal`. For different states use native method
    ///
    /// ```swift
    /// func setTitle(_ title: String?, for state: UIControl.State)
    /// ```
    ///
    public var buttonTitle: String? {
        get {
            self.title(for: .normal)
        }

        set {
            self.setTitle(newValue, for: .normal)
        }
    }

    /// The `titleFont` property of a `PBUIButton` allows you to manage the font of 
    /// the title text displayed on the button. You can set or retrieve the font used for the button's title.
    ///
    /// By default, the button is created with the system font of size `17` and `semibold` weight.
    ///
    /// To retrieve the current title font:
    /// ```swift
    /// let currentFont = myButton.titleFont
    /// ```
    ///
    /// To set a new title font:
    /// ```swift
    /// myButton.titleFont = UIFont.systemFont(ofSize: 16.0, weight: .regular)
    /// ```
    ///
    /// - Important: The `titleFont` property affects the font used for the title text of the button. 
    /// If the `titleLabel` is `nil`, setting this property has no effect. Make sure the `titleLabel`
    /// is initialized and not `nil` before setting the font.
    ///
    /// - Note: To customize other text attributes (e.g., text color, alignment, or shadow), you may need to work with the `setTitle(_:for:)` method and `setAttributedTitle(_:for:)` method in combination with this property.
    ///
    public var titleFont: UIFont? {
        get {
            self.titleLabel?.font
        }

        set {
            self.titleLabel?.font = newValue
        }
    }

    /// The `leftImage` property of a `PBUIButton` allows you to manage the image displayed 
    /// on the left side of the button's title text in its normal state. Use this property to set or retrieve
    /// the left image for the button.
    ///
    /// To retrieve the current left image:
    /// ```swift
    /// let currentImage = myButton.leftImage
    /// ```
    ///
    /// To set a new left image:
    /// ```swift
    /// myButton.leftImage = UIImage(named: "icon")
    /// ```
    ///
    /// - Note: The left image is displayed when the button is in its normal state, as defined by 
    /// the UIControlState `.normal`. When setting a new left image, make sure it is properly sized
    /// and formatted to fit within the button's layout.
    ///
    public var leftImage: UIImage? {
        get {
            return self.image(for: .normal)
        }

        set {
            self.setImage(newValue, for: .normal)
        }
    }


    /// The `cornerRadius` property of a `PBUIButton` allows you to control the corner radius 
    /// of the button's layer, giving it rounded corners. By default, the corner radius is set to `16.0`.
    ///
    /// To retrieve the current corner radius:
    /// ```swift
    /// let currentCornerRadius = myButton.cornerRadius
    /// ```
    ///
    /// To set a new corner radius:
    /// ```swift
    /// myButton.cornerRadius = 10.0
    /// ```
    ///
    /// - Note: The `cornerRadius` property affects the appearance of the button's corners, 
    /// creating rounded edges. Make sure to provide a non-negative value for the corner radius.
    /// A value of `0.0` results in square corners.
    ///
    public var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }

        set {
            self.layer.cornerRadius = newValue
        }
    }


    /// The `borderWidth` property of a `PBUIButton` allows you to control the thickness of the border 
    /// around the button's layer. By default, the border width is set to `2.0`, providing a visible border
    /// around the button.
    ///
    /// To retrieve the current border width:
    /// ```swift
    /// let currentBorderWidth = myButton.borderWidth
    /// ```
    ///
    /// To set a new border width:
    /// ```swift
    /// myButton.borderWidth = 3.5
    /// ```
    ///
    /// - Note: The `borderWidth` property affects the visual appearance of the button's border. 
    /// A value of 0.0 means no border is displayed, while higher values increase the thickness of the border.
    /// Ensure that you provide a non-negative value for the border width.
    ///
    public var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }

        set {
            self.layer.borderWidth = newValue
        }
    }

    /// The `backgroundColor` property of a `PBUIButton` allows you to set or retrieve 
    /// the background color of the button in its normal state. By default, the background color is
    /// set to `UIColor(resource: .PBMeadow.light)` if not explicitly provided.
    ///
    /// To retrieve the current background color:
    /// ```swift
    /// let currentBackgroundColor = myButton.backgroundColor
    /// ```
    ///
    /// To set a new background color:
    /// ```swift
    /// myButton.backgroundColor = UIColor.red
    /// ```
    ///
    /// - Note: The `backgroundColor` property affects the appearance of the button's 
    /// background when it is in its normal state, as defined by the UIControlState `.normal`.
    ///
    public override var backgroundColor: UIColor? {
        get {
            return self._backgroundColors[.normal]
        }

        set {
            self._backgroundColors[.normal] = newValue ?? UIColor(resource: .PBMeadow.light)
        }
    }

    /// The `tintColor` property of a `PBUIButton` allows you to set or retrieve the tint color 
    /// for the button in its normal state. By default, the tint color is set to `.white` if not explicitly provided.
    ///
    /// To retrieve the current tint color:
    /// ```swift
    /// let currentTintColor = myButton.tintColor
    /// ```
    ///
    /// To set a new tint color:
    /// ```swift
    /// myButton.tintColor = UIColor.blue
    /// ```
    ///
    /// - Note: The `tintColor` property affects the color of various elements such as images and 
    /// text when the button is in its normal state, as defined by the UIControlState `.normal`.
    ///
    public override var tintColor: UIColor! {
        get {
            return self._tintColors[.normal]
        }

        set {
            self._tintColors[.normal] = newValue ?? .white
        }
    }

    /// The `borderColor` property of a `PBUIButton` allows you to set or retrieve the border color 
    /// for the button in its normal state. By default, the border color is set to
    /// `UIColor(resource: .PBMeadow.light)` if not explicitly provided.
    ///
    /// To retrieve the current border color:
    /// ```
    /// let currentBorderColor = myButton.borderColor
    /// ```
    ///
    /// To set a new border color:
    /// ```
    /// myButton.borderColor = UIColor.gray
    /// ```
    ///
    /// - Note: The `borderColor` property affects the color of the border around the button when 
    /// it is in its normal state, as defined by the UIControlState `.normal`.
    ///
    public var borderColor: UIColor? {
        get {
            return self._borderColors[.normal]
        }

        set {
            self._borderColors[.normal] = newValue ?? UIColor(resource: .PBMeadow.light)
        }
    }

    /// The theme for the button's appearance.
    ///
    /// `PBUIButton` uses the `theme` parameter to define its color palette for differentiating 
    /// between retail and private customers on Pasha Bank's mobile application.
    /// The theme settings include:
    ///
    /// * Background color
    /// * Border color
    /// * Title color
    /// * Tint color
    ///
    /// To set a new theme for the button:
    /// ```swift
    /// myButton.theme = .regular
    /// ```
    ///
    /// - Note: Setting the `theme` property triggers the button to update its color scheme and 
    /// style based on the provided `PBUIButtonTheme`, allowing you to create distinct visual
    /// representations for retail and private customers.
    ///
    public var theme: PBUIButtonTheme? {
        didSet {
            self.setupColorScheme(with: self.styleOfButton)
        }
    }


    /// Specifies the style of the button.
    ///
    /// If not explicitly specified, `PBUIButton` will be created with the "filled" style by default. 
    /// Available styles include:
    ///
    /// * `Filled`: A button with a filled background.
    /// * `Tinted`: A button with tinted background.
    /// * `Outlined`: A button with an outlined appearance.
    /// * `Plain`: A button with no additional styling.
    ///
    /// To set a specific style for the button:
    /// ```swift
    /// myButton.styleOfButton = .outlined
    /// ```
    ///
    /// - Note: The `styleOfButton` property determines the visual appearance of the button 
    /// and can be customized to match your design requirements.
    ///
    public var styleOfButton: PBUIButtonStyle = .filled {
        didSet {
            self.setupColorScheme(with: self.styleOfButton)
        }
    }

    /// Indicates whether the button is currently enabled for user interaction.
    ///
    /// This property overrides the `isEnabled` property of `UIView`. When the button is enabled, 
    /// its state is set to `.normal`, and when it's disabled, the state changes to `.disabled`.
    /// This property allows you to control the button's interactivity.
    ///
    /// To enable or disable the button:
    /// ```swift
    /// myButton.isEnabled = true // Enables the button.
    /// myButton.isEnabled = false // Disables the button.
    /// ```
    ///
    /// - Note: The button's state is automatically adjusted based on its enablement status, 
    /// affecting its appearance and interaction with user actions.
    ///
    public override var isEnabled: Bool {
        didSet {
            if self.isEnabled {
                self._state = .normal
            } else {
                self._state = .disabled
            }
        }
    }

    private var _state: PBUIButtonState = .normal {
        didSet {
            switch self._state {
            case .normal:
                makeButton(enabled: true)
            case .highlighted:
                makeButton(highlighted: true)
            case .disabled:
                makeButton(enabled: false)
            }
        }
    }

    private lazy var _backgroundColors: [PBUIButtonState : UIColor] = [:] {
        didSet {
            self.updateColorScheme(for: self._state)
        }
    }

    private lazy var _tintColors: [PBUIButtonState : UIColor] = [:] {
        didSet {
            self.updateColorScheme(for: self._state)
        }
    }

    private lazy var _borderColors: [PBUIButtonState: UIColor] = [:] {
        didSet {
            self.updateColorScheme(for: self._state)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    /// Initializes button with `empty` title.
    ///
    public convenience init() {
        self.init(localizableTitle: "")
    }

    /// Creates a new button of specified style.
    ///
    /// - Parameters:
    ///    - localizableTitle: Sets the title text for button.
    ///    - style: Sets the style of button.
    ///
    public convenience init(localizableTitle: String, styleOfButton: PBUIButtonStyle = .filled) {
        self.init(type: .custom)

        self.buttonTitle = localizableTitle
        self.styleOfButton = styleOfButton

        self.commonInit()
    }

    private func commonInit() {
        self.setupDefaults()
        self.setupColorScheme(with: self.styleOfButton)
    }

    private func setupColorScheme(with style: PBUIButtonStyle) {
        guard let theme else {
            self.set(backgroundColor: .systemBlue, for: .normal, .highlighted)
            self.set(borderColor: .clear, for: .normal, .highlighted)
            self.set(tintColor: .white, for: .normal, .highlighted)
            return
        }

        switch style {
        case .plain:
            self.set(backgroundColor: .clear, for: .normal, .highlighted)
            self.set(borderColor: .clear, for: .normal, .highlighted)
            self.set(tintColor: theme.getPrimaryColor(), for: .normal, .highlighted)
        case .tinted:
            self.set(backgroundColor: theme.getPrimaryColor().withAlphaComponent(0.14), for: .normal)
            self.set(backgroundColor: theme.getPrimaryColor().withAlphaComponent(0.24), for: .highlighted)

            self.set(borderColor: theme.getPrimaryColor().withAlphaComponent(0.14), for: .normal)
            self.set(borderColor: theme.getPrimaryColor().withAlphaComponent(0.24), for: .highlighted)

            self.set(tintColor: theme.getPrimaryColor(), for: .normal, .highlighted)
        case .filled:
            self.set(backgroundColor: theme.getPrimaryColor(), for: .normal)
            self.set(backgroundColor: theme.getSecondaryColor(), for: .highlighted)

            self.set(borderColor: theme.getPrimaryColor(), for: .normal)
            self.set(borderColor: theme.getSecondaryColor(), for: .highlighted)

            self.set(tintColor: .white, for: .normal, .highlighted)
        case .outlined:
            self.set(backgroundColor: .clear, for: .normal, .highlighted)
            self.set(borderColor: theme.getPrimaryColor(), for: .normal, .highlighted)
            self.set(tintColor: theme.getPrimaryColor(), for: .normal, .highlighted)
        }

        self.set(backgroundColor: UIColor(resource: .grey200), for: .disabled)
        self.set(borderColor: UIColor(resource: .grey200), for: .disabled)
        self.set(tintColor: UIColor(resource: .grey500), for: .disabled)
    }

    private func updateColorScheme(for state: PBUIButtonState) {
        self.updateBackgroundColor(to: self._backgroundColors[state])
        self.updateBorderColor(to: self._borderColors[state])
        self.updateTintColor(to: self._tintColors[state])
    }

    private func makeButton(enabled: Bool) {
        if enabled {
            self.isUserInteractionEnabled = true
            self.updateColorScheme(for: PBUIButtonState.normal)
        } else {
            self.isUserInteractionEnabled = false
            self.updateColorScheme(for: PBUIButtonState.disabled)
        }
    }

    private func makeButton(highlighted: Bool) {
        self.updateColorScheme(for: PBUIButtonState.highlighted)
    }

    private func updateBackgroundColor(to newValue: UIColor?) {
        switch self.styleOfButton {
        case .plain, .outlined:
            super.backgroundColor = .clear
        case .tinted:
            if let newValue {
                if newValue.rgba.alpha >= 1.0 {
                    super.backgroundColor = newValue.withAlphaComponent(0.14)
                } else {
                    super.backgroundColor = newValue
                }
            }
        case .filled:
            super.backgroundColor = newValue
        }
    }

    private func updateBorderColor(to newValue: UIColor?) {
        switch self.styleOfButton {
        case .plain, .tinted:
            super.layer.borderColor = UIColor.clear.cgColor
        case .filled, .outlined:
            super.layer.borderColor = newValue?.cgColor
        }
    }

    private func updateTintColor(to newValue: UIColor?) {
        super.tintColor = newValue
        self.setTitleColor(newValue, for: .normal)
        self.imageView?.tintColor = newValue
    }

    private func setupDefaults() {
        self.layer.cornerRadius = 16.0
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.masksToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        self.setTitle(self.buttonTitle, for: .normal)
    }

    public func set(backgroundColor: UIColor, for states: PBUIButtonState...) {
        setColors(&_backgroundColors, backgroundColor, for: states)
    }

    public func set(borderColor: UIColor, for states: PBUIButtonState...) {
        setColors(&_borderColors, borderColor, for: states)
    }

    public func set(tintColor: UIColor, for states: PBUIButtonState...) {
        setColors(&_tintColors, tintColor, for: states)
    }

    private func setColors(
        _ colorDictionary: inout [PBUIButtonState: UIColor],
        _ color: UIColor,
        for states: [PBUIButtonState]
    ) {
        states.forEach { state in
            colorDictionary[state] = color
        }
    }
}

extension PBUIButton {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.performAnimation { [weak self] in
            self?.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
            self?._state = .highlighted
        }
    }

    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.performAnimation { [weak self] in
            self?.transform = .identity
            self?._state = .normal
        }
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.performAnimation { [weak self] in
            self?.transform = .identity
            self?._state = .normal
        }
    }
}

@available(iOS 17, *)
#Preview {
    let button = PBUIButton()
    button.buttonTitle = "Button Title"

    NSLayoutConstraint.activate([
        button.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 32.0),
        button.heightAnchor.constraint(equalToConstant: 56.0)
    ])

    return button
}
