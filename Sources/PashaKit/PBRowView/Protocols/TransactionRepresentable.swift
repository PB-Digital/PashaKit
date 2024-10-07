//
//  TransactionRepresentable.swift
//  
//
//  Created by Murad on 06.12.22.
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
/// The requirements for dispalying transaction data.
///
/// This protocol was used by `PBTransactionRowView` for setting its data to proper sublabels.
///
/// When you are working with `PBTransactionRowView`  you will need creating an extension to your existing
/// entity for holding transaction information.
///
/// If your project doesn't include such kind of entity, create one and
/// conform it to `TransactionRepresentable`.
///
public protocol TransactionRepresentable: Equatable {
    var merchantName: String { get }
    var descriptionText: String { get }
    var amountText: String? { get }
    var amountTextColor: UIColor { get }
    var dateText: String { get }
    var transactionStatus: TransactionRepresentableStatus { get }
}

public enum TransactionRepresentableStatus {
    case complete
    case inProgress(info: String)
    case unsuccessful(info: String)
}
