//
//  File.swift
//  
//
//  Created by Murad on 18.12.22.
//

import UIKit

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

    public override func setData(transaction: TransactionRepresentable, categoryName: String?) {
        super.setData(transaction: transaction, categoryName: categoryName)
        self.merchantLabel.text = transaction.descriptionText
        self.descriptionLabel.text = categoryName ?? transaction.merchantName
    }
}

