//
//  SMEActionView.swift
//
//
//  Created by Farid Valiyev on 30.07.23.
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
/// - Note: SMEActionView is optimized for looking as expected with minimum effort at the `height` of 72.0 pt.
///
/// However feel free to customize it.
///

public class SMEActionView: UIView {

    public enum SMEIcon {
        case none
        case hasIcon(icon: UIImage)
    }
    
    public enum SMEActionType {
        case normal(icon: SMEIcon = .none, localizedTitleText: String)
        case detailed(icon: SMEIcon = .none, localizedTitleText: String, localizedSubTitleText: String)
        case footerLabel(icon: SMEIcon = .none, localizedTitleText: String, localizedSubTitleText: String, localizedDescriptionText: String)
    }
    
    public enum SMEActionState {
        case normal
        case disabled
        case selected
    }

    public enum SMEActionStyle {
        case none
        case chevron
        case loading
        case chevronWithText(localizedText: String)
        case chevronWithStatus(localizedText: String, status: SMELabelView.SMELabelViewStatus)
        case chevronWithButton(localizedText: String)
        case radioButton(isSelected: Bool)
        case switchButton(isSelected: Bool)
    }

    public enum IconSize {
        case small
        case medium
        case large
    }
    
    var smallSizeConstraints: [NSLayoutConstraint] = []
    var mediumSizeConstraints: [NSLayoutConstraint] = []
    var largeSizeConstraints: [NSLayoutConstraint] = []
    
    /// Sets the title to use for normal state.
    ///
    /// Since we're using only normal state for UIButton, at the moment PBUIButton also uses only normal state when setting
    /// button title.
    /// For different states use native
    /// ```
    /// func setTitle(_ title: String?, for state: UIControl.State)
    /// ```
    ///
    public var title: String = "" {
        didSet {
            self.titleLabel.text = title
        }
    }
    
    public var subTitle: String = "" {
        didSet {
            self.subTitleLabel.text = subTitle
        }
    }
    
    public var infoDescriptionText: String = "" {
        didSet {
            self.infoDescriptionLabel.text = infoDescriptionText
        }
    }
    
    /// Sets the image for displaying on the left side of button.
    ///
    /// By default button will be created with only its title. If you are willing to add
    /// image in future, just set the desired image to this property.
    ///
    public var leftIcon: UIImage? {
        didSet {
            self.leftIconView.image = leftIcon
        }
    }

    /// The radius to use when drawing rounded corners for the layer’s background.
    ///
    /// By default it will set 12.0 to corner radius property of button.
    ///
    public var cornerRadius: CGFloat = 12.0 {
        didSet {
            self.baseView.layer.cornerRadius = self.cornerRadius
        }
    }
    
    /// Button's background color.
    ///
    /// By default button will be created with the background color for selected button style.
    ///
    public var baseBackgroundColor: UIColor = .clear {
        didSet {
            self.baseView.backgroundColor = self.baseBackgroundColor
        }
    }
    
    public var leftIconBackgroundColor: UIColor = .clear {
        didSet {
            self.leftIconWrapperView.backgroundColor = self.leftIconBackgroundColor
        }
    }
    
    /// The color of button's border.
    ///
    /// By default button will be created with the border color for selected button style.
    ///
    public var borderColor: UIColor = .clear {
        didSet {
            self.baseView.layer.borderWidth = 1
            self.baseView.layer.borderColor = self.borderColor.cgColor
        }
    }
    
    public var onButtonPressed: (() -> Void)?
    public var onViewPressed: (() -> Void)?
    
    /// The theme for the button's appearance.
    ///
    /// SMEUIButton is using theme parameter for defining its color palette for components. These include button's
    /// * Background color
    /// * Border color
    /// * Title color
    /// * Tint color
    ///
    public var theme: SMEUIButtonTheme = .regular {
        didSet {/*TODO: Review again*/}
    }
    
    private var typeOfAction: SMEActionType = .normal(localizedTitleText: "") {
        didSet {
            /*TODO: Review again*/
            self.prepareActionViewByType()
        }
    }

    /// Specifies style of the actionView.
    ///
    /// If not specified by outside, SMEActionView will be created with filled style.
    ///
    public var stateOfAction: SMEActionState = .normal {
        didSet {
            /*TODO: Review again*/
            self.prepareActionViewByState()
        }
    }
    
    public var statusTypeOfAction: SMELabelView.SMELabelViewStatus = .new {
        didSet {
            /*TODO: Review again*/
        }
    }
    
    public var styleOfAction: SMEActionStyle = .none {
        didSet {
            self.prepareActionViewByStyle()
        }
    }
    
    public var iconSize: IconSize = .large {
        didSet {
            switch self.iconSize {
            case .small:
                NSLayoutConstraint.activate(self.smallSizeConstraints)
                NSLayoutConstraint.deactivate(self.mediumSizeConstraints)
                NSLayoutConstraint.deactivate(self.largeSizeConstraints)
                self.leftIconWrapperView.layer.cornerRadius = 12
            case .medium:
                NSLayoutConstraint.deactivate(self.smallSizeConstraints)
                NSLayoutConstraint.activate(self.mediumSizeConstraints)
                NSLayoutConstraint.deactivate(self.largeSizeConstraints)
                self.leftIconWrapperView.layer.cornerRadius = 16
            case .large:
                NSLayoutConstraint.deactivate(self.smallSizeConstraints)
                NSLayoutConstraint.deactivate(self.mediumSizeConstraints)
                NSLayoutConstraint.activate(self.largeSizeConstraints)
                self.leftIconWrapperView.layer.cornerRadius = 24
            }
        }
    }
    
    public var radioButtonStatus: Bool = false {
        didSet {
            if self.radioButtonStatus {
                self.radioButtonIcon.image = UIImage.Images.icRadioSelected
            } else {
                self.radioButtonIcon.image = UIImage.Images.icRadioDefault
            }
        }
    }
    
    public var switchButtonStatus: Bool = false {
        didSet {
            self.switchButton.setOn(switchButtonStatus, animated: true)
        }
    }
    
    private lazy var baseView: UIView = {
        let view = UIView()

        self.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleViewClick))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    private lazy var titleStackView: UIStackView = {
        let view = UIStackView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.sizeToFit()
        view.alignment = .leading
        view.axis = .vertical
        view.spacing = 2.0
        view.distribution = .fill
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()

        label.textAlignment = .left
        label.text = self.title
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()

        label.textAlignment = .left
        label.text = self.subTitle
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private lazy var infoDescriptionLabel: UILabel = {
        let label = UILabel()

        label.textAlignment = .left
        label.text = self.subTitle
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()

        label.textAlignment = .right
        label.text = self.subTitle
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private lazy var leftIconWrapperView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    private lazy var leftIconView: UIImageView  = {
        let view = UIImageView()

        view.translatesAutoresizingMaskIntoConstraints = false

        view.contentMode = .scaleAspectFit

        return view
    }()
    
    private lazy var rightIcon: UIImageView = {
        let view = UIImageView()
        
        view.image = UIImage.Images.icSMEChevronRight
        
        view.translatesAutoresizingMaskIntoConstraints = false

        view.contentMode = .scaleAspectFit

        return view
    }()
    
    private lazy var button: SMEUIButton = {
        let view = SMEUIButton(localizableTitle: "", styleOfButton: .plain)
        
        view.translatesAutoresizingMaskIntoConstraints = false

        view.contentMode = .scaleAspectFit

        view.addTarget(self, action: #selector(handleButtonClick), for: .touchUpInside)
        
//        view.addTarget(, action: Selector, for: .touchUpInside)
//        addClickListener {
//            self.onButtonPressed?()
//        }
        
        return view
    }()
    
    private lazy var radioButtonIcon: UIImageView = {
        let view = UIImageView()

        if self.radioButtonStatus {
            view.image = UIImage.Images.icRadioSelected
        } else {
            view.image = UIImage.Images.icRadioDefault
        }

        view.translatesAutoresizingMaskIntoConstraints = false

        view.contentMode = .scaleAspectFit

        return view
    }()
    
    private lazy var statusLabelView: SMELabelView = {
        let view = SMELabelView(statusOfLabel: .new, typeOfLabel: .small(localizedText: ""))
        
        view.translatesAutoresizingMaskIntoConstraints = false

        view.contentMode = .scaleAspectFit

        return view
    }()
    
    private lazy var switchButton: UISwitch = {
        let view = UISwitch()
        
        view.translatesAutoresizingMaskIntoConstraints = false

        view.contentMode = .scaleAspectFit

        return view
    }()

    /// Creates a new button of specified style.
    ///
    /// - Parameters:
    ///    - localizableTitle: Sets the title text for button.
    ///    - typeOfButton: Sets the type of button.
    ///
    
    public convenience init(typeOfAction: SMEActionType = .normal(icon: .none, localizedTitleText: "")) {
        self.init()
        
        UIFont.registerCustomFonts()
        
        self.typeOfAction = typeOfAction
        
        self.prepareActionViewByType()
        self.prepareActionViewByState()
        
        self.setupViews(for: typeOfAction)
    }
    
    public convenience init(typeOfAction: SMEActionType = .normal(icon: .none, localizedTitleText: ""),
                            styleOfAction: SMEActionStyle = .none) {
        self.init()
        
        self.typeOfAction = typeOfAction
        self.styleOfAction = styleOfAction
        self.prepareActionViewByType()
        self.prepareActionViewByState()
        
        self.setupViews(for: typeOfAction)
    }

    public convenience init(typeOfAction: SMEActionType = .normal(icon: .none, localizedTitleText: ""),
                            stateOfAction: SMEActionState = .normal) {
        self.init()
        
        self.typeOfAction = typeOfAction
        self.stateOfAction = stateOfAction
        self.prepareActionViewByType()
        self.prepareActionViewByState()
       
        self.setupViews(for: typeOfAction)
    }
    
    public convenience init(typeOfAction: SMEActionType = .normal(icon: .none, localizedTitleText: ""),
                            styleOfAction: SMEActionStyle = .none,
                            stateOfAction: SMEActionState = .normal) {
        self.init()
        
        self.typeOfAction = typeOfAction
        self.styleOfAction = styleOfAction
        self.stateOfAction = stateOfAction
        self.prepareActionViewByType()
        self.prepareActionViewByState()
       
        self.setupViews(for: typeOfAction)
    }
    
    private func setupViews(for type: SMEActionType) {
        
        self.baseView.addSubview(self.titleStackView)
        
        switch self.styleOfAction {
        case .chevron, .loading:
            self.baseView.addSubview(self.rightIcon)
        case .chevronWithButton:
            self.baseView.addSubview(self.rightIcon)
            self.baseView.addSubview(self.button)
        case .chevronWithStatus:
            self.baseView.addSubview(self.rightIcon)
            self.baseView.addSubview(self.statusLabelView)
        case .chevronWithText:
            self.baseView.addSubview(self.descriptionLabel)
            self.baseView.addSubview(self.rightIcon)
        case .radioButton:
            self.baseView.addSubview(self.radioButtonIcon)
        case .switchButton:
            self.baseView.addSubview(self.switchButton)
        case .none:
            break
        }
        
        self.cornerRadius = 12.0
        
        switch type {
        case .normal(let icon, _):
            self.setupViewsIcon(for: icon)
            self.titleStackView.addArrangedSubview(self.titleLabel)
        case .detailed(let icon, _,_):
            self.setupViewsIcon(for: icon)
            self.titleStackView.addArrangedSubview(self.titleLabel)
            self.titleStackView.addArrangedSubview(self.subTitleLabel)
        case .footerLabel(let icon, _,_,_):
            self.setupViewsIcon(for: icon)
            self.titleStackView.addArrangedSubview(self.titleLabel)
            self.titleStackView.addArrangedSubview(self.subTitleLabel)
            self.addSubview(self.infoDescriptionLabel)
        }

        self.setupConstraints(for: type)
    }
    
    private func setupViewsIcon(for icon: SMEIcon) {
        switch icon {
        case .hasIcon:
            self.leftIconWrapperView.addSubview(self.leftIconView)
            self.baseView.addSubview(self.leftIconWrapperView)
        default: break
        }
    }
    
    private func setupConstraints(for type: SMEActionType) {
        
        NSLayoutConstraint.activate([
            self.baseView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0),
            self.baseView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0.0),
            self.baseView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0.0),
            self.titleStackView.centerYAnchor.constraint(equalTo: self.baseView.centerYAnchor),
//            self.baseView.heightAnchor.constraint(equalTo: self.titleStackView.heightAnchor, constant: 32.0),
//            self.heightAnchor.constraint(equalTo: self.baseView.heightAnchor)
            self.titleLabel.widthAnchor.constraint(equalTo: self.titleStackView.widthAnchor),
            self.subTitleLabel.widthAnchor.constraint(equalTo: self.titleStackView.widthAnchor),
            self.titleStackView.heightAnchor.constraint(equalToConstant: 56),
            self.baseView.heightAnchor.constraint(equalToConstant: 72),
            self.heightAnchor.constraint(equalTo: self.baseView.heightAnchor)
        ])
        
//        self.titleLabel.preferredMaxLayoutWidth = self.titleStackView.frame.size.width
//        self.subTitleLabel.preferredMaxLayoutWidth = self.titleStackView.frame.size.width
        
        switch type {
        case .normal(let icon, _):
            self.setupConstraintsByIcon(icon: icon)
        case .detailed(let icon, _,_):
            self.setupConstraintsByIcon(icon: icon)
        case .footerLabel(let icon, _,_,_):
            self.setupConstraintsByIcon(icon: icon)
            NSLayoutConstraint.activate([
                self.heightAnchor.constraint(equalTo: self.baseView.heightAnchor, constant:  40),
                self.infoDescriptionLabel.topAnchor.constraint(equalTo: self.baseView.bottomAnchor, constant: 8.0),
                self.infoDescriptionLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16.0),
                self.infoDescriptionLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16.0),
            ])
        }
        
        self.setupConstraintsByStyle()
        
        self.smallSizeConstraints = [
            self.leftIconView.widthAnchor.constraint(equalToConstant: 24.0),
            self.leftIconView.heightAnchor.constraint(equalToConstant: 24.0),
            self.leftIconWrapperView.widthAnchor.constraint(equalToConstant: 24.0),
            self.leftIconWrapperView.heightAnchor.constraint(equalToConstant: 24.0)
        ]
        
        self.mediumSizeConstraints = [
            self.leftIconView.widthAnchor.constraint(equalToConstant: 32.0),
            self.leftIconView.heightAnchor.constraint(equalToConstant: 32.0),
            self.leftIconWrapperView.widthAnchor.constraint(equalToConstant: 32.0),
            self.leftIconWrapperView.heightAnchor.constraint(equalToConstant: 32.0)
        ]
        
        self.largeSizeConstraints = [
            self.leftIconView.widthAnchor.constraint(equalToConstant: 48.0),
            self.leftIconView.heightAnchor.constraint(equalToConstant: 48.0),
            self.leftIconWrapperView.widthAnchor.constraint(equalToConstant: 48.0),
            self.leftIconWrapperView.heightAnchor.constraint(equalToConstant: 48.0)
        ]
        
        self.iconSize = .large
    }
    
    private func setupConstraintsByIcon(icon: SMEIcon) {
        switch icon {
        case .none:
            NSLayoutConstraint.activate([
                self.baseView.heightAnchor.constraint(equalTo: self.titleStackView.heightAnchor, constant: 24),
                self.titleStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            ])
        case .hasIcon:
            NSLayoutConstraint.activate([
//                self.baseView.heightAnchor.constraint(equalToConstant: 72.0),
                self.leftIconView.centerXAnchor.constraint(equalTo: self.leftIconWrapperView.centerXAnchor),
                self.leftIconView.centerYAnchor.constraint(equalTo: self.leftIconWrapperView.centerYAnchor),
                self.leftIconWrapperView.heightAnchor.constraint(equalToConstant: 40.0),
                self.leftIconWrapperView.widthAnchor.constraint(equalToConstant: 40.0),
                
                self.leftIconWrapperView.topAnchor.constraint(equalTo: self.baseView.topAnchor, constant: 16.0),
                self.leftIconWrapperView.bottomAnchor.constraint(equalTo: self.baseView.bottomAnchor, constant: -16.0),
                self.leftIconWrapperView.leftAnchor.constraint(equalTo: self.baseView.leftAnchor, constant: 16.0),
                
                self.titleStackView.leftAnchor.constraint(equalTo: self.leftIconWrapperView.rightAnchor, constant: 12),
            ])
        }
    }
    
    private func setupConstraintsByStyle() {
        switch self.styleOfAction {
        case .chevron, .loading:
            NSLayoutConstraint.activate([
                self.titleStackView.rightAnchor.constraint(equalTo: self.rightIcon.leftAnchor, constant: -12),
                self.rightIcon.heightAnchor.constraint(equalToConstant: 24.0),
                self.rightIcon.widthAnchor.constraint(equalToConstant: 24.0),
                self.rightIcon.rightAnchor.constraint(equalTo: self.baseView.rightAnchor, constant: -12),
                self.rightIcon.centerYAnchor.constraint(equalTo: self.baseView.centerYAnchor),
            ])
        case .chevronWithButton:
            NSLayoutConstraint.activate([
                self.titleStackView.rightAnchor.constraint(equalTo: self.button.leftAnchor, constant: -12),
            
                self.rightIcon.heightAnchor.constraint(equalToConstant: 24.0),
                self.rightIcon.widthAnchor.constraint(equalToConstant: 24.0),
                self.rightIcon.rightAnchor.constraint(equalTo: self.baseView.rightAnchor, constant: -12),
                self.rightIcon.centerYAnchor.constraint(equalTo: self.baseView.centerYAnchor),
                
                self.button.widthAnchor.constraint(equalToConstant: 54.0),
                self.button.rightAnchor.constraint(equalTo: self.rightIcon.leftAnchor, constant: -12),
                self.button.centerYAnchor.constraint(equalTo: self.baseView.centerYAnchor),
                
            ])
        case .chevronWithStatus:
            NSLayoutConstraint.activate([
                self.titleStackView.rightAnchor.constraint(equalTo: self.statusLabelView.leftAnchor, constant: -12),
                
                self.rightIcon.heightAnchor.constraint(equalToConstant: 24.0),
                self.rightIcon.widthAnchor.constraint(equalToConstant: 24.0),
                self.rightIcon.rightAnchor.constraint(equalTo: self.baseView.rightAnchor, constant: -12),
                self.rightIcon.centerYAnchor.constraint(equalTo: self.baseView.centerYAnchor),
                
                self.statusLabelView.rightAnchor.constraint(equalTo: self.rightIcon.leftAnchor, constant: -12),
                self.statusLabelView.centerYAnchor.constraint(equalTo: self.baseView.centerYAnchor),
            ])
        case .chevronWithText:
            NSLayoutConstraint.activate([
                self.titleStackView.rightAnchor.constraint(equalTo: self.descriptionLabel.leftAnchor, constant: -12),
                
                self.rightIcon.heightAnchor.constraint(equalToConstant: 24.0),
                self.rightIcon.widthAnchor.constraint(equalToConstant: 24.0),
                self.rightIcon.rightAnchor.constraint(equalTo: self.baseView.rightAnchor, constant: -12),
                self.rightIcon.centerYAnchor.constraint(equalTo: self.baseView.centerYAnchor),
               
                self.descriptionLabel.widthAnchor.constraint(equalToConstant: 48.0),
                self.descriptionLabel.rightAnchor.constraint(equalTo: self.rightIcon.leftAnchor, constant: -12),
                self.descriptionLabel.centerYAnchor.constraint(equalTo: self.baseView.centerYAnchor),
            ])
        case .radioButton:
            NSLayoutConstraint.activate([
                self.titleStackView.rightAnchor.constraint(equalTo: self.radioButtonIcon.leftAnchor, constant: -12),
                self.radioButtonIcon.heightAnchor.constraint(equalToConstant: 24.0),
                self.radioButtonIcon.widthAnchor.constraint(equalToConstant: 24.0),
                self.radioButtonIcon.rightAnchor.constraint(equalTo: self.baseView.rightAnchor, constant: -16),
                self.radioButtonIcon.centerYAnchor.constraint(equalTo: self.baseView.centerYAnchor),
            ])
        case .switchButton:
            NSLayoutConstraint.activate([
                self.titleStackView.rightAnchor.constraint(equalTo: self.switchButton.leftAnchor, constant: -12),
                self.switchButton.heightAnchor.constraint(equalToConstant: 30.0),
                self.switchButton.widthAnchor.constraint(equalToConstant: 50.0),
                self.switchButton.rightAnchor.constraint(equalTo: self.baseView.rightAnchor, constant: -16),
                self.switchButton.centerYAnchor.constraint(equalTo: self.baseView.centerYAnchor),
            ])
        case .none:
            NSLayoutConstraint.activate([
                self.titleStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12),
            ])
        }
        
        self.prepareActionViewByStyle()
    }

    private func prepareActionViewByState() {
        switch self.stateOfAction {
        case .normal:
            self.borderColor = .clear
            self.baseBackgroundColor = .white
        case .disabled:
            self.baseBackgroundColor = .white
            self.titleLabel.textColor = UIColor.Colors.PBGray
            self.subTitleLabel.textColor = UIColor.Colors.SMEDisabledGray
            self.radioButtonIcon.image = UIImage.Images.icSMERadio
            
            self.leftIconView.image?.withTintColor(UIColor.Colors.PBGray)
            self.rightIcon.image?.withTintColor(UIColor.Colors.PBGray)
        case .selected:
            self.borderColor = self.theme.getPrimaryColor()
            self.baseBackgroundColor = self.theme.getPrimaryColor().withAlphaComponent(0.08)
        }
    }

    private func prepareActionViewByType() {
        switch self.typeOfAction {
        case .normal(let icon, let localizedTitleText):
            self.title = localizedTitleText
            self.titleLabel.font = UIFont.sfProText(ofSize: 17, weight: .medium) //TODO: Add as parameter
            self.prepareActionViewByIcon(icon: icon)
        case .detailed(let icon, let localizedTitleText, let localizedSubTitleText):
            self.title = localizedTitleText
            self.subTitle = localizedSubTitleText
            self.titleLabel.font = UIFont.sfProText(ofSize: 17, weight: .medium) //TODO: Add as parameter
            self.subTitleLabel.font = UIFont.sfProText(ofSize: 13, weight: .regular) //TODO: Add as parameter
            self.subTitleLabel.textColor = UIColor.Colors.SMEGray
            self.prepareActionViewByIcon(icon: icon)
        case .footerLabel(let icon, let localizedTitleText, let localizedSubTitleText, let localizedDescriptionText):
            self.title = localizedTitleText
            self.subTitle = localizedSubTitleText
            self.infoDescriptionText = localizedDescriptionText
            self.titleLabel.font = UIFont.sfProText(ofSize: 17, weight: .medium) //TODO: Add as parameter
            self.subTitleLabel.font = UIFont.sfProText(ofSize: 13, weight: .regular) //TODO: Add as parameter
            self.infoDescriptionLabel.font = UIFont.sfProText(ofSize: 12, weight: .regular) //TODO: Add as parameter
            
            self.subTitleLabel.textColor = UIColor.Colors.SMEGray // TODO: Color oposity should be 60%
            self.infoDescriptionLabel.textColor = UIColor.Colors.SMEGray // TODO: Color oposity should be 60%
            self.prepareActionViewByIcon(icon: icon)
        }
    }
    
    private func prepareActionViewByIcon(icon: SMEIcon) {
        switch icon {
        case .hasIcon(let icon):
            self.leftIcon = icon
        default: break
        }
    }
    
    private func prepareActionViewByStyle() {
        switch self.styleOfAction {
        case .chevron: break
        case .chevronWithButton(let localizedText):
            self.button.buttonTitle = localizedText
            self.button.titleLabel?.font = UIFont.sfProText(ofSize: 17, weight: .regular)
        case .chevronWithStatus(let localizedText, let status):
            self.statusLabelView.typeOfLabel = .small(localizedText: localizedText)
            self.statusLabelView.statusOfLabel = status
        case .chevronWithText(let localizedText):
            self.descriptionLabel.text = localizedText
            self.descriptionLabel.font = UIFont.sfProText(ofSize: 17, weight: .regular)
            self.descriptionLabel.textColor = UIColor.Colors.SMEGray
        case .radioButton(let isSelected):
            self.radioButtonStatus = isSelected
        case .switchButton(let isOn):
            self.switchButtonStatus = isOn
        case .none:
            break
        case .loading:
            self.rightIcon.image = UIImage.Images.icSMELoading
        }
    }
    
    @objc fileprivate func handleButtonClick(sender: UITapGestureRecognizer) {
        self.onButtonPressed?()
    }
    
    @objc fileprivate func handleViewClick(sender: UITapGestureRecognizer) {
        self.onViewPressed?()
    }
    
}
