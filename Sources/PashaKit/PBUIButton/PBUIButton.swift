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

    public enum PBUIButtonType {
        case custom
        case share
        case close
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

    private var seconds: Int = 0

    /// Sets the title to use for normal state.
    ///
    /// Since we're using only normal state for UIButton, at the moment PBUIButton also uses only normal state when setting
    /// button title.
    /// For different states use native
    /// ```
    /// func setTitle(_ title: String?, for state: UIControl.State)
    /// ```
    ///
    public var buttonTitle: String = "" {
        didSet {
            self.setTitle(self.buttonTitle, for: .normal)
        }
    }

    /// Sets the image for displaying on the left side of button.
    ///
    /// By default button will be created with only its title. If you are willing to add
    /// leftImage in future, just set the desired image to this property.
    ///
    public var leftImage: UIImage? {
        didSet {
            self.setImage(self.leftImage, for: .normal)
        }
    }

    /// The radius to use when drawing rounded corners for the layer’s background.
    ///
    /// By default it will set 16.0 to corner radius property of button.
    ///
    public var cornerRadius: CGFloat = 16.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }

    /// Button's background color.
    ///
    /// By default button will be created with the background color for selected button style.
    ///
    public var baseBackgroundColor: UIColor = UIColor.Colors.PBGreen {
        didSet {
            self.backgroundColor = self.baseBackgroundColor
        }
    }

    /// The tint color to apply to the button title and image.
    ///
    /// By default button will be created with the tint color for selected button style.
    ///
    public var buttonTintColor: UIColor = UIColor.white {
        didSet {
            self.tintColor = self.buttonTintColor
            self.setTitleColor(self.buttonTintColor, for: .normal)
        }
    }

    /// The color of button's border.
    ///
    /// By default button will be created with the border color for selected button style.
    ///
    public var borderColor: UIColor = UIColor.Colors.PBGreen {
        didSet {
            switch self.styleOfButton {
            case .plain:
                self.layer.borderColor = UIColor.clear.cgColor
            case .tinted:
                self.layer.borderColor = UIColor.clear.cgColor
            case .filled:
                self.layer.borderColor = self.borderColor.cgColor
            case .outlined:
                self.layer.borderColor = self.borderColor.cgColor
            }
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
    public var theme: PBUIButtonTheme = .regular {
        didSet {
            self.prepareButtonByStyle()
        }
    }

    private var typeOfButton: PBUIButtonType = .custom {
        didSet {
            self.prepareButtonByType()
        }
    }

    /// Specifies style of the button.
    ///
    /// If not specified by outside, PBUIButton will be created with filled style.
    ///
    public var styleOfButton: PBUIButtonStyle = .filled {
        didSet {
            self.prepareButtonByStyle()
        }
    }

    override private init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }

    /// Creates a new button of specified style.
    ///
    /// - Parameters:
    ///    - localizableTitle: Sets the title text for button.
    ///    - styleOfButton: Sets the style of button.
    ///
    public convenience init(localizableTitle: String, styleOfButton: PBUIButtonStyle = .filled) {
        self.init(type: .system)
        self.setupDefaults()
        self.setTitle(localizableTitle, for: .normal)
        self.styleOfButton = styleOfButton
        self.prepareButtonByStyle()
    }

    public convenience init(localizableTitle: String, typeOfButton: PBUIButtonType) {
        self.init(type: .system)
        self.setupDefaults()
        self.setTitle(localizableTitle, for: .normal)
        self.buttonTitle = localizableTitle
        self.typeOfButton = typeOfButton
        self.prepareButtonByType()
    }

    public convenience init() {
        self.init(localizableTitle: "")
    }

    private func prepareButtonByStyle() {
        switch self.styleOfButton {
        case .plain:
            self.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            self.baseBackgroundColor = .clear
            self.buttonTintColor = self.theme.getPrimaryColor()
            self.borderColor = UIColor.clear
        case .tinted:
            self.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            self.baseBackgroundColor = self.theme.getPrimaryColor().withAlphaComponent(0.1)
            self.buttonTintColor = self.theme.getPrimaryColor()
            self.borderColor = self.theme.getPrimaryColor().withAlphaComponent(0.1)
        case .filled:
            self.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            self.baseBackgroundColor = self.theme.getPrimaryColor()
            self.buttonTintColor = UIColor.white
            self.borderColor = self.theme.getPrimaryColor()
        case .outlined:
            self.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            self.baseBackgroundColor = .clear
            self.borderColor = self.theme.getPrimaryColor()
            self.buttonTintColor = self.theme.getPrimaryColor()
            self.layer.borderWidth = 1.5
        }
    }

    private func prepareButtonByType() {
        switch self.typeOfButton {
        case .custom:
            self.styleOfButton = .plain
        case .share:
            self.makeShareButton()
        case .close:
            self.makeCloseButton()
        }
    }

    private func makeShareButton() {
        self.styleOfButton = .filled
        self.setImage(UIImage.Images.icShare, for: .normal)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
    }

    private func makeCloseButton() {
        self.styleOfButton = .plain
    }

    private func setupDefaults() {
        self.layer.cornerRadius = self.cornerRadius
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1.0
        self.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
    }
}
