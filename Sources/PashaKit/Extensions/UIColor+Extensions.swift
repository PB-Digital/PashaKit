//
//  UIColor+Extensions.swift
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

extension UIColor {
    struct Colors {
        static let PBGreen = UIColor(red: 0.11, green: 0.678, blue: 0.573, alpha: 1)
        static let PBGreenCardInput = UIColor(red: 0.043, green: 0.29, blue: 0.247, alpha: 1)
        static let PBGreenSecondary = UIColor(red: 0.011, green: 0.68, blue: 0.491, alpha: 0.08)
        static let PBGray = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6)

        // MARK: NEUTRALS
        static let PBGray40 = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        static let PBGray60 = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        static let PBGray70 = UIColor(red: 0.702, green: 0.702, blue: 0.702, alpha: 1)
        static let PBGray80 = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        static let PBGray90 = UIColor(red: 0.902, green: 0.902, blue: 0.902, alpha: 1)
        static let PBGray94 = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1)
        static let PBGray97 = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)

        static let PBBlackMedium = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
        static let PBGraySecondary = UIColor(red: 0.883, green: 0.883, blue: 0.883, alpha: 1)
        static let PBGrayTransparent = UIColor(red: 0.604, green: 0.608, blue: 0.612, alpha: 0.08)
        static let PBFauxChestnut = UIColor(red: 0.6, green: 0.325, blue: 0.188, alpha: 1)
        static let PBRed = UIColor(red: 0.804, green: 0.094, blue: 0.09, alpha: 1)
        static let PBRed8 = UIColor(red: 0.925, green: 0.18, blue: 0.141, alpha: 0.08)
        static let PBInvalidRed = UIColor(red: 0.906, green: 0.322, blue: 0.251, alpha: 1)
        static let PBStatusYellowFG = UIColor(red: 0.749, green: 0.522, blue: 0.008, alpha: 1)
        static let PBStatusYellowBG = UIColor(red: 0.988, green: 0.725, blue: 0.133, alpha: 0.16)
        static let PBStatusRedFG = UIColor(red: 0.804, green: 0.094, blue: 0.09, alpha: 1)
        static let PBStatusRedBG = UIColor(red: 0.925, green: 0.18, blue: 0.141, alpha: 0.08)
        static let PBInfoYellowFG = UIColor(red: 0.643, green: 0.443, blue: 0, alpha: 1)
        static let PBInfoYellowBG = UIColor(red: 0.842, green: 0.607, blue: 0.077, alpha: 0.12)
        
        // MARK: Pasha Business
        
        static var SMEGreen: UIColor {
            return UIColor { (traits) -> UIColor in
                return traits.userInterfaceStyle == .dark ?
                UIColor(red: 0.298, green: 0.745, blue: 0.620, alpha: 1) :
                UIColor(red: 0.020, green: 0.553, blue: 0.400, alpha: 1)
            }
        }
        
        static var SMEGray: UIColor {
            return UIColor { (traits) -> UIColor in
                return traits.userInterfaceStyle == .dark ?
                UIColor(red: 0.922, green: 0.922, blue: 0.961, alpha: 0.3) :
                UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.3)
            }
        }
        
        static var SMEBackgroundGray: UIColor {
            return UIColor { (traits) -> UIColor in
                return traits.userInterfaceStyle == .dark ?
                UIColor(red: 0.463, green: 0.463, blue: 0.502, alpha: 0.24) :
                UIColor(red: 0.463, green: 0.463, blue: 0.502, alpha: 0.12)
            }
        }
        
        static var SMERed: UIColor {
            return UIColor { (traits) -> UIColor in
                // TODO: Add dark color
                return traits.userInterfaceStyle == .dark ?
                UIColor(red: 0.886, green: 0.263, blue: 0.325, alpha: 1) :
                UIColor(red: 0.886, green: 0.263, blue: 0.325, alpha: 1)
            }
        }
        
        static var SMEYellow: UIColor {
            return UIColor { (traits) -> UIColor in
                // TODO: Add dark color
                return traits.userInterfaceStyle == .dark ?
                UIColor(red: 0.925, green: 0.643, blue: 0, alpha: 1) :
                UIColor(red: 0.925, green: 0.643, blue: 0, alpha: 1)
            }
        }
        
        static var SMEBlue: UIColor {
            return UIColor { (traits) -> UIColor in
                // TODO: Add dark color
                return traits.userInterfaceStyle == .dark ?
                UIColor(red: 0, green: 0.565, blue: 0.757, alpha: 1) :
                UIColor(red: 0, green: 0.565, blue: 0.757, alpha: 1)
            }
        }
        
        static var SMEInfoGrayBackground: UIColor {
            return UIColor { (traits) -> UIColor in
                return traits.userInterfaceStyle == .dark ?
                UIColor(red: 0.110, green: 0.110, blue: 0.118, alpha: 1) :
                UIColor(red: 0.949, green: 0.949, blue: 0.969, alpha: 1)
            }
        }
        
        static var SMEInfoBlueBackground: UIColor {
            return UIColor { (traits) -> UIColor in
                return traits.userInterfaceStyle == .dark ?
                UIColor(red: 0.180, green: 0.643, blue: 0.800, alpha: 0.08) :
                UIColor(red: 0.0, green: 0.565, blue: 0.757, alpha: 0.08)
            }
        }
        
        static var SMEInfoYellowBackground: UIColor {
            return UIColor { (traits) -> UIColor in
                return traits.userInterfaceStyle == .dark ?
                UIColor(red: 0.945, green: 0.737, blue: 0.271, alpha: 0.08) :
                UIColor(red: 0.925, green: 0.643, blue: 0.0, alpha: 0.08)
            }
        }
        
        static var SMEInfoRedBackground: UIColor {
            return UIColor { (traits) -> UIColor in
                return traits.userInterfaceStyle == .dark ?
                UIColor(red: 0.918, green: 0.357, blue: 0.416, alpha: 0.08) :
                UIColor(red: 0.886, green: 0.263, blue: 0.325, alpha: 0.08)
            }
        }
        
        static var SMEInfoGreenBackground: UIColor {
            return UIColor { (traits) -> UIColor in
                return traits.userInterfaceStyle == .dark ?
                UIColor(red: 0.298, green: 0.745, blue: 0.620, alpha: 0.08) :
                UIColor(red: 0.020, green: 0.553, blue: 0.400, alpha: 0.08)
            }
        }
        
        static var SMEInfoTitle: UIColor {
            return UIColor { (traits) -> UIColor in
                return traits.userInterfaceStyle == .dark ?
                UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1) :
                UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1)
            }
        }
        
        static var SMEInfoDescription: UIColor {
            return UIColor { (traits) -> UIColor in
                return traits.userInterfaceStyle == .dark ?
                UIColor(red: 0.922, green: 0.922, blue: 0.961, alpha: 0.6) :
                UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6)
            }
        }
        
        static var SMETextFieldLabel: UIColor {
            return UIColor { (traits) -> UIColor in
                return traits.userInterfaceStyle == .dark ?
                UIColor(red: 0.502, green: 0.502, blue: 0.514, alpha: 1) :
                UIColor(red: 0.596, green: 0.596, blue: 0.624, alpha: 1)
            }
        }
    }
}
