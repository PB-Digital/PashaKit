//
//  PBCardView.swift
//  
//
//  Created by Murad on 08.12.22.
//

import UIKit

public class PBCardView: UIView {

    var onFavoriteCallback: ((Bool) -> Void)?

    private lazy var cardImage: UIImageView = {
        let view = UIImageView()

        self.addSubview(view)
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "ic-card")

        return view
    }()

    private lazy var cardOverlayView: UIView = {
        let view = UIView()

        self.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)

        return view
    }()

    private lazy var overlayBlockView: UIView = {
        let view = UIView()

        self.cardOverlayView.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false

        return  view
    }()

    private lazy var overlayReplaceView: UIView = {
        let view = UIView()

        self.cardOverlayView.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var overlayReplaceImage: UIImageView = {
        let view = UIImageView()

        self.overlayReplaceView.addSubview(view)

        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "ic_card_blocked")
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var overlayBlockImage: UIImageView = {
        let view = UIImageView()

        self.overlayBlockView.addSubview(view)

        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "ic_card_blocked")
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var overlayBlockTitle: UILabel = {
        let label = UILabel()

        self.overlayBlockView.addSubview(label)
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Kart blokdadır"
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var overlayBlockBody: UILabel = {
        let label = UILabel()

        self.overlayBlockView.addSubview(label)
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Müştəri tərəfindən bloklanıb"
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var bankLogo: UIImageView = {
        let view = UIImageView()

        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        view.image = UIImage(named: "ic_logo_white")

        return view
    }()

    private lazy var cardBalanceTitle: UILabel = {
        let view = UILabel()

        self.addSubview(view)
        view.text = "2 569.80 ₼"
        view.font = UIFont.systemFont(ofSize: 34.0, weight: .bold)
        view.textColor = .white
        view.numberOfLines = 1
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var cardNumberTitle: UILabel = {
        let view = UILabel()

        self.addSubview(view)
        view.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        view.textColor = .white
        view.text = "•1907"
        view.numberOfLines = 1
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var heart: UIImageView = {
        let view = UIImageView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "ic_heart")
        view.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        view.widthAnchor.constraint(equalToConstant: 32.0).isActive = true

        return view
    }()

    private lazy var heartSelected: UIImageView = {
        let view = UIImageView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "ic_heart_selected")
        view.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        view.widthAnchor.constraint(equalToConstant: 32.0).isActive = true
        view.alpha = 0.0

        return view
    }()

    private lazy var favoriteButton: UIButton = {
        let button = UIButton()

        self.addSubview(button)

        button.addTarget(self, action: #selector(onFavorite), for: .touchUpInside)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 32.0).isActive = true
        button.heightAnchor.constraint(equalToConstant: 32.0).isActive = true

        button.addSubview(self.heart)
        self.heart.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        self.heart.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        button.addSubview(self.heartSelected)
        self.heartSelected.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        self.heartSelected.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true

        return button
    }()

    private lazy var issuerLogo: UIImageView = {
        let view = UIImageView()

        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "ic_master_logo_colored")

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

    public convenience init() {
        self.init(frame: .zero)
        self.setupViews()
    }

    private func setupViews() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .systemGreen
        self.layer.cornerRadius = 12.0
        self.layer.masksToBounds = true
        self.setupConstraints()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: self.frame.width * (472.0 / 750.0))
        ])
    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([
            self.cardImage.topAnchor.constraint(equalTo: self.topAnchor),
            self.cardImage.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.cardImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.cardImage.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])

        NSLayoutConstraint.activate([
            self.bankLogo.topAnchor.constraint(equalTo: self.topAnchor, constant: 20.0),
            self.bankLogo.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16.0)
        ])

        NSLayoutConstraint.activate([
            self.cardBalanceTitle.topAnchor.constraint(equalTo: self.bankLogo.bottomAnchor, constant: 8.0),
            self.cardBalanceTitle.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16.0),
            self.cardBalanceTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16.0)
        ])

        NSLayoutConstraint.activate([
            self.cardNumberTitle.topAnchor.constraint(equalTo: self.cardBalanceTitle.bottomAnchor, constant: 4.0),
            self.cardNumberTitle.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16.0),
            self.cardNumberTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16.0)
        ])

        NSLayoutConstraint.activate([
            self.favoriteButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16.0),
            self.favoriteButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16.0)
        ])

        NSLayoutConstraint.activate([
            self.issuerLogo.widthAnchor.constraint(equalToConstant: 74.0),
            self.issuerLogo.heightAnchor.constraint(equalToConstant: 42.0),
            self.issuerLogo.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16.0),
            self.issuerLogo.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16.0)
        ])
    }

    private func setupOverlayConstraints() {

        bringSubviewToFront(self.cardOverlayView)
        self.overlayBlockView.isHidden = false
        self.overlayReplaceView.isHidden = true

        NSLayoutConstraint.activate([
            self.cardOverlayView.topAnchor.constraint(equalTo: self.topAnchor),
            self.cardOverlayView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.cardOverlayView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.cardOverlayView.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])

        NSLayoutConstraint.activate([
            self.overlayBlockView.leftAnchor.constraint(equalTo: self.cardOverlayView.leftAnchor, constant: 32.0),
            self.overlayBlockView.rightAnchor.constraint(equalTo:self.cardOverlayView.rightAnchor, constant: -32.0),
            self.overlayBlockView.centerYAnchor.constraint(equalTo: self.cardOverlayView.centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            self.overlayReplaceView.leftAnchor.constraint(equalTo: self.cardOverlayView.leftAnchor, constant: 32.0),
            self.overlayReplaceView.rightAnchor.constraint(equalTo:self.cardOverlayView.rightAnchor, constant: -32.0),
            self.overlayReplaceView.centerYAnchor.constraint(equalTo: self.cardOverlayView.centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            self.overlayReplaceImage.widthAnchor.constraint(equalToConstant: 36.0),
            self.overlayReplaceImage.heightAnchor.constraint(equalToConstant: 36.0),
            self.overlayReplaceImage.centerYAnchor.constraint(equalTo: self.overlayReplaceView.centerYAnchor),
            self.overlayReplaceImage.centerXAnchor.constraint(equalTo: self.overlayReplaceView.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            self.overlayBlockImage.widthAnchor.constraint(equalToConstant: 36.0),
            self.overlayBlockImage.heightAnchor.constraint(equalToConstant: 36.0),
            self.overlayBlockImage.topAnchor.constraint(equalTo: self.overlayBlockView.topAnchor),
            self.overlayBlockImage.centerXAnchor.constraint(equalTo: self.overlayBlockView.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            self.overlayBlockTitle.topAnchor.constraint(equalTo: self.overlayBlockImage.bottomAnchor, constant: 8.0),
            self.overlayBlockTitle.leftAnchor.constraint(equalTo: self.overlayBlockView.leftAnchor),
            self.overlayBlockTitle.rightAnchor.constraint(equalTo: self.overlayBlockView.rightAnchor)
        ])

        NSLayoutConstraint.activate([
            self.overlayBlockBody.topAnchor.constraint(equalTo: self.overlayBlockTitle.bottomAnchor, constant: 2.0),
            self.overlayBlockBody.leftAnchor.constraint(equalTo: self.overlayBlockView.leftAnchor),
            self.overlayBlockBody.rightAnchor.constraint(equalTo: self.overlayBlockView.rightAnchor),
            self.overlayBlockBody.bottomAnchor.constraint(equalTo: self.overlayBlockView.bottomAnchor)
        ])
    }

    @objc func onFavorite(sender: UIButton) {
        UIView.animate(withDuration: 0.25, delay: 0) { [weak self] in
            self?.favoriteButton.isSelected = !self!.favoriteButton.isSelected
            self?.onFavoriteCallback?(self!.favoriteButton.isSelected)
            self?.heart.alpha = self?.heart.alpha == 0.0 ? 1.0 : 0.0
            self?.heartSelected.alpha = self?.heartSelected.alpha == 0.0 ? 1.0 : 0.0
        }
    }
}
