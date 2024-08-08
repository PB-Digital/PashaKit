//
//  PBMorphingLabel.swift
//  
//
//  Created by Murad on 10.12.23.
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

import Foundation
import UIKit

class PBMorphingLabel: UIView {

    private(set) var state = PBTextInputState.empty

    var text: String? {
        get {
            self.titleLabel.text
        }

        set {
            self.titleLabel.text = newValue
            self.transformerLabelSmall.text = newValue
            self.transformerLabelBig.text = newValue
            self.titlePlaceholderLabel.text = newValue
        }
    }

    var textColor: UIColor? {
        get {
            self.titleLabel.textColor
        }

        set {
            self.titleLabel.textColor = newValue
            self.titlePlaceholderLabel.textColor = newValue

            self.transformerLabelSmall.textColor = newValue
            self.transformerLabelBig.textColor = newValue
        }
    }

    var placeholderFont: UIFont? {
        get {
            self.titlePlaceholderLabel.font
        }

        set {
            self.titlePlaceholderLabel.font = newValue
            self.transformerLabelBig.font = newValue
        }
    }

    private lazy var upwardTransformBlock = {
        self.transformerLabelSmall.transform = .identity
        self.transformerLabelBig.transform = UIView.transform(
            from: self.titlePlaceholderLabel.frame,
            to: self.titleLabel.frame
        )
    }

    private lazy var downwardTransformBlock = {
        self.transformerLabelBig.transform = .identity
        self.transformerLabelSmall.transform = UIView.transform(
            from: self.titleLabel.frame,
            to: self.titlePlaceholderLabel.frame
        )
    }

    private lazy var titleLabel = {
        let view = UILabel(font: UIFont.systemFont(ofSize: 12, weight: .regular))

        self.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false

        return view
    }()

    private lazy var transformerLabelSmall = {
        let view = UILabel(font: UIFont.systemFont(ofSize: 12, weight: .regular))

        self.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false

        return view
    }()

    private lazy var titlePlaceholderLabel = {
        let view = UILabel()

        self.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false

        return view
    }()

    private lazy var transformerLabelBig = {
        let view = UILabel()

        self.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false

        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    func setState(_ newState: PBTextInputState, animated: Bool) {
        #if DEBUG
        print("OLD STATE: \(self.state) NEW STATE: \(newState)")
        #endif

        guard newState != self.state else { return }

        let oldState = self.state
        self.state = newState

        let animated = animated && self.window != nil && self.frame != .zero

        switch (oldState, newState) {
        case (_, .empty):
            if animated {
                self.moveTitleDown(animated: true)
            } else {
                self.stateDidUpdate()
            }
        case (.empty, .placeholder):
            self.moveTitleUp(animated: animated)
        case (.empty, .text):
            if animated {
                self.moveTitleUp(animated: true)
            } else {
                self.stateDidUpdate()
            }
        default:
            self.stateDidUpdate()
        }
    }

    private func commonInit() {
        self.isUserInteractionEnabled = false

        self.setupConstraints()

        self.titleLabel.alpha = 0.0
        self.titlePlaceholderLabel.alpha = 1.0

        self.transformerLabelBig.alpha = 0.0
        self.transformerLabelSmall.alpha = 0.0
    }

    private func setupConstraints() {
        self.layoutMargins = .zero

        #if DEBUG
        self.titleLabel.backgroundColor = .orange
        self.titlePlaceholderLabel.backgroundColor = .green

        self.transformerLabelSmall.backgroundColor = .cyan
        self.transformerLabelBig.backgroundColor = .yellow
        #endif

        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            self.titleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            self.titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.trailingAnchor),

            self.titlePlaceholderLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            self.titlePlaceholderLabel.trailingAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.trailingAnchor),
            self.titlePlaceholderLabel.centerYAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.centerYAnchor),

            self.transformerLabelSmall.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            self.transformerLabelSmall.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            self.transformerLabelSmall.trailingAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.trailingAnchor),

            self.transformerLabelBig.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            self.transformerLabelBig.trailingAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.trailingAnchor),
            self.transformerLabelBig.centerYAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.centerYAnchor),
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if self.state == .empty {
            self.downwardTransformBlock()
        } else if self.state == .text {
            self.upwardTransformBlock()
        }
    }

    private func stateDidUpdate() {
        self.updateTitle()
    }

    private func updateTitle() {
        switch state {
        case .empty:
            self.titleLabel.alpha = 0.0
            self.titlePlaceholderLabel.alpha = 1.0

            self.downwardTransformBlock()
        case .text, .placeholder, .textInput:
            self.titleLabel.alpha = 1.0
            self.titlePlaceholderLabel.alpha = 0.0

            self.upwardTransformBlock()
        }
    }

    private func moveTitleDown(animated: Bool) {
        self.titleLabel.alpha = 0.0
        self.transformerLabelSmall.alpha = 1.0

        let animationBlock = {
            self.transformerLabelBig.alpha = 1.0
            self.transformerLabelSmall.alpha = 0.0

            self.downwardTransformBlock()
        }

        if animated {
            self.performAnimation(animation: animationBlock) { isComplete in
                self.titlePlaceholderLabel.alpha = 1.0
                self.transformerLabelBig.alpha = 0.0
            }
        } else {
            UIView.performWithoutAnimation {
                animationBlock()
                self.titlePlaceholderLabel.alpha = 1.0
                self.transformerLabelBig.alpha = 0.0
            }
        }
    }

    private func moveTitleUp(animated: Bool) {
        self.titlePlaceholderLabel.alpha = 0.0
        self.transformerLabelBig.alpha = 1.0

        let animationBlock = {
            self.transformerLabelBig.alpha = 0.0
            self.transformerLabelSmall.alpha = 1.0

            self.upwardTransformBlock()
        }

        if animated {
            self.performAnimation(animation: animationBlock) { isComplete in
                self.titleLabel.alpha = 1.0
                self.transformerLabelSmall.alpha = 0.0
            }
        } else {
            UIView.performWithoutAnimation {
                animationBlock()
                self.titleLabel.alpha = 1.0
                self.transformerLabelSmall.alpha = 0.0
            }
        }
    }
}
