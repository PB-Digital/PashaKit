//
//  File.swift
//  
//
//  Created by Murad on 18.12.22.
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
/// `PBPaymentHistoryRowView` is subview of `PBTransactionRowView` with
/// changes to merchant and amount label's font.
///
public class PBPaymentHistoryRowView: PBTransactionRowView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }

    override func setupViews() {
        super.setupViews()
        self.merchantLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        self.amountLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
    }

    required init?(coder aCoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Sets data for a row view.
    ///
    /// - Parameters:
    ///    - transaction: Protocol for representing `transactionRowView`.
    ///    - categoryName: Name of transaction category.
    ///
    public override func setData(transaction: any TransactionRepresentable, categoryName: String?) {
        super.setData(transaction: transaction, categoryName: categoryName)
        self.merchantLabel.text = transaction.descriptionText
        self.descriptionLabel.text = categoryName ?? transaction.merchantName
    }
}

