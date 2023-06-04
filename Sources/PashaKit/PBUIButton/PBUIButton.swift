//
//  File.swift
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

    /// Sets the title to use for normal state.
    ///
    /// Since we're using only normal state for UIButton, at the moment PBUIButton also uses only normal state when setting
    /// button title.
    /// For different states use native
    /// ```
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

    public var titleFont: UIFont = UIFont.systemFont(ofSize: 17, weight: .semibold) {
        didSet {
            self.titleLabel?.font = self.titleFont
        }
    }

    /// Sets the image for displaying on the left side of button.
    ///
    /// By default button will be created with only its title. If you are willing to add
    /// leftImage in future, just set the desired image to this property.
    ///
    public var leftImage: UIImage? {
        get {
            self.image(for: .normal)
        }

        set {
            self.setImage(newValue, for: .normal)
        }
    }

    /// The radius to use when drawing rounded corners for the layer’s background.
    ///
    /// By default it will set 16.0 to corner radius property of button.
    ///
    public var cornerRadius: CGFloat = 16.0 {
        didSet(cornerRadius) {
            self.layer.borderWidth = cornerRadius
        }
    }

    public var borderWidth: CGFloat = 0.0 {
        didSet(borderWidth) {
            self.layer.borderWidth = borderWidth
        }
    }

    public override var backgroundColor: UIColor? {
        get {
            return self._backgroundColors[.normal]
        }

        set(backgroundColor) {
            self._backgroundColors[.normal] = backgroundColor ?? .PBMeadow.background
        }
    }

    public override var tintColor: UIColor! {
        get {
            return self._tintColors[.normal]
        }

        set(tintColor) {
            self._tintColors[.normal] = tintColor ?? .white
        }
    }

    /// The color of button's border.
    ///
    /// By default button will be created with the border color for selected button style.
    ///
    public var borderColor: UIColor? {
        get {
            return self._borderColors[.normal]
        }

        set(borderColor) {
            self._borderColors[.normal] = tintColor ?? .PBMeadow.background
        }
    }

    /// The theme for the button's appearance.
    ///
    /// PBUIButton is using theme parameter for defining its color palette for components. These include button's
    /// * Background color
    /// * Border color
    /// * Title color
    /// * Tint color
    ///
    public var theme: PBUIButtonTheme? {
        didSet {
            self.setupColorScheme(with: self.styleOfButton)
        }
    }

    /// Specifies style of the button.
    ///
    /// If not specified by outside, PBUIButton will be created with filled style.
    ///
    public var styleOfButton: PBUIButtonStyle = .filled {
        didSet {
            self.setupColorScheme(with: self.styleOfButton)
        }
    }

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

        self.setTitle(self.buttonTitle, for: .normal)
        self.setupColorScheme(with: self.styleOfButton)
    }

    private func setupColorScheme(with style: PBUIButtonStyle) {
        if let theme = self.theme {
            switch style {
            case .plain:
                self.set(backgroundColor: .clear, for: [.normal, .highlighted])
                self.set(borderColor: .clear, for: [.normal, .highlighted])
                self.set(tintColor: theme.getPrimaryColor(), for: [.normal, .highlighted])
            case .tinted:
                self.set(backgroundColor: theme.getPrimaryColor().withAlphaComponent(0.14), for: .normal)
                self.set(backgroundColor: theme.getPrimaryColor().withAlphaComponent(0.24), for: .highlighted)

                self.set(borderColor: theme.getPrimaryColor().withAlphaComponent(0.14), for: .normal)
                self.set(borderColor: theme.getPrimaryColor().withAlphaComponent(0.24), for: .highlighted)

                self.set(tintColor: theme.getPrimaryColor(), for: [.normal, .highlighted])
            case .filled:
                self.set(backgroundColor: theme.getPrimaryColor(), for: .normal)
                self.set(backgroundColor: theme.getSecondaryColor(), for: .highlighted)

                self.set(borderColor: theme.getPrimaryColor(), for: [.normal, .highlighted])

                self.set(tintColor: .white, for: [.normal, .highlighted])
            case .outlined:
                self.set(backgroundColor: .clear, for: [.normal, .highlighted])
                self.set(borderColor: theme.getPrimaryColor(), for: [.normal, .highlighted])
                self.set(tintColor: theme.getPrimaryColor(), for: [.normal, .highlighted])
            }

            self.set(backgroundColor: .PBGray90, for: .disabled)
            self.set(borderColor: .PBGray90, for: .disabled)
            self.set(tintColor: .PBGray70, for: .disabled)
        }
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
        self.layer.masksToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
    }

    public func set(backgroundColor: UIColor, for state: PBUIButtonState) {
        set(backgroundColor: backgroundColor, for: [state])
    }

    public func set(backgroundColor: UIColor, for states: [PBUIButtonState]) {
        setColors(&_backgroundColors, backgroundColor, for: states)
    }

    public func set(borderColor: UIColor, for state: PBUIButtonState) {
        set(borderColor: borderColor, for: [state])
    }

    public func set(borderColor: UIColor, for states: [PBUIButtonState]) {
        setColors(&_borderColors, borderColor, for: states)
    }

    public func set(tintColor: UIColor, for state: PBUIButtonState) {
        set(tintColor: tintColor, for: [state])
    }

    public func set(tintColor: UIColor, for states: [PBUIButtonState]) {
        setColors(&_tintColors, tintColor, for: states)
    }

    private func setColors(_ colorDictionary: inout [PBUIButtonState: UIColor], _ color: UIColor, for states: [PBUIButtonState]) {
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
