//
//  PBAvatarView.swift
//  
//
//  Created by Murad on 15.07.23.
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

public enum AvatarTypes {
    case withImage(UIImage)
    case withText(String, UIFont)
    case withIcon(UIImage)
    case none
}

public class PBAvatarView: UIView {

    public var type: AvatarTypes = .none {
        didSet {
            self.updateUI(to: self.type)
        }
    }

    private var _size: ViewSizes = .small {
        didSet {
            self.updateSize(to: self._size)
        }
    }

    public var cornerStyle: Style = .circle {
        didSet {
            self.updateCornerStyle(to: self.cornerStyle)
        }
    }

    private var layoutCompletionBlock: (() -> Void)?

    private lazy var avatarLabel: UILabel = {
        let view: UILabel = UILabel()

        self.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .white
        view.numberOfLines = 1
        view.textAlignment = .center
        view.isHidden = true

        return view
    }()

    private lazy var avatarIcon: UIImageView = {
        let view: UIImageView = UIImageView()

        self.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        view.isHidden = true

        return view
    }()

    private lazy var avatarImage: UIImageView = {
        let view: UIImageView = UIImageView()

        self.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        view.isHidden = true

        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    public convenience init(type: AvatarTypes = .none, size: ViewSizes = .small) {
        self.init()
        self.commonInit()

        self.type = type
        self._size = size

        self.updateUI(to: type)
        self.updateSize(to: size)
        self.updateCornerStyle(to: .circle)
        self.setupConstraints()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutCompletionBlock?()
    }

    private func commonInit() {
        self.layer.masksToBounds = true
    }

    private func updateUI(to type: AvatarTypes) {
        self.hideAllUIElements()

        switch type {
        case .withImage(let image):
            self.showAvatarImage(with: image)
        case .withText(let text, let font):
            self.showAvatarLabel(with: text, font: font)
        case .withIcon(let icon):
            self.showAvatarIcon(with: icon)
        case .none:
            break
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.avatarLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.avatarLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.avatarLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            self.avatarIcon.widthAnchor.constraint(equalToConstant: 24.0),
            self.avatarIcon.heightAnchor.constraint(equalToConstant: 24.0),
            self.avatarIcon.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.avatarIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])

        self.avatarImage.fillSuperview()
    }

    private func updateSize(to newSize: ViewSizes) {
        NSLayoutConstraint.deactivate(self.constraints)

        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: newSize.size.width),
            self.heightAnchor.constraint(equalToConstant: newSize.size.height)
        ])
    }

    private func updateCornerStyle(to newStyle: Style) {
        self.layoutCompletionBlock = { [weak self] in
            guard let self else { return }

            switch newStyle {
            case .roundedRect(let cornerRadius):
                self.layer.cornerRadius = cornerRadius
            case .circle:
                self.layer.cornerRadius = self.frame.width / 2.0
            }
        }
    }

    private func hideAllUIElements() {
        self.avatarLabel.isHidden = true
        self.avatarIcon.isHidden = true
        self.avatarImage.isHidden = true
    }

    private func showAvatarImage(with image: UIImage) {
        avatarImage.image = image.scale()
        avatarImage.isHidden = false
    }

    private func showAvatarLabel(with text: String, font: UIFont) {
        avatarLabel.text = text
        avatarLabel.font = font
        avatarLabel.isHidden = false
    }

    private func showAvatarIcon(with icon: UIImage) {
        avatarIcon.image = icon.resizedImage(size: CGSize(width: 24.0, height: 24.0))
        avatarIcon.isHidden = false
    }
}
