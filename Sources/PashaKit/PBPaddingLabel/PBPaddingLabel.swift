//
//  File.swift
//  
//
//  Created by Murad on 07.12.22.
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

///
/// `PBPaddingLabel` is a type of UILabel witth customizable insets from its frame
///
open class PBPaddingLabel: UILabel {
    var edgeInsets: UIEdgeInsets

    required public init(
        edgeInsets: UIEdgeInsets,
        cornerRadius: CGFloat = 6.0
    ) {
        self.edgeInsets = edgeInsets
        super.init(frame: CGRect.zero)
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: self.edgeInsets))
    }

    open override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize

            contentSize.height += self.edgeInsets.top + self.edgeInsets.bottom
            contentSize.width +=  self.edgeInsets.left + self.edgeInsets.right

            return contentSize
        }
    }
}
