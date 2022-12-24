//
//  PBMaskableUITextField.swift
//
//
//  Created by Murad on 10.12.22.
//

import UIKit
import InputMask

class PBMaskableUITextField: PBBaseUITextField {

    private let inputMaskDelegate = MaskedTextFieldDelegate()

    var maskFormat: String = "" {
        didSet {
            if self.maskFormat.isEmpty {
                self.inputMaskDelegate.primaryMaskFormat = "[N…]"
            } else {
                self.inputMaskDelegate.primaryMaskFormat = self.maskFormat
            }
        }
    }

    var onTextUpdate: ((String) -> Void)?

    override func setupViews() {
        self.inputMaskDelegate.delegate = self
        self.inputMaskDelegate.autocomplete = false
        self.delegate = self.inputMaskDelegate
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
