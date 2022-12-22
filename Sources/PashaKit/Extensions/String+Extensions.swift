//
//  String+Extensions.swift
//  
//
//  Created by Murad on 12.12.22.
//

import Foundation

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
