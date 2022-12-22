//
//  TransactionRepresentable.swift
//  
//
//  Created by Murad on 06.12.22.
//

import UIKit

public protocol TransactionRepresentable {
    var merchantName: String { get }
    var descriptionText: String { get }
    var amountText: String? { get }
    var amountTextColor: UIColor { get }
    var dateText: String { get }
}
