//
//  File.swift
//  
//
//  Created by Murad on 12.12.22.
//

import UIKit

public class PBUIButton: UIButton {

    public enum PBUIButtonType {
        case custom
        case share
        case close
    }

    public enum PBUIButtonStyle {
        case plain
        case tinted
        case filled
        case outlined
    }

    private var seconds: Int = 0

    public var buttonTitle: String = "" {
        didSet {
            self.setTitle(self.buttonTitle, for: .normal)
        }
    }

    public var leftImage: UIImage? {
        didSet {
            self.setImage(self.leftImage, for: .normal)
        }
    }

    public var cornerRadius: CGFloat = 16.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }

    public var baseBackgroundColor: UIColor = UIColor.Colors.PBGreen {
        didSet {
            self.backgroundColor = self.baseBackgroundColor
        }
    }

    public var buttonTintColor: UIColor = UIColor.white {
        didSet {
            self.tintColor = self.buttonTintColor
            self.setTitleColor(self.buttonTintColor, for: .normal)
        }
    }

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
        self.setImage(UIImage(named: "ic-share"), for: .normal)
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
