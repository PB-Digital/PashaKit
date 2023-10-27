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
// have differnt types of themes. Premimum customers' main color is PBAlmondMain, which
// is similar to brown, bronze color tones.
//
// However retail customers' main color is  PBMeadowMain which is unique tone of green color.
//
// Following enums are dedicated to adapt components to application's theme
// 

public enum PBCardInputViewTheme {
    case regular, dark

    func getPrimaryColor() -> UIColor {
        switch self {
        case .regular:
            return Colors.PBGreenCardInput
        case .dark:
            return UIColor.black
        }
    }
    
    func getCursorColor() -> UIColor {
        switch self {
        case .regular:
            return UIColor(resource: .PBMeadow.main)
        case .dark:
            return UIColor(resource: .PBAlmond.main)
        }
    }
}

public enum PBUIButtonTheme {
    case regular, dark, gray

    func getPrimaryColor() -> UIColor {
        switch self {
        case .regular:
            return UIColor(resource: .PBMeadow.main)
        case .dark:
            return UIColor(resource: .PBAlmond.main)
        case .gray:
            return UIColor.black
        }
    }

    func getSecondaryColor() -> UIColor {
        switch self {
        case .regular:
            return UIColor(resource: .PBMeadow.bold)
        case .dark:
            return UIColor(resource: .PBAlmond.bold)
        case .gray:
            return .clear
        }
    }
}

public enum PBUITextFieldTheme {
    case regular, dark

    func getPrimaryColor() -> UIColor {
        switch self {
        case .regular:
            return UIColor(resource: .PBMeadow.main)
        case .dark:
            return UIColor(resource: .PBAlmond.main)
        }
    }
}

public enum PBSelectableViewTheme {
    case regular, dark

    func getPrimaryColor() -> UIColor {
        switch self {
        case .regular:
            return UIColor(resource: .PBMeadow.main)
        case .dark:
            return UIColor(resource: .PBAlmond.main)
        }
    }

    func getSecondaryColor() -> UIColor {
        switch self {
        case .regular:
            return UIColor(resource: .PBMeadow.light)
        case .dark:
            return UIColor(resource: .PBAlmond.light)
        }
    }
}

public enum SMEUIButtonTheme {
    case regular

    func getPrimaryColor() -> UIColor {
        switch self {
        case .regular:
            return UIColor.Colors.SMEGreen
        }
    }

    func getSecondaryColor() -> UIColor {
        switch self {
        case .regular:
            return UIColor.Colors.SMEGreen.lighter.withAlphaComponent(0.08)
        }
    }
}
