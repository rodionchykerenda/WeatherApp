//
//  Reusable.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 14.04.2021.
//

import UIKit

public protocol Reusable {
    static var reuseIdentifier: String { get }
    static var nibName: String { get }
}

public extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }

    static var nibName: String {
        return String(describing: self)
    }
}

extension UITableViewCell: Reusable {}
extension UICollectionViewCell: Reusable {}

public extension UITableView {
    final func register<T: UITableViewCell>(cellType: T.Type) {
        self.register(UINib(nibName: cellType.nibName, bundle: nil), forCellReuseIdentifier: cellType.reuseIdentifier)
    }

    final func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            // swiftlint:disable line_length
            fatalError("Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) matching type \(cellType.self). Check that the reuseIdentifier is set properly in your XIB/Storyboard and that you registered the cell beforehand")
            // swiftlint:enable line_length
        }
        return cell
    }
}

public extension UICollectionView {
    final func register<T: UICollectionViewCell>(cellType: T.Type) {
        self.register(UINib(nibName: cellType.nibName, bundle: nil), forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }

    final func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            // swiftlint:disable line_length
            fatalError("Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) matching type \(cellType.self). Check that the reuseIdentifier is set properly in your XIB/Storyboard and that you registered the cell beforehand")
            // swiftlint:enable line_length
        }
        return cell
    }
}
