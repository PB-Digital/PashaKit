//
//  PBBaseRowView.swift
//  
//
//  Created by Murad on 16.07.23.
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

open class PBBaseRowView: UIView {
    public var mainContentSpacing: CGFloat = 16.0
    public var middleContentSpacing: CGFloat = 0.0

    public var leftViewSize: ViewSizes = .small {
        didSet {
            self.setNeedsDisplay()
        }
    }

    public var rightViewSize: ViewSizes = .small {
        didSet {
            self.setNeedsDisplay()
        }
    }

    private lazy var mainContentView: UIStackView = {
        let view: UIStackView = UIStackView()

        self.addSubview(view)

        view.axis = .horizontal
        view.alignment = .center
        view.spacing = self.mainContentSpacing
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var leftContentView: UIView = {
        let view = UIView()

        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var middleContentView: UIStackView = {
        let view = UIStackView()

        view.axis = .vertical
        view.spacing = self.middleContentSpacing
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var rightContentView: UIView = {
        let view = UIView()

        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    public convenience init() {
        self.init(frame: .zero)
        self.setupUI()
        self.setNeedsDisplay()
    }

    private func setupUI() {
        self.mainContentView.addArrangedSubview(self.leftContentView)
        self.mainContentView.addArrangedSubview(self.middleContentView)
        self.mainContentView.addArrangedSubview(self.rightContentView)
    }

    open override func setNeedsLayout() {
        self.updateUIElementsVisibility()
        super.setNeedsLayout()
    }

    private func updateUIElementsVisibility() {
        if !self.leftContentView.subviews.isEmpty {
            self.leftContentView.isHidden = false
        }

        if !self.rightContentView.subviews.isEmpty {
            self.rightContentView.isHidden = false
        }
    }

    open override func updateConstraints() {
        super.updateConstraints()

        NSLayoutConstraint.activate([
            self.mainContentView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            self.mainContentView.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor),
            self.mainContentView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor),
            self.mainContentView.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor)
        ])
    }

    public func addSubviewToLeftView(_ view: UIView) {
        self.leftContentView.addSubview(view)
        view.fillSuperview()
        self.setNeedsLayout()
    }

    public func addArrangedSubviewToMiddleView(_ view: UIView) {
        self.middleContentView.addArrangedSubview(view)
    }

    public func addSubviewToRightView(_ view: UIView) {
        self.rightContentView.addSubview(view)
        view.fillSuperview()
        self.setNeedsLayout()
    }
}
