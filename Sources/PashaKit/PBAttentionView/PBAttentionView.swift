//
//  PBAttentionView.swift
//  
//
//  Created by Murad on 20.12.22.
//

import UIKit

open class PBAttentionView: UIView {

    public enum AttentionLevel {
        case low
        case high
    }

    public var attentionLevel: AttentionLevel = .low {
        didSet {
            switch self.attentionLevel {
            case .low:
                self.backgroundColor = UIColor.Colors.PBGrayTransparent
                self.infoBody.textColor = UIColor.Colors.PBBlackMedium
                self.infoIcon.image = UIImage(named: "ic_info", in: Bundle.module, compatibleWith: nil)
            case .high:
                self.backgroundColor = UIColor.Colors.PBRed8
                self.infoBody.textColor = UIColor.Colors.PBRed
                self.infoIcon.image = UIImage(named: "ic_info_red", in: Bundle.module, compatibleWith: nil)
            }
        }
    }

    private lazy var infoIcon: UIImageView = {
        let view = UIImageView()

        self.addSubview(view)

        view.image = UIImage(named: "ic_info")
        view.contentMode = .scaleAspectFit

        view.translatesAutoresizingMaskIntoConstraints = false

        view.widthAnchor.constraint(equalToConstant: 24.0).isActive = true
        view.heightAnchor.constraint(equalToConstant: 24.0).isActive = true

        return view
    }()

    private lazy var infoBody: UILabel = {
        let label = UILabel()

        self.addSubview(label)

        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor.Colors.PBBlackMedium
        label.numberOfLines = 0

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    required public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupViews() {
        self.backgroundColor = UIColor.Colors.PBGrayTransparent
        self.layer.cornerRadius = 12.0

        self.setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.infoIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: 16.0),
            self.infoIcon.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16.0)
        ])

        NSLayoutConstraint.activate([
            self.infoBody.topAnchor.constraint(equalTo: self.infoIcon.topAnchor),
            self.infoBody.leftAnchor.constraint(equalTo: self.infoIcon.rightAnchor, constant: 8.0),
            self.infoBody.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16.0),
            self.infoBody.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16.0)
        ])
    }

    public func set(text: String, attentionLevel: AttentionLevel = .low) {
        self.infoBody.text = text
        self.attentionLevel = attentionLevel
    }
}
