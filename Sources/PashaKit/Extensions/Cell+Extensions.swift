//
//  File.swift
//  
//
//  Created by Murad on 13.09.24.
//

import UIKit

extension UITableView {
    public func register(_ type: UITableViewCell.Type) {
        self.register(type, forCellReuseIdentifier: type.identifier)
    }

    public func dequeueReusableCell<T: UITableViewCell>(withType type: T.Type) -> T? {
        return self.dequeueReusableCell(withIdentifier: type.identifier) as? T
    }

    public func dequeueReusableCell<T: UITableViewCell>(withType type: T.Type, for indexPath: IndexPath) -> T? {
        return self.dequeueReusableCell(withIdentifier: type.identifier, for: indexPath) as? T
    }
}

extension UICollectionView {
    public func register(_ type: UICollectionViewCell.Type) {
        self.register(type, forCellWithReuseIdentifier: type.identifier)
    }

    public func dequeueReusableCell<T: UICollectionViewCell>(withType type: T.Type, for indexPath: IndexPath) -> T? {
        return self.dequeueReusableCell(withReuseIdentifier: type.identifier, for: indexPath) as? T
    }
}

extension UITableViewCell {
    public static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell {
    public static var identifier: String {
        return String(describing: self)
    }
}
