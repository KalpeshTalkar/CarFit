//
//  TableCollectionUtils.swift
//
//  Created by Kalpesh Talkar.
//  Copyright © 2020 Kalpesh Talkar. All rights reserved.
//

import UIKit

// MARK: - Reuse Identifier

/// Protocol thet provides identfier for reusing UICollectionViewCells and UITableViewCells
public protocol ReuseIdentifying {
    
    /// Reuse identifier
    static var reuseIdentifier: String { get }
    
}

/// Extension for ReuseIdentifying
public extension ReuseIdentifying {
    
    /// Reuse identifier implementation. This will return a string of the class name.
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
}

// MARK: - Reuse Identifier Implementation

/// UICollectionViewCell extension conforming to ReuseIdentifying
extension UICollectionViewCell: ReuseIdentifying {}

/// UITableViewCell extension conforming to ReuseIdentifying
extension UITableViewCell: ReuseIdentifying {}

/// UIViewController extension conforming to ReuseIdentifying
extension UIViewController: ReuseIdentifying {}


// MARK: - UITableViewCell extension
extension UITableView {
    
    // MARK: - Reusable Cell
    
    
    /// Register cell from nib. Make sure the nib name is same as the class name.
    /// - Parameter cell: Custom UITableVIewCell class.
    public func register<T: UITableViewCell>(cell: T.Type) {
        register(UINib(nibName: cell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    
    /// Returns a reusable cell object located by its identifier.
    ///
    /// - Parameters:
    ///   - indexPath: The index path specifying the location of the cell.
    ///   - type: The class of your custom table view cell.
    /// - Returns: A valid UITableViewCell object.
    public func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath, ofType type: T.Type) -> T? {
        return dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T
    }
    
    /// Returns a reusable cell object located by its identifier.
    ///
    /// - Parameters:
    ///   - type: The class of your custom table view cell.
    /// - Returns: A valid UITableViewCell object.
    public func dequeueReusableCell<T: UITableViewCell>(ofType type: T.Type) -> T? {
        return dequeueReusableCell(withIdentifier: T.reuseIdentifier) as? T
    }
    
    // MARK: - Empty States
    
    /// Check if the table view has data.
    ///
    /// - Returns: true if has data else false.
    func hasData() -> Bool {
        let sections = numberOfSections
        for i in 0..<sections {
            let itemsInSec = numberOfRows(inSection: i)
            if itemsInSec > 0 {
                return true
            }
        }
        return false
    }

}

// MARK: - UITableViewCell extension
extension UICollectionView {
    
    // MARK: - Reusable Cell
    
    
    /// Register cell from nib. The method uses cellReuseIdentifier to register the cell from nib.
    ///  Make sure the nib name and class name are same.
    /// - Parameter cell: The class of your UICollectionViewCell.
    public func register<T: UICollectionViewCell>(cell: T.Type) {
        register(UINib.init(nibName: T.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    
    /// Returns a reusable cell object located by its identifier.
    ///
    /// - Parameters:
    ///   - indexPath: The index path specifying the location of the cell.
    ///   - type: The class of your custom collection view cell.
    /// - Returns: A valid UICollectionReusableView object.
    public func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath, ofType type: T.Type) -> T? {
        return dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T
    }
    
    
    // MARK: - Empty States
    
    
    /// Check if the collection view has data.
    ///
    /// - Returns: true if has data else false.
    func hasData() -> Bool {
        let sections = numberOfSections
        for i in 0..<sections {
            let itemsInSec = numberOfItems(inSection: i)
            if itemsInSec > 0 {
                return true
            }
        }
        return false
    }
    
}


// MARK: - Scroll view extension
extension UIScrollView {
    
    /// Scroll to the top.
    ///
    /// - Parameter animated: Animates if true. Default value is false.
    func scrollToTop(animated: Bool = false) {
        setContentOffset(.zero, animated: animated)
    }
    
    /// Scroll to the bottom.
    ///
    /// - Parameter animated: Animates if true. Default value is false.
    func scrollToBottom(animated: Bool = false) {
        setContentOffset(CGPoint(x: 0, y: contentSize.height), animated: animated)
    }
    
    /// Scroll to the left.
    ///
    /// - Parameter animated: Animates if true. Default value is false.
    func scrollToLeft(animated: Bool = false) {
        setContentOffset(.zero, animated: animated)
    }
    
    /// Scroll to the right.
    ///
    /// - Parameter animated: Animates if true. Default value is false.
    func scrollToRight(animated: Bool = false) {
        setContentOffset(CGPoint(x: contentSize.width, y: 0), animated: animated)
    }
    
}
