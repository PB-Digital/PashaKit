//
//  ContactRepresentable.swift
//  
//
//  Created by Murad on 12.12.22.
//

import Foundation

public protocol PBContactRepresentable {
    var name: String { get set }
    var lastName: String { get set }
    var phoneNumber: String { get set }
}
