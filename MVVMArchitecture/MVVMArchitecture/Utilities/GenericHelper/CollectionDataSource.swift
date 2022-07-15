//
//  CollectionDataSource.swift
//  MVVMArchitecture
//
//  Created by Mohannad on 15.02.2021.
//

import Foundation
import UIKit

class CollectionDataSource<T> : NSObject ,  UICollectionViewDataSource{
 
    typealias CellConfigurator = (T , UICollectionViewCell , Int) -> Void
    
    var data  : [T]!
    
    private let reuseIdentifier: String
    
    private let cellConfigurator : CellConfigurator
    
    
    init(items : [T] ,
        reuseIdentifier: String,
        cellConfigurator: @escaping CellConfigurator) {
        self.data = items
        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfigurator
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
            let item = data[indexPath.row]
    
            self.cellConfigurator(item , cell , indexPath.row)
    
            return cell

        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let value = data.remove(at: sourceIndexPath.item)
        data.insert(value, at: destinationIndexPath.item)
    }
    

    
}
