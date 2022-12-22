//
//  File.swift
//  
//
//  Created by Murad on 13.12.22.
//

import Foundation

class CharacterSetHelper {
    static let emojiCharacterSet: CharacterSet = {
        var emoji = CharacterSet()

        for codePoint in 0x0000...0x1F0000 {
            guard let scalarValue = Unicode.Scalar(codePoint) else {
                continue
            }

            if scalarValue.properties.isEmoji {
                emoji.insert(scalarValue)
            }
        }

        return emoji
    }()
}
