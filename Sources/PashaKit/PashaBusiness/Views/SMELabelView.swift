//
//  SMELabelView.swift
//
//
//  Created by Farid Valiyev on 31.07.23.
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
/// - Note: SMELabelView is optimized for looking as expected with minimum effort at the `height` of 72.0 pt.
///
/// However feel free to customize it.
///

public class SMELabelView: UIView {
    
    public enum SMELabelViewType {
        case plain(localizedText: String)
        case small(localizedText: String)
        case withIcon(localizedText: String, icon: UIImage)
    }
    
    public enum SMELabelViewStatus {
        case new
        case draft
        case error
        case waiting
        case inprogress
        case done
    }
    
    public var title: String = "" {
        didSet {
            self.titleLabel.text = title
        }
    }
    
    public var cornerRadius: CGFloat = 2.0 {
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
    
    public var borderColor: UIColor = .clear {
        didSet {
            self.layer.borderWidth = 1
            self.layer.borderColor = self.borderColor.cgColor
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
    
    /// Specifies style of the actionView.
    ///
    /// If not specified by outside, SMEActionView will be created with filled style.
    ///
    public var statusOfLabel: SMELabelViewStatus = .draft {
        didSet {
            self.prepareLabelViewByStatus()
        }
    }
    
    /// Specifies style of the actionView.
    ///
    /// If not specified by outside, SMELabelView will be created with filled style.
    ///
    public var typeOfLabel: SMELabelViewType = .plain(localizedText: "") {
        didSet {
            self.prepareLabelViewByType()
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()

        label.textAlignment = .center
        label.text = self.title
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private lazy var leftIconView: UIImageView  = {
        let view = UIImageView()

        view.translatesAutoresizingMaskIntoConstraints = false

        view.contentMode = .scaleAspectFit

        return view
    }()
    
    /// Creates a new button of specified style.
    ///
    /// - Parameters:
    ///    - localizableTitle: Sets the label text.
    ///    - statusOfLabel: Sets the type of Label.
    ///
    
    public convenience init(statusOfLabel: SMELabelViewStatus = .draft) {
        self.init()
        
        UIFont.registerCustomFonts()
        
        self.statusOfLabel = statusOfLabel
        
        self.prepareLabelViewByType()
        self.prepareLabelViewByStatus()
        
        self.setupViews(for: statusOfLabel)
        
    }
    
    public convenience init(statusOfLabel: SMELabelViewStatus = .draft, typeOfLabel: SMELabelViewType = .plain(localizedText: "")) {
        self.init()
        
        UIFont.registerCustomFonts()
        
        self.statusOfLabel = statusOfLabel
        self.typeOfLabel = typeOfLabel
        
        self.prepareLabelViewByType()
        self.prepareLabelViewByStatus()
        
        self.setupViews(for: statusOfLabel)
        
    }
    
    private func setupViews(for type: SMELabelViewStatus) {
        
        self.addSubview(self.titleLabel)
        
        switch self.typeOfLabel {
        case .withIcon:
            self.addSubview(self.leftIconView)
        default: break
        }
        
        self.setupConstraints(for: type)
    }
    
    private func setupConstraints(for type: SMELabelViewStatus) {
        
        switch self.typeOfLabel {
        case .plain:
            NSLayoutConstraint.activate([
                self.heightAnchor.constraint(equalToConstant: 32.0),
                self.widthAnchor.constraint(equalTo: self.titleLabel.widthAnchor, constant: 16),
                self.titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8.0),
                self.titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8.0),
                self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 2.0),
                self.titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2.0),
                
            ])
        case .small:
            NSLayoutConstraint.activate([
                self.widthAnchor.constraint(equalTo: self.titleLabel.widthAnchor, constant: 16),
                self.heightAnchor.constraint(equalToConstant: 20.0),
                self.titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8.0),
                self.titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8.0),
                self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 2.0),
                self.titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2.0),
               
            ])
        case .withIcon:
            NSLayoutConstraint.activate([
                self.widthAnchor.constraint(equalTo: self.titleLabel.widthAnchor, constant: 36),
                self.heightAnchor.constraint(equalToConstant: 24.0),
                self.leftIconView.heightAnchor.constraint(equalToConstant: 16.0),
                self.leftIconView.widthAnchor.constraint(equalToConstant: 16.0),
                self.leftIconView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8.0),
                self.leftIconView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                
                self.titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                self.titleLabel.leftAnchor.constraint(equalTo: self.leftIconView.rightAnchor, constant: 4.0),
                self.titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8.0),
                
            ])
        }
 
    }
    
    private func prepareLabelViewByType() {
        switch self.typeOfLabel {
        case .plain(let localizedText):
            self.title = localizedText
            self.titleLabel.font = UIFont.sfProText(ofSize: 12, weight: .regular)
            self.cornerRadius = 2
        case .small(let localizedText):
            self.title = localizedText
            self.titleLabel.font = UIFont.sfProText(ofSize: 12, weight: .regular)
            self.cornerRadius = 2
        case .withIcon(let localizedText, let icon):
            self.title = localizedText
            self.leftIcon = icon
            self.titleLabel.font = UIFont.sfProText(ofSize: 13, weight: .medium)
            self.cornerRadius = 4
        }
    }
    
    private func prepareLabelViewByStatus() {
        switch self.statusOfLabel {
        case .new:
            self.titleLabel.textColor = .white
            self.baseBackgroundColor = UIColor.Colors.SMERed
        case .waiting:
            self.titleLabel.textColor = UIColor.Colors.SMEYellow
            self.baseBackgroundColor = UIColor.Colors.SMEYellow.withAlphaComponent(0.08)
        case .inprogress:
            self.titleLabel.textColor = UIColor.Colors.SMEBlue
            self.baseBackgroundColor = UIColor.Colors.SMEBlue.withAlphaComponent(0.08)
        case .done:
            self.titleLabel.textColor = UIColor.Colors.SMEGreen
            self.baseBackgroundColor = UIColor.Colors.SMEGreen.withAlphaComponent(0.08)
        case .draft:
            self.titleLabel.textColor = .black
            self.baseBackgroundColor = UIColor.Colors.SMEBackgroundGray.withAlphaComponent(0.08)
        case .error:
            self.titleLabel.textColor = UIColor.Colors.SMERed
            self.baseBackgroundColor = UIColor.Colors.SMERed.withAlphaComponent(0.08)
            
        }
    }
}
