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

open class PBBaseSelectableView: UIView {

    public var theme: PBSelectableViewTheme = .regular {
        didSet {
            if self.theme != oldValue {
                self.setTheme()
            }
        }
    }

    public var isSelected: Bool = false {
        didSet {
            if self.isSelected != oldValue {
                animateToSelectionState(isSelected: self.isSelected)
            }
        }
    }

    public var isAnimationEnabled: Bool = false

    var selectedBorderColor: UIColor = UIColor.Colors.PBGreen {
        didSet {
            if self.selectedBorderColor != oldValue {
                self.updateUI()
            }
        }
    }

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
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews()

        self.translatesAutoresizingMaskIntoConstraints = false
    }

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

    func updateUI() {
        if self.isAnimationEnabled {
            self.performAnimation { [weak self] in
                guard let self = self else { return }

                if self.isSelected {
                    self.layer.borderWidth = 2.0
                    self.layer.borderColor = self.selectedBorderColor.cgColor
                    self.backgroundColor = self.selectedStateColor
                } else {
                    self.layer.borderWidth = 1.0
                    self.layer.borderColor = UIColor.Colors.PBGraySecondary.cgColor
                    self.backgroundColor = UIColor.white
                }
            }
        } else {
            if self.isSelected {
                self.layer.borderWidth = 2.0
                self.layer.borderColor = self.selectedBorderColor.cgColor
                self.backgroundColor = self.selectedStateColor
            } else {
                self.layer.borderWidth = 1.0
                self.layer.borderColor = UIColor.Colors.PBGraySecondary.cgColor
                self.backgroundColor = UIColor.white
            }
        }
    }

    func setTheme() {
        self.selectedBorderColor = self.theme.getPrimaryColor()
        self.selectedStateColor = self.theme.getSecondaryColor()
    }

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

