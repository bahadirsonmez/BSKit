#if canImport(UIKit)
//
//  ListProtocols.swift
//  BSUIKit
//
//  Created by Bahadir Sonmez on 22.12.2025.
//

import UIKit

// MARK: - Configurable Cell Protocol

public protocol ConfigurableCell: UIView {
    associatedtype Model
    
    static var reuseIdentifier: String { get }
    func configure(with model: Model)
}

// MARK: - Default Implementations

public extension ConfigurableCell {
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
}

// MARK: - List Data Source Protocol

public protocol ListDataSourceProtocol {
    associatedtype Item
    
    var items: [Item] { get }
}

// MARK: - Reusable Protocol

public protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

public extension Reusable {
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
}

// MARK: - UITableView Extensions

public extension UITableView {
    
    func register<T: UITableViewCell>(_ cellType: T.Type) where T: Reusable {
        register(cellType, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: Reusable {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}

// MARK: - UICollectionView Extensions

public extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_ cellType: T.Type) where T: Reusable {
        register(cellType, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T where T: Reusable {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}
#endif
