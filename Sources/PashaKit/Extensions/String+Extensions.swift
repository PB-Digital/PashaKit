//
//  String+Extensions.swift
//  
//
//  Created by Murad on 12.12.22.
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

extension String {
    var lastFourDigits: String {
        guard self.count == 16 else {
            return self
        }
        var formattedCardNumber = "• "
        formattedCardNumber += self.subString(from: 12, to: 15)
        return formattedCardNumber
    }
}

extension String {
    func subString(from: Int, to: Int) -> String {
       let startIndex = self.index(self.startIndex, offsetBy: from)
       let endIndex = self.index(self.startIndex, offsetBy: to)
       return String(self[startIndex...endIndex])
    }
}

public extension String {
    func parseHTML(fontSize: CGFloat) -> NSMutableAttributedString? {
        let modifiedString =
"""
<style>
   body {
     font-size: \(fontSize);
     font-family: -apple-system;
   }
   b {
     font-weight: 600;
   }
</style>
\(self)
"""
        guard let data = modifiedString.data(using: .utf8) else { return nil }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [.documentType: NSAttributedString.DocumentType.html,
                                                                           .characterEncoding: String.Encoding.utf8.rawValue,]
        do {
            let attributedString = try NSMutableAttributedString(data: data, options: options, documentAttributes: nil)
            return attributedString
        } catch {
            return nil
        }
    }
}
