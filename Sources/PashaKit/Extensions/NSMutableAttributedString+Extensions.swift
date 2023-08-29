//
//  NSMutableAttributedString+Extensions.swift
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

import UIKit

extension NSMutableAttributedString {
    func addStrikeThrough() {
        self.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: 1,
            range: NSMakeRange(0, self.length)
        )
    }

    func addUnderline() {
        self.addAttribute(
            NSAttributedString.Key.underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSMakeRange(0, self.length)
        )
    }

    func setColor(color: UIColor) {
        self.addAttribute(
            NSAttributedString.Key.foregroundColor,
            value: color,
            range: NSMakeRange(0, self.length)
        )
    }

    func setColor(color: UIColor, range: NSRange) {
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }

    func setFont(font: UIFont) {
        self.addAttribute(
            NSAttributedString.Key.font,
            value: font,
            range: NSMakeRange(0, self.length)
        )
    }

    func setFont(font: UIFont, range: NSRange) {
        self.addAttribute(NSAttributedString.Key.font, value: font, range: range)
    }

    func getRange(substring: String) -> NSRange? {
        let range = self.mutableString.range(of: substring)
        if range.location != NSNotFound {
            return range
        } else {
            return nil
        }
    }
}
