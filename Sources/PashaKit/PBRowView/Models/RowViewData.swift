//
//  RowViewData.swift
//  
//
//  Created by Murad on 07.12.22.
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

///
/// An entity used to store row view data
///
/// `RowViewData` has 3 properties for holding data
/// - `titleText`- holds title text literal
/// - `sutitleText`- holds subtitle text literal
/// - `isRightIconVisible` - sets whether right icon should be visible or not
///
public struct RowViewData {
    var titleText: String
    var subtitleText: String?
    var isRightIconVisible: Bool

    public init(titleText: String, subtitleText: String? = nil, isRightIconVisible: Bool) {
        self.titleText = titleText
        self.subtitleText = subtitleText
        self.isRightIconVisible = isRightIconVisible
    }
}
