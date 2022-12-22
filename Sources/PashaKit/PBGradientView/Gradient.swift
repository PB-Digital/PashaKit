//
//  File.swift
//  
//
//  Created by Murad on 06.12.22.
//

import UIKit

public protocol GradientBackgroundRepresentable {
    var colorPoints: [GradientColorPoint] { get }
    var angle: GradientAngle { get }
    var isReversed: Bool { get }
}

public struct GradientColorPoint{
    let color: UIColor
    let position: NSNumber

    public init(color: UIColor, position: NSNumber) {
        self.color = color
        self.position = position
    }
}

public enum GradientAngle {
    case horizontal, vertical, diagonal, diagonal_flipped_vertical
}
