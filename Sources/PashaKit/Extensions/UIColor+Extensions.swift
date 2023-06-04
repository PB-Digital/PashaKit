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

public extension UIColor {
    convenience init(rgb: UInt32, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat((rgb >> 16) & 0xff) / 255.0, green: CGFloat((rgb >> 8) & 0xff) / 255.0, blue: CGFloat(rgb & 0xff) / 255.0, alpha: alpha)
    }

    convenience init(argb: UInt32) {
        self.init(red: CGFloat((argb >> 16) & 0xff) / 255.0, green: CGFloat((argb >> 8) & 0xff) / 255.0, blue: CGFloat(argb & 0xff) / 255.0, alpha: CGFloat((argb >> 24) & 0xff) / 255.0)
    }

    convenience init?(hexString: String) {
        let scanner = Scanner(string: hexString)

        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }

        var value: UInt32 = 0

        if scanner.scanHexInt32(&value) {
            if hexString.count > 7 {
                self.init(argb: value)
            } else {
                self.init(rgb: value)
            }
        } else {
            return nil
        }
    }
}

public extension UIColor {
    
    // MARK: MAIN COLORS

    struct PBAlmond {
        public static let main = #colorLiteral(red: 0.6, green: 0.3254901961, blue: 0.1882352941, alpha: 1)
        public static let text = #colorLiteral(red: 0.5099999905, green: 0.2630000114, blue: 0.1369999945, alpha: 1)
        public static let background = #colorLiteral(red: 0.6, green: 0.3254901961, blue: 0.1882352941, alpha: 0.1199999973)
    }

    struct PBMeadow {
        public static let main = #colorLiteral(red: 0.1098039216, green: 0.6784313725, blue: 0.5725490196, alpha: 1)
        public static let text = #colorLiteral(red: 0.06666666667, green: 0.6039215686, blue: 0.5058823529, alpha: 1)
        public static let background = #colorLiteral(red: 0.1098039216, green: 0.6784313725, blue: 0.5725490196, alpha: 0.1400000006)
    }

    struct PBGreen {
        public static let main = #colorLiteral(red: 0.1254901961, green: 0.6078431373, blue: 0.4039215686, alpha: 1)
        public static let text = #colorLiteral(red: 0, green: 0.4980392157, blue: 0.3098039216, alpha: 1)
        public static let background = #colorLiteral(red: 0.01176470588, green: 0.6784313725, blue: 0.4901960784, alpha: 0.07999999821)
    }

    struct PBRed {
        public static let main = #colorLiteral(red: 0.8666666667, green: 0.2588235294, blue: 0.2549019608, alpha: 1)
        public static let text = #colorLiteral(red: 0.8039215686, green: 0.09411764706, blue: 0.09019607843, alpha: 1)
        public static let background = #colorLiteral(red: 0.9254901961, green: 0.1803921569, blue: 0.1411764706, alpha: 0.1199999973)
    }

    struct PBYellow {
        public static let main = #colorLiteral(red: 0.7411764706, green: 0.5294117647, blue: 0.05490196078, alpha: 1)
        public static let text = #colorLiteral(red: 0.6431372549, green: 0.4431372549, blue: 0, alpha: 1)
        public static let background = #colorLiteral(red: 0.8431372549, green: 0.6078431373, blue: 0.07843137255, alpha: 0.1199999973)
    }

    struct PBBlue {
        public static let main = #colorLiteral(red: 0.2470588235, green: 0.3647058824, blue: 0.8941176471, alpha: 1)
        public static let text = #colorLiteral(red: 0.1450980392, green: 0.262745098, blue: 0.7921568627, alpha: 1)
        public static let background = #colorLiteral(red: 0.07450980392, green: 0.4705882353, blue: 0.9882352941, alpha: 0.1400000006)
    }

    struct PBPrimary {
        public static let black = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        public static let white = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }

    struct PBText {
        public static let primary = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        public static let seondary = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        public static let tertiary = #colorLiteral(red: 0.7019607843, green: 0.7019607843, blue: 0.7019607843, alpha: 1)
    }

    // MARK: NEUTRALS

    static let PBGray40 = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
    static let PBGray60 = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
    static let PBGray70 = UIColor(red: 0.702, green: 0.702, blue: 0.702, alpha: 1)
    static let PBGray80 = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    static let PBGray90 = UIColor(red: 0.902, green: 0.902, blue: 0.902, alpha: 1)
    static let PBGray94 = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1)
    static let PBGray97 = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)

    // MARK: BLACKS

    static let PBBlack40 = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6).cgColor
    static let PBBlack60 = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
    static let PBBlack70 = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
    static let PBBlack80 = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
    static let PBBlack90 = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
    static let PBBlack94 = UIColor(red: 0, green: 0, blue: 0, alpha: 0.06).cgColor
    static let PBBlack97 = UIColor(red: 0, green: 0, blue: 0, alpha: 0.03).cgColor

    struct Colors {
        static let PBBlackMedium = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
        static let PBGraySecondary = UIColor(red: 0.883, green: 0.883, blue: 0.883, alpha: 1)
        static let PBGrayTransparent = UIColor(red: 0.604, green: 0.608, blue: 0.612, alpha: 0.08)
        static let PBRed = UIColor(red: 0.804, green: 0.094, blue: 0.09, alpha: 1)
        static let PBRed8 = UIColor(red: 0.925, green: 0.18, blue: 0.141, alpha: 0.08)
        static let PBInvalidRed = UIColor(red: 0.906, green: 0.322, blue: 0.251, alpha: 1)
        static let PBStatusYellowFG = UIColor(red: 0.749, green: 0.522, blue: 0.008, alpha: 1)
        static let PBStatusYellowBG = UIColor(red: 0.988, green: 0.725, blue: 0.133, alpha: 0.16)
        static let PBStatusRedFG = UIColor(red: 0.804, green: 0.094, blue: 0.09, alpha: 1)
        static let PBStatusRedBG = UIColor(red: 0.925, green: 0.18, blue: 0.141, alpha: 0.08)
        static let PBInfoYellowFG = UIColor(red: 0.643, green: 0.443, blue: 0, alpha: 1)
        static let PBInfoYellowBG = UIColor(red: 0.842, green: 0.607, blue: 0.077, alpha: 0.12)
        static let PBGreenCardInput = UIColor(red: 0.043, green: 0.29, blue: 0.247, alpha: 1)
        static let PBGreenSecondary = UIColor(red: 0.011, green: 0.68, blue: 0.491, alpha: 0.08)
        static let PBGray = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6)
    }
}

extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return (red, green, blue, alpha)
    }
}

public extension UIColor {

    /// Method for getting the lighter version of given color.
    ///
    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage))
    }

    /// Method for getting the darker version of given color.
    /// 
    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage))
    }

    /// Returns the lighter or darker version of given `UIColor`.
    /// By default it will return the 30% **lighter** version of the color
    ///
    /// For getting **lighter** version just pass the percentage with **positive** value
    ///
    /// For getting **darker** version just pass the percentage with **negative** value
    ///
    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(
                red: min(red + percentage/100, 1.0),
                green: min(green + percentage/100, 1.0),
                blue: min(blue + percentage/100, 1.0),
                alpha: alpha
            )
        } else {
            return nil
        }
    }
}
