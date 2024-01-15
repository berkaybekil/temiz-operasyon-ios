//
//  Generics+Cellreuse.swift
//  ilk6yil
//
//  Created by Furkan Bekil on 16.11.2020.
//  Copyright © 2020 Furkan Bekil. All rights reserved.
//

import UIKit

extension UICollectionView {
    /// Returns a reuseable cell object located by its identifier and casted to the appropriate type.
    ///
    /// - parameters:
    ///   - cellType:  The appropriate cell type
    ///   - indexPath: The index path specifying the location of the cell.
    ///                The data source receives this information when it is asked for the cell and should just pass it along.
    ///                This method uses the index path to perform additional configuration based on the cell’s position in the collection view.
    /// - returns: An object of the appropriate cell type
    func dequeueReusableCell<C>(_ cellType: C.Type, for indexPath: IndexPath) -> C where C: UICollectionViewCell {
        let identifier = String(describing: cellType)
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? C else {
            fatalError("Failed to find cell with identifier \"\(identifier)\" of type \"\(C.self)\"")
        }
        return cell
    }
}

extension UITableView {
    /// Returns a reuseable cell object located by its identifier and casted to the appropriate type.
    ///
    /// - parameters:
    ///   - cellType:  The appropriate cell type
    ///   - indexPath: The index path specifying the location of the cell.
    ///                The data source receives this information when it is asked for the cell and should just pass it along.
    ///                This method uses the index path to perform additional configuration based on the cell’s position in the collection view.
    /// - returns: An object of the appropriate cell type
    func dequeueReusableCell<C>(_ cellType: C.Type, for indexPath: IndexPath) -> C where C: UITableViewCell {
        let identifier = String(describing: cellType)
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? C else {
            fatalError("Failed to find cell with identifier \"\(identifier)\" of type \"\(C.self)\"")
        }
        return cell
    }
}
