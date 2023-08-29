//
//  PBCaptureSafeView.swift
//  
//
//  Created by Murad on 22.08.23.
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

struct HiddenContainerRecognizer {
    static func getHiddenContainer(from view: UIView) -> UIView? {
        let containerName = getHiddenContainerTypeInStringRepresentation()
        let containers = view.subviews.filter { subview in
            type(of: subview).description() == containerName
        }

        return containers.first
    }

    private static func getHiddenContainerTypeInStringRepresentation() -> String {
        if #available(iOS 15, *) {
            return "_UITextLayoutCanvasView"
        }

        if #available(iOS 14, *) {
            return "_UITextFieldCanvasView"
        }

        if #available(iOS 13, *) {
            return "_UITextFieldCanvasView"
        }
    }
}

public class PBCaptureSafeView: UIView {

    private lazy var textField: UITextField = {
        let view = UITextField()

        view.isSecureTextEntry = true
        view.isUserInteractionEnabled = false
        view.backgroundColor = .clear

        return view
    }()

    private lazy var container: UIView? = {
        let view = HiddenContainerRecognizer.getHiddenContainer(from: self.textField)

        view?.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    public override var isUserInteractionEnabled: Bool {
        didSet {
            self.container?.isUserInteractionEnabled = isUserInteractionEnabled
        }
    }

    public init(contentView: UIView) {
        super.init(frame: .zero)
        self.setupUI(with: contentView)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupUI(with contentView: UIView) {
        guard let container else { return }

        self.addSubview(container)
        container.fillSuperview()

        container.addSubview(contentView)
        contentView.fillSuperview()
    }
}
