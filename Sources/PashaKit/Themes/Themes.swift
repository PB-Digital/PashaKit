//
//  File.swift
//  
//
//  Created by Murad on 13.12.22.
//

import UIKit

public enum PBCardInputViewTheme {
    case regular, dark

    func getPrimaryColor() -> UIColor {
        switch self {
        case .regular:
            return UIColor.Colors.PBGreenCardInput
        case .dark:
            return UIColor.black
        }
    }
}

public enum PBUIButtonTheme {
    case regular, dark, gray

    func getPrimaryColor() -> UIColor {
        switch self {
        case .regular:
            return UIColor.Colors.PBGreen
        case .dark:
            return UIColor.Colors.PBFauxChestnut
        case .gray:
            return UIColor.black
        }
    }

    func getSecondaryColor() -> UIColor {
        switch self {
        case .regular:
            return UIColor.Colors.PBGreenSecondary
        case .dark:
            return UIColor.Colors.PBFauxChestnut.withAlphaComponent(0.08)
        case .gray:
            return UIColor.Colors.PBGrayTransparent
        }
    }
}

public enum PBUITextFieldTheme {
    case regular, dark

    func getPrimaryColor() -> UIColor {
        switch self {
        case .regular:
            return UIColor.Colors.PBGreen
        case .dark:
            return UIColor.Colors.PBFauxChestnut
        }
    }
}

public enum PBSelectableViewTheme {
    case regular, dark

    func getPrimaryColor() -> UIColor {
        switch self {
        case .regular:
            return UIColor.Colors.PBGreen
        case .dark:
            return UIColor.Colors.PBFauxChestnut
        }
    }

    func getSecondaryColor() -> UIColor {
        switch self {
        case .regular:
            return UIColor.Colors.PBGreenSecondary
        case .dark:
            return UIColor.Colors.PBFauxChestnut.withAlphaComponent(0.08)
        }
    }
}
