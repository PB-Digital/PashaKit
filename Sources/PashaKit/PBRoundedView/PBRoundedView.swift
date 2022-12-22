//
//  PBRoundedView.swift
//  
//
//  Created by Murad on 07.12.22.
//

import UIKit

public class PBRoundedView: UIView {

    public enum Style {
        case roundedRect(cornerRadius: CGFloat)
        case circle
    }

    public var icon: UIImage? {
        didSet {
            self.updateUI()
        }
    }

    public var style: Style = .circle {
        didSet {
            self.updateUI()
        }
    }

    public var contentInsets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) {
        didSet {
            self.updateUI()
        }
    }

    private var activeConstraints = [NSLayoutConstraint]()

    private lazy var iconView: UIImageView = {
        let view = UIImageView()

        self.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false

        view.contentMode = .scaleAspectFit
        view.tintColor = .white

        return view
    }()

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public convenience init(icon: UIImage?, style: Style = .circle) {
        self.init(frame: .zero)

        self.style = style
        self.icon = icon
        self.iconView.image = icon
        self.backgroundColor = UIColor(red: 0.455, green: 0.455, blue: 0.502, alpha: 0.08)

        self.setupDefaults()
        self.setupConstraints()
    }

    public convenience init() {
        self.init(icon: nil)
    }

    public override func layoutSubviews() {
        switch self.style {
        case .roundedRect(let cornerRadius):
            self.layer.cornerRadius = cornerRadius
        case .circle:
            self.layer.cornerRadius = self.frame.width / 2.0
        }
    }

    private func updateUI() {
        self.iconView.image = self.icon
        self.updateConstraints(basedOn: self.contentInsets)
    }

    private func updateConstraints(basedOn contentInsets: UIEdgeInsets) {

        NSLayoutConstraint.deactivate(self.activeConstraints)

        self.activeConstraints = [
            self.iconView.topAnchor.constraint(equalTo: self.topAnchor, constant: contentInsets.top),
            self.iconView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: contentInsets.left),
            self.iconView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -contentInsets.right),
            self.iconView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -contentInsets.bottom)
        ]

        NSLayoutConstraint.activate(self.activeConstraints)
    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalTo: self.heightAnchor)
        ])

        self.activeConstraints =  [
            self.iconView.topAnchor.constraint(equalTo: self.topAnchor, constant: self.contentInsets.top),
            self.iconView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: self.contentInsets.left),
            self.iconView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -self.contentInsets.right),
            self.iconView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -self.contentInsets.bottom)
        ]

        NSLayoutConstraint.activate(self.activeConstraints)
    }

    private func setupDefaults() {
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor(red: 0.455, green: 0.455, blue: 0.502, alpha: 0.08)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
