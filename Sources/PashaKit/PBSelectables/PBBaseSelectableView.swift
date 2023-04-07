//
//  PBBaseSelectableView.swift
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

/// `PBBaseSelectableView` is a subclass of `UIView` made for imitating view selection. It's base view of
/// `PBSelectableCardView` and `PBSelectableRowView` components in PashaKit.
///
/// Depending on its `isSelected` value, view will changed its border and background color to predefined theme
/// color which is specified by outside.
///
/// - Important: When working with selectableview and its subviews don't forget to add `tapGestureRecognizer`
/// and change its `isSelected` state inside selector function.
///
open class PBBaseSelectableView: UIView {

    /// Selection style for selectable views
    ///
    /// Enum comes with two case:
    /// - `highlighted`
    /// - `clear`
    ///
    /// If you choose `highlighted`, it will be created
    /// with border and when it gets selected the background
    /// will be replaced with pale color according to its theme
    public enum SelectionStyle {
        /// Default selection style for selectable row view. Use this case
        /// if you want to add border and color change to row view when
        /// it gets selected
        case highlighted

        /// Borderless style for selectable row view. Use this case
        /// if you want clear selection, which will only affect the indicator,
        /// in our case, checkbox icon
        case clear
    }

    /// Selection style for selectable views
    ///
    /// By default selection style of selectable row view will be `highlighted`
    ///
    public var selectionStyle: SelectionStyle = .highlighted {
        didSet {
            self.updateUI()
        }
    }

    /// Sets the theme for `PBBaseSelectableView`
    ///
    /// By default view will be created with rugular theme which will cause selected state colors
    /// to be PBGreen and its subcolors.
    ///
    public var theme: PBSelectableViewTheme = .regular {
        didSet {
            if self.theme != oldValue {
                self.setTheme()
            }
        }
    }

    /// A boolean value for defining whether view `isSelected`
    ///
    public var isSelected: Bool = false {
        didSet {
            if self.isSelected != oldValue {
                animateToSelectionState(isSelected: self.isSelected)
            }
        }
    }

    /// A boolean value for enabling and disabling selection
    ///
    /// If not specified the view selection animation will be turned off and state changes will
    /// occur immediately.
    ///
    public var isAnimationEnabled: Bool = false

    /// Color of border when view `isSelected`.
    ///
    /// If theme option is not specified, this property will be in PBGreen color.
    ///
    var selectedBorderColor: UIColor = UIColor.Colors.PBGreen {
        didSet {
            if self.selectedBorderColor != oldValue {
                self.updateUI()
            }
        }
    }

    /// Color of background when view `isSelected`.
    ///
    /// If theme option is not specified, this property will be in pale green color.
    /// However you can set any color you want to it.
    ///
    var selectedStateColor: UIColor = UIColor(red: 0.875, green: 0.933, blue: 0.922, alpha: 1) {
        didSet {
            if self.selectedStateColor != oldValue {
                self.updateUI()
            }
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()

        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        self.layer.masksToBounds = true
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews()

        self.translatesAutoresizingMaskIntoConstraints = false
    }

    /// Default initializer for `PBBaseSelectableView`
    ///
    /// This will create view with its default parameters.
    ///
    public convenience init() {
        self.init(frame: .zero)
        self.setupViews()

        self.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupViews() {
        self.setupDefaults()
        self.layer.borderColor = UIColor.Colors.PBGraySecondary.cgColor
        self.backgroundColor = UIColor.white
    }

    /// Updates UI of selectable view
    ///
    /// Call this method when you have made UI changes such as states, colors.
    ///
    func updateUI() {
        if self.isAnimationEnabled {
            self.performAnimation { [weak self] in
                guard let self = self else { return }
                self.updateStyle(for: self.selectionStyle)
            }
        } else {
            updateStyle(for: self.selectionStyle)
        }
    }

    private func updateStyle(for selectionStyle: SelectionStyle) {
        switch self.selectionStyle {
        case .highlighted:
            if self.isSelected {
                self.layer.borderWidth = 2.0
                self.layer.borderColor = self.selectedBorderColor.cgColor
                self.backgroundColor = self.selectedStateColor
            } else {
                self.layer.borderWidth = 1.0
                self.layer.borderColor = UIColor.Colors.PBGraySecondary.cgColor
                self.backgroundColor = UIColor.white
            }
        case .clear:
            self.layer.borderWidth = 0.0
            self.layer.borderColor = UIColor.clear.cgColor
            self.backgroundColor = UIColor.clear
        }
    }

    /// The theme for the view's selected state.
    ///
    /// `PBBaseSelectableView` is using theme parameter for defining its color palette for components. These include view's
    /// * Border color for `isSelected` state
    /// * Background color when the view state changes to `isSelected`
    ///
    func setTheme() {
        self.selectedBorderColor = self.theme.getPrimaryColor()
        self.selectedStateColor = self.theme.getSecondaryColor()
    }

    /// Changes view state to alert.
    ///
    /// When selecting this type of view is mandatory in your application, you can check if it's selected or not
    /// via `isSelected` property.
    ///
    /// If the answer should be `true` but is returned `false`, call this
    /// method to enable alert state.
    ///
    public func setAlertState() {
        self.layer.borderColor = UIColor.Colors.PBInvalidRed.cgColor
        self.layer.backgroundColor = UIColor.clear.cgColor
    }

    private func animateToSelectionState(isSelected: Bool) {
        self.updateUI()
    }

    private func setupDefaults() {
        self.layer.cornerRadius = 8.0
        self.layer.borderWidth = 1.0
    }
}

