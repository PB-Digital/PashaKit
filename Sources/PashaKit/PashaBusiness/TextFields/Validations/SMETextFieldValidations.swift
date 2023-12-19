//
//  SMETextFieldValidations.swift
//  
//
//  Created by Farid Valiyev on 03.08.23.
//

import Foundation

public class SMETextFieldValidations {
    static func validateEmail(for email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    static func validatePhone(for phone: String) -> Bool {
        let phoneRegEx = "(\\+994)+(10|50|51|55|70|77|99)+[0-9]{7}"
        let phonePred = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        return phonePred.evaluate(with: phone)
    }
    
    static func validateWithCustomRegex(for text: String, regex: String) -> Bool {
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: text)
    }
    
    static func validateCountRage(for text: String, minChar: Int, maxChar: Int) -> Bool {
        return text.count < minChar && text.count > maxChar
    }
    
    static func validateCardNumber(for pan: String) -> Bool {
        if pan.count != 16 {
            return false
        } else {
            return pan.isValidCardNumber()
        }
    }
}
