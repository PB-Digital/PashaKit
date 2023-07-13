//
//  PBMaskableUITextField.swift
//
//
//  Created by Murad on 10.12.22.
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
import InputMask

/// PBMaskableUITextField inherits from `PBBaseUITextField` and adds input masking
/// feature to it.
///
/// By default its maskFormat is accepting any type of symbols user write. However if you need
/// more formatted and specific text output, don't forget to customize it.
///
class PBMaskableUITextField: PBBaseUITextField {

    private let inputMaskDelegate = MaskedTextFieldDelegate()


    /// Sets masking format for input text.
    ///
    /// If not specified custom maskFormat will be applied to accept all types of symbols to enter.
    ///
    /// Change this property based on your desires. Following input mask formats are widely used in our application:
    /// - [0000] [0000] [0000] [0000] - for card pan number input. It will limit your input to maximum 16 numbers which are
    /// grouped by 4 number resembling real card number appearance in text field.
    /// ---
    /// - +994 [00] [000] [000] - for number input. It will limit your input to maximum 8 characters. When you start typing predefined
    /// +994 will automatically be inserted into field. This country code is optional. For different country code, just change it with theirs.
    ///
    /// If you want to learn more about maskFormats, please check their GitHub [repository](https://github.com/RedMadRobot/input-mask-ios).
    ///
    var maskFormat: String = "" {
        didSet {
            if self.maskFormat.isEmpty {
                self.inputMaskDelegate.primaryMaskFormat = "[N…]"
            } else {
                self.inputMaskDelegate.primaryMaskFormat = self.maskFormat
            }
        }
    }

    /// Called when editing starts
    ///
    /// Use this callback to access user input and for tracking it real-time
    var onTextUpdate: ((String) -> Void)?

    override func setupViews() {
        self.inputMaskDelegate.delegate = self
        self.inputMaskDelegate.autocomplete = false
        self.inputMaskDelegate.customNotations = [
            Notation(
                character: "N",
                characterSet: CharacterSet.symbols
                    .subtracting(CharacterSetHelper.emojiCharacterSet)
                    .union(CharacterSet.whitespaces)
                    .union(CharacterSet.decimalDigits)
                    .union(CharacterSet.letters)
                    .union(CharacterSet.punctuationCharacters)
                    .union(CharacterSet.symbols),
                isOptional: false
            ),
        ]
        self.delegate = self.inputMaskDelegate
    }

    public func set(text: String) {
        self.inputMaskDelegate.put(text: text, into: self)
    }
}

extension PBMaskableUITextField: MaskedTextFieldDelegateListener {
    open func textField(
            _ textField: UITextField,
            didFillMandatoryCharacters complete: Bool,
            didExtractValue value: String
        )
    {
        let cleanText = value
            .replacingOccurrences(of: " ", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
            self.onTextUpdate?(cleanText)
    }
}
