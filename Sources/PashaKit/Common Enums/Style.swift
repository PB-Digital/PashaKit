//
//  Style.swift
//  
//
//  Created by Murad on 22.12.22.
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

/// Style for view
///
/// This enum right now is used by `PBRoundedView` for configuring its shape.
/// However since it's public, you can use it anywhere you want to customize your view.
///
public enum Style {
    ///
    /// Used for making rounded corners. Implementation depends on you
    ///
    case roundedRect(cornerRadius: CGFloat)

    /// Used for making view circle. Implementation depends on you
    case circle
}

/// Style for divider.
///
/// Divider is a thin line under tableview cells , row views. This enum is used by
/// `PBRowView`, `PBTransactionRowView`
///
public enum DividerStyle {

    /// Used for drawing divider partiallly
    ///
    case partial

    /// Used for drawing divider fully
    /// 
    case full
}
