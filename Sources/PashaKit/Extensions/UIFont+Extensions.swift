//
//  UIFont+Extensions.swift
//  
//
//  Created by Farid Valiyev on 23.07.23.
//

import Foundation
import UIKit

public enum CustomFontWeight: String, CaseIterable {
    case light = "Light"
    case regular = "Regular"
    case medium = "Medium"
    case semibold = "Semibold"
    case bold = "Bold"
}

public enum CustomFonts: String, CaseIterable {
    case sfProDisplay = "SFProDisplay"
    case sfProText = "SFProText"
}

public extension UIFont {
    
    static func sfProDisplay(ofSize: CGFloat, weight: CustomFontWeight) -> UIFont {
        guard let customFont = UIFont(name: "\(CustomFonts.sfProDisplay.rawValue)-\(weight.rawValue)", size: ofSize) else {
            return UIFont.systemFont(ofSize: ofSize)
        }
        return customFont
    }
    
    static func sfProText(ofSize: CGFloat, weight: CustomFontWeight) -> UIFont {
        guard let customFont = UIFont(name: "\(CustomFonts.sfProText.rawValue)-\(weight.rawValue)", size: ofSize) else {
            return UIFont.systemFont(ofSize: ofSize)
        }
        return customFont
    }
    
    static func registerCustomFonts() {
        CustomFonts.allCases.forEach { font in
            CustomFontWeight.allCases.forEach {
                self.registerFont(bundle: .module, fontName: font.rawValue + $0.rawValue, fontExtension: "otf")
            }
        }
    }
    
    static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) {
        
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension),
              let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
              let font = CGFont(fontDataProvider) else {
            fatalError("Couldn't create font from data")
        }
        
        var error: Unmanaged<CFError>?
        
        CTFontManagerRegisterGraphicsFont(font, &error)
    }
    
}
