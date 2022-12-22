//
//  File.swift
//  
//
//  Created by Murad on 06.12.22.
//

import UIKit

public protocol PBCardRepresentable {
    var balance: String { get }
    var displayName: String { get }
    var displayNameV2: String { get }
    var issuerLogoColored: UIImage? { get }
    var issuerLogoClear: UIImage? { get }
    var backgroundConfig: GradientBackgroundRepresentable { get }
}
