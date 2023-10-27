//
//  PBBaseUITextField.swift
//  
//
//  Created by Murad on 10.12.22.
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

/// `PBBaseUITextField` is the lowest level of text field component of PashaKit library.
///
/// It differs from its parent- `UITextField` with having an option to choose text field type and bottom border.
/// By default it will be created with plain style which is very similar to `UITextField` instance.
///
class PBBaseUITextField: UITextField {

    /// Type of text field
    ///
    enum TextFieldType {
        /// By choosing this case helps you make an area for right icon which will be setted by the class subclassing it.
        /// At the moment the size of area is defined beforehand with 24 pt of width and 24 pt of height.
        ///
        case withRightImage
        /// By choosing this case text field will be in its default style defined by `UITextField`.
        ///
        case plain
    }

    fileprivate var contentInsets = UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0)

    fileprivate var editingConstraints: [NSLayoutConstraint] = []
    fileprivate var notEditingConstraints: [NSLayoutConstraint] = []
    fileprivate var activeConstraints: [NSLayoutConstraint] = []

    /// Sets the type of text field.
    ///
    var textFieldType: TextFieldType = .plain {
        didSet {
            switch self.textFieldType {
            case .withRightImage:
                self.contentInsets = UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 30)
                self.setNeedsDisplay()
            case .plain:
                self.contentInsets = UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0)
                self.setNeedsDisplay()
            }
        }
    }

    /// A Boolean value that determines whether the text is valid.
    ///
    /// Setting the value of this property to `false` it will change its text, placeholder and bottom border(if `hasBottomBorder` is true) color to `systemRed`
    ///
    /// The default value is `true`.
    ///
    var isValid: Bool = true {
        didSet {
            self.updateUI()
        }
    }

    /// A Boolean value that determines whether the text is secured.
    ///
    /// Setting this property to true in any view that conforms to `UITextInputTraits` disables the user’s ability
    /// to copy the text in the view and, in some cases, also disables the user’s ability to record and
    /// broadcast the text in the view.
    ///
    /// The default value is `false`.
    ///
    var isSecured: Bool = false {
        didSet {
            self.isSecureTextEntry = isSecured
        }
    }

    private var maxLength: Int = -1

    /// A boolean value that defines wheter the field should have bottom border or not.
    ///
    /// If you want to textfield have bottom border set this property to `true`
    ///
    var hasBottomBorder: Bool = false {
        didSet {
            self.bottomBorder.isHidden = !self.hasBottomBorder
        }
    }

    /// Sets the color for bottom border.
    ///
    /// By default if you enable `hasBottomBorder` the added border will have `PBGreen` color.
    /// Use this property to change it.
    ///
    var bottomBorderColor: UIColor = UIColor(resource: .PBMeadow.main) {
        didSet {
            self.performAnimation { [weak self] in
                guard let self = self else { return }
                self.bottomBorder.backgroundColor = self.bottomBorderColor
            }
        }
    }

    /// Defines the thickness for the bottom border.
    ///
    /// By default bottom border will be created with the thickness of 1.0 pt. Change this property
    /// for customizing thickness.
    ///
    var bottomBorderThickness: CGFloat = 1.0 {
        didSet {
            self.updateBottomBorderConstraints()
        }
    }

    var hasFocus: Bool = false {
        didSet {
            self.updateUI()
        }
    }

    // MARK: - UI COMPONENTS

    private lazy var bottomBorder: UIView = {
        let view = UIView()

        view.backgroundColor = UIColor(resource: .PBMeadow.main)
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews()
    }

    /// Sets up field based on default settings.
    ///
    /// Since this function initializes text field based on default parameters, don't forget to customize it
    /// if you desire different text field style.
    /// 
    func setupViews() {
        self.borderStyle = .none
        self.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        self.tintColor = UIColor(resource: .PBMeadow.main)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.autocorrectionType = .no

        if !self.hasBottomBorder {
            self.bottomBorder.isHidden = !self.hasBottomBorder
        }

        setupConstraints()
    }

    private func setupConstraints() {
        self.addSubview(self.bottomBorder)

        NSLayoutConstraint.activate([
            self.bottomBorder.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.bottomBorder.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.bottomBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        self.notEditingConstraints = [
            self.bottomBorder.heightAnchor.constraint(equalToConstant: 1.0)
        ]

        NSLayoutConstraint.activate(self.notEditingConstraints)
        self.activeConstraints = self.notEditingConstraints
        self.setNeedsLayout()
    }

    private func updateUI() {
        self.textColor = self.isValid ? UIColor.white : UIColor.systemRed
        self.attributedPlaceholder = self.isValid ? NSAttributedString(string: self.placeholder ?? "", attributes: [.foregroundColor: Colors.PBGraySecondary]) :
        NSAttributedString(string: self.placeholder ?? "", attributes: [.foregroundColor: UIColor.systemRed])
        self.bottomBorder.backgroundColor = self.isValid ? UIColor(resource: .PBMeadow.main) : .systemRed
    }

    private func updateBottomBorderConstraints() {
        NSLayoutConstraint.deactivate(self.activeConstraints)

        self.editingConstraints = [
            self.bottomBorder.heightAnchor.constraint(equalToConstant: self.bottomBorderThickness)
        ]

        NSLayoutConstraint.activate(self.editingConstraints)
        self.activeConstraints = self.editingConstraints
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.contentInsets)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.contentInsets)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.contentInsets)
    }
}

