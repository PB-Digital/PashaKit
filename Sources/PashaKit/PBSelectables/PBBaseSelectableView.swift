//
//  PBBaseSelectableView.swift
//  
//
//  Created by Murad on 11.12.22.
//

import UIKit

open class PBBaseSelectableView: UIView {

    public var theme: PBSelectableViewTheme = .regular {
        didSet {
            self.setTheme()
        }
    }

    public var isSelected: Bool = false {
        didSet {
            animateToSelectionState(isSelected: self.isSelected)
        }
    }

    public var isAnimationEnabled: Bool = false

    var selectedBorderColor: UIColor = UIColor.Colors.PBGreen {
        didSet {
            self.updateUI()
        }
    }

    var selectedStateColor: UIColor = UIColor(red: 0.875, green: 0.933, blue: 0.922, alpha: 1) {
        didSet {
            self.updateUI()
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

