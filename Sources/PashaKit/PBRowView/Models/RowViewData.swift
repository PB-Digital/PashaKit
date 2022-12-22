//
//  RowViewData.swift
//  
//
//  Created by Murad on 07.12.22.
//

import UIKit

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
