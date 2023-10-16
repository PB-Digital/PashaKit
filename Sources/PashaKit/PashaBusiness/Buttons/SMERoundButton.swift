//
//  SMERoundButton.swift
//
//
//  Created by Farid Valiyev on 28.07.23.
//

//  MIT License
//
//  Copyright (c) 2023 Farid Valiyev
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
/// - Note: SMERoundButton is optimized for looking as expected with minimum effort at the `height` of 56.0 pt.
///
/// However feel free to customize it.
///
public class SMERoundButton: UIView {

    public enum SMERoundButtonType {
        case plain
        case withTitle(localizableTitle: String)
        case disabled(localizableTitle: String, localizableDisableTitle: String)
    }

    /// Specifies the state of button
    public enum SMERoundButtonState {

        /// A  button with clear background color and SMEGreen title color
        ///
        /// By default title color of button will be in SMEGreen color. However if theme option is used,
        /// its title color may be PBFauxChestnut depending on returned user type.
        ///
        case normal

        /// A button with 0.1 opacity PBGreen background color and SMEGreen title color
        ///
        /// By default background color of button will be in SMEGreen color with 0.1 opacity. However if theme option is used,
        /// its background color may be different color depending on returned user type.
        ///
        case disabled
        
    }
    
    public enum IconSize {
        case small
        case medium
        case large
    }

    private var seconds: Int = 0
    
    var smallSizeConstraints: [NSLayoutConstraint] = []
    var mediumSizeConstraints: [NSLayoutConstraint] = []
    var largeSizeConstraints: [NSLayoutConstraint] = []
    
    /// Sets the title to use for normal state.
    ///
    /// Since we're using only normal state for UIButton, at the moment SMERoundButton also uses only normal state when setting
    /// button title.
    /// For different states use native
    /// ```
    /// func setTitle(_ title: String?, for state: UIControl.State)
    /// ```
    ///
    public var title: String = "" {
        didSet {
            self.titleLabel.text = self.title
        }
    }
    
    public var disableTitle: String = "" {
        didSet {
            self.disableTitleLabel.text = self.disableTitle
        }
    }

    /// Sets the image for displaying on the left side of button.
    ///
    /// By default button will be created with only its title. If you are willing to add
    /// image in future, just set the desired image to this property.
    ///
    public var image: UIImage? {
        didSet {
            self.iconView.image = image
        }
    }

    /// The radius to use when drawing rounded corners for the layer’s background.
    ///
    /// By default it will set 12.0 to corner radius property of button.
    ///
    public var cornerRadius: CGFloat = 12.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }

    /// Button's background color.
    ///
    /// By default button will be created with the background color for selected button style.
    ///
    public var baseBackgroundColor: UIColor = .clear {
        didSet {
            self.backgroundColor = self.baseBackgroundColor
        }
    }

    /// The tint color to apply to the button title and image.
    ///
    /// By default button will be created with the tint color for selected button style.
    ///
    public var buttonTitleWeight: CustomFontWeight = .semibold {
        didSet {
            self.titleLabel.font = UIFont.sfProText(ofSize: 13, weight: buttonTitleWeight)
        }
    }
    
    public var iconBackgroundColor: UIColor = .clear {
        didSet {
            self.iconWrapperView.backgroundColor = self.iconBackgroundColor
        }
    }

    /// The color of button's border.
    ///
    /// By default button will be created with the border color for selected button style.
    ///
    public var borderColor: UIColor = .clear {
        didSet {
            self.layer.borderWidth = 1
            self.layer.borderColor = self.borderColor.cgColor
        }
    }

    /// The theme for the button's appearance.
    ///
    /// SMERoundButton is using theme parameter for defining its color palette for components. These include button's
    /// * Background color
    /// * Border color
    /// * Title color
    /// * Tint color
    ///
    public var theme: SMEUIButtonTheme = .regular {
        didSet {
            self.prepareButtonByState()
        }
    }

    private var typeOfButton: SMERoundButtonType = .plain {
        didSet {
            self.prepareButtonByType()
        }
    }

    /// Specifies style of the button.
    ///
    /// If not specified by outside, PBBRoundButton will be created with filled style.
    ///
    public var stateOfButton: SMERoundButtonState = .normal {
        didSet {
            self.prepareButtonByState()
        }
    }
    
    public var iconSize: IconSize = .large {
        didSet {
            switch self.iconSize {
            case .small:
                NSLayoutConstraint.activate(self.smallSizeConstraints)
                NSLayoutConstraint.deactivate(self.mediumSizeConstraints)
                NSLayoutConstraint.deactivate(self.largeSizeConstraints)
                self.iconWrapperView.layer.cornerRadius = 12
            case .medium:
                NSLayoutConstraint.deactivate(self.smallSizeConstraints)
                NSLayoutConstraint.activate(self.mediumSizeConstraints)
                NSLayoutConstraint.deactivate(self.largeSizeConstraints)
                self.iconWrapperView.layer.cornerRadius = 16
            case .large:
                NSLayoutConstraint.deactivate(self.smallSizeConstraints)
                NSLayoutConstraint.deactivate(self.mediumSizeConstraints)
                NSLayoutConstraint.activate(self.largeSizeConstraints)
                self.iconWrapperView.layer.cornerRadius = 24
            }
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()

        label.textAlignment = .center
        label.text = self.title
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private lazy var iconWrapperView: UIView = {
        let view = UIView()

        self.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    private lazy var iconView: UIImageView  = {
        let view = UIImageView()

        self.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false

        view.contentMode = .scaleAspectFit

        return view
    }()
    
    private lazy var disableTitleLabel: UILabel = {
        let label = UILabel()

        label.textAlignment = .center
        label.text = self.disableTitle

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private lazy var disableView: UIView = {
        let view = UIView()

        view.backgroundColor = .red
        
        self.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    /// Creates a new button of specified style.
    ///
    /// - Parameters:
    ///    - localizableTitle: Sets the title text for button.
    ///    - typeOfButton: Sets the type of button.
    ///
    
    public convenience init(typeOfButton: SMERoundButtonType = .plain) {
        self.init()
        
        UIFont.registerCustomFonts()
        self.typeOfButton = typeOfButton
        self.stateOfButton = .normal
        
        self.prepareButtonByType()
        self.prepareButtonByState()
        
        self.setupViews(for: typeOfButton)
        
    }

    public convenience init(typeOfButton: SMERoundButtonType = .plain,
                            stateOfButton: SMERoundButtonState) {
        self.init()
        
        UIFont.registerCustomFonts()
        
        self.typeOfButton = typeOfButton
        self.prepareButtonByType()
        self.stateOfButton = stateOfButton
        self.prepareButtonByState()
       
        self.setupViews(for: typeOfButton)
        
    }
    
    private func setupViews(for type: SMERoundButtonType) {
        
        self.iconWrapperView.addSubview(self.iconView)
        
        self.addSubview(self.iconWrapperView)

        switch type {
        case .plain:
            self.iconWrapperView.layer.cornerRadius = self.iconWrapperView.layer.frame.height / 2
        case .withTitle:
            self.addSubview(self.titleLabel)
        case .disabled:
            self.disableView.layer.cornerRadius = 8
            self.disableView.addSubview(self.disableTitleLabel)
            self.addSubview(self.disableView)
            self.addSubview(self.titleLabel)
        }
        
        self.setupConstraints(for: type)
    }
    
    private func setupConstraints(for type: SMERoundButtonType) {
        switch type {
        case .plain:
            
            NSLayoutConstraint.activate([

                self.iconView.centerXAnchor.constraint(equalTo: self.iconWrapperView.centerXAnchor),
                self.iconView.centerYAnchor.constraint(equalTo: self.iconWrapperView.centerYAnchor),
                
                self.iconWrapperView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8.0),
                self.iconWrapperView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8.0),
                self.iconWrapperView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8.0),
                self.iconWrapperView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8.0)
            ])
            
        case .withTitle:
            
            NSLayoutConstraint.activate([

                self.heightAnchor.constraint(equalToConstant: 128.0),
                self.widthAnchor.constraint(equalToConstant: 118.0),
                
                self.iconWrapperView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
                self.iconWrapperView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                
                self.iconView.centerXAnchor.constraint(equalTo: self.iconWrapperView.centerXAnchor),
                self.iconView.centerYAnchor.constraint(equalTo: self.iconWrapperView.centerYAnchor),
                
                self.titleLabel.topAnchor.constraint(equalTo: self.iconWrapperView.bottomAnchor, constant: 12.0),
                self.titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16.0),
                self.titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12.0),
                self.titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12.0)
            
            ])
            
        case .disabled:
            NSLayoutConstraint.activate([

                self.heightAnchor.constraint(equalToConstant: 128.0),
                self.widthAnchor.constraint(equalToConstant: 118.0),
                
                self.iconWrapperView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
                self.iconWrapperView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                
                self.iconView.centerXAnchor.constraint(equalTo: self.iconWrapperView.centerXAnchor),
                self.iconView.centerYAnchor.constraint(equalTo: self.iconWrapperView.centerYAnchor),
                
                self.disableTitleLabel.centerXAnchor.constraint(equalTo: self.disableView.centerXAnchor),
                self.disableTitleLabel.centerYAnchor.constraint(equalTo: self.disableView.centerYAnchor),
                
                self.disableView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                self.disableView.heightAnchor.constraint(equalToConstant: 16),
                self.disableView.widthAnchor.constraint(equalToConstant: self.disableTitleLabel.intrinsicContentSize.width + 12),
                self.disableView.bottomAnchor.constraint(equalTo: self.titleLabel.topAnchor, constant: -4.0),
                
                self.titleLabel.topAnchor.constraint(equalTo: self.iconWrapperView.bottomAnchor, constant: 12.0),
                self.titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16.0),
                self.titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12.0),
                self.titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12.0)
            
            ])
        }
        
        self.smallSizeConstraints = [
            self.iconView.widthAnchor.constraint(equalToConstant: 12.0),
            self.iconView.heightAnchor.constraint(equalToConstant: 12.0),
            self.iconWrapperView.widthAnchor.constraint(equalToConstant: 24.0),
            self.iconWrapperView.heightAnchor.constraint(equalToConstant: 24.0)
        ]
        
        self.mediumSizeConstraints = [
            self.iconView.widthAnchor.constraint(equalToConstant: 16.0),
            self.iconView.heightAnchor.constraint(equalToConstant: 16.0),
            self.iconWrapperView.widthAnchor.constraint(equalToConstant: 32.0),
            self.iconWrapperView.heightAnchor.constraint(equalToConstant: 32.0)
        ]
        
        self.largeSizeConstraints = [
            self.iconView.widthAnchor.constraint(equalToConstant: 24.0),
            self.iconView.heightAnchor.constraint(equalToConstant: 24.0),
            self.iconWrapperView.widthAnchor.constraint(equalToConstant: 48.0),
            self.iconWrapperView.heightAnchor.constraint(equalToConstant: 48.0)
        ]
        
        self.iconSize = .large
    }

    private func prepareButtonByState() {
        switch self.stateOfButton {
        case .normal:
            self.titleLabel.font = UIFont.sfProText(ofSize: 13, weight: self.buttonTitleWeight)
            self.iconBackgroundColor = self.theme.getPrimaryColor()
            self.iconWrapperView.backgroundColor = self.theme.getPrimaryColor()
        case .disabled:
            self.titleLabel.font = UIFont.sfProText(ofSize: 13, weight: .semibold)
            self.titleLabel.textColor = UIColor.Colors.SMEGray
            self.disableTitleLabel.font = UIFont.sfProText(ofSize: 11, weight: .medium)
            self.disableTitleLabel.textColor = .white
            self.iconBackgroundColor = UIColor.Colors.SMEBackgroundGray
        }
    }

    private func prepareButtonByType() {
        switch self.typeOfButton {
        case .plain:
            self.stateOfButton = .normal
        case .withTitle(let title):
            self.title = title
            self.stateOfButton = .normal
        case .disabled(let title, let disableTitle):
            self.title = title
            self.disableTitle = disableTitle
            self.stateOfButton = .disabled
        }
    }

}
