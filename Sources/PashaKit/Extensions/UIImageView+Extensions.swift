//
//  UIImageView+Extensions.swift
//  
//
//  Created by Murad on 23.12.22.
//

import UIKit

extension UIImageView {
    func setImage(withName: String) {
        self.image = UIImage(named: withName, in: Bundle.module, compatibleWith: nil)
    }
}
