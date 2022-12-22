//
//  PBBaseUITextField.swift
//  
//
//  Created by Murad on 10.12.22.
//

import UIKit

class PBBaseUITextField: UITextField {

    enum TextFieldType {
        case withRightImage
        case plain
    }

    fileprivate var contentInsets = UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0)

    fileprivate var editingConstraints: [NSLayoutConstraint] = []
    fileprivate var notEditingConstraints: [NSLayoutConstraint] = []
    fileprivate var activeConstraints: [NSLayoutConstraint] = []

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

    public func setKeyboardType(_ type: UIKeyboardType) {
        self.keyboardType = type
    }

    var isValid: Bool = true {
        didSet {
            self.updateUI()
        }
    }

    var isSecured: Bool = false {
        didSet {
            self.isSecureTextEntry = isSecured
        }
    }

    private var maxLength: Int = -1

    var hasBottomBorder: Bool = false {
        didSet {
            self.bottomBorder.isHidden = !self.hasBottomBorder
        }
    }

    var bottomBorderColor: UIColor = UIColor.Colors.PBGreen {
        didSet {
            self.performAnimation { [weak self] in
                guard let self = self else { return }
                self.bottomBorder.backgroundColor = self.bottomBorderColor
            }
        }
    }

    var bottomBorderThickness: CGFloat = 1.0 {
        didSet {
            self.layoutIfNeeded()
            NSLayoutConstraint.deactivate(self.activeConstraints)

            self.editingConstraints = [
                self.bottomBorder.heightAnchor.constraint(equalToConstant: self.bottomBorderThickness),
                self.bottomBorder.leftAnchor.constraint(equalTo: self.leftAnchor),
                self.bottomBorder.rightAnchor.constraint(equalTo: self.rightAnchor),
                self.bottomBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ]

            NSLayoutConstraint.activate(self.editingConstraints)
            self.activeConstraints = self.editingConstraints
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

        view.backgroundColor = UIColor.Colors.PBGreen
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

    func setupViews() {
        self.borderStyle = .none
        self.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        self.tintColor = UIColor.Colors.PBGreen
        self.translatesAutoresizingMaskIntoConstraints = false
        self.autocorrectionType = .no

        if !self.hasBottomBorder {
            self.bottomBorder.isHidden = !self.hasBottomBorder
        }

        setupConstraints()
    }

    private func setupConstraints() {
        self.addSubview(self.bottomBorder)

        self.notEditingConstraints = [
            self.bottomBorder.heightAnchor.constraint(equalToConstant: 1.0),
            self.bottomBorder.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.bottomBorder.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.bottomBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]

        NSLayoutConstraint.activate(self.notEditingConstraints)
        self.activeConstraints = self.notEditingConstraints
        self.setNeedsLayout()
    }

    private func updateUI() {
        self.textColor = self.isValid ? UIColor.white : UIColor.systemRed
        self.attributedPlaceholder = self.isValid ? NSAttributedString(string: self.placeholder ?? "", attributes: [.foregroundColor: UIColor.Colors.PBGraySecondary]) :
        NSAttributedString(string: self.placeholder ?? "", attributes: [.foregroundColor: UIColor.systemRed])
        self.bottomBorder.backgroundColor = self.isValid ? UIColor.Colors.PBGreen : .systemRed
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

