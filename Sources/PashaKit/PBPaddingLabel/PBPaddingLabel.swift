//
//  File.swift
//  
//
//  Created by Murad on 07.12.22.
//

import UIKit

open class PBPaddingLabel: UILabel {
    var topInset: CGFloat
    var leftInset: CGFloat
    var bottomInset: CGFloat
    var rightInset: CGFloat

    required public init(topInset top: CGFloat, leftInset left: CGFloat, bottomInset bottom: CGFloat, rightInset right: CGFloat) {

        self.topInset = top
        self.leftInset = left
        self.bottomInset = bottom
        self.rightInset = right

        super.init(frame: CGRect.zero)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    open override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize

            contentSize.height += topInset + bottomInset
            contentSize.width +=  leftInset + rightInset

            return contentSize
        }
    }
}
