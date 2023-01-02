//
//  File.swift
//  
//
//  Created by Murad on 13.12.22.
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

//
// This file is dedicated to themes and more Pasha-Bank oriented.
//
// In our mobile application types of users are divided into two categories:
// - private
// - retail
//
// Each type of users have different accessibilities to PashaBank's services. On the UI side they
// have differnt types of themes. Premimum customers' main color is PBFauxChestnut, which
// is similar to brown, bronze color tones.
//
// However retail customers' main color is  PBGreen which is unique tone of green color.
//
// Following enums are dedicated to adapt components to application's theme
// 

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
