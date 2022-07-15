//
//  CollectionViewDelegate.swift
//  MVVMArchitecture
//
//  Created by Mohannad on 16.02.2021.
//

import UIKit

protocol CollectionDelegate: class {
    func selectedCell(row: Int)
    func willDisplay(row: Int)
}

extension CollectionDelegate {
    func selectedCell(row: Int)  {
        
    }
    
    func willDisplay(row: Int)  {
        
    }
    
    
    
    
}


class CollectionViewDelegate: NSObject , UICollectionViewDelegate {
    
    weak var delegate: CollectionDelegate?
    
    init(withDelegate delegate: CollectionDelegate) {
        self.delegate = delegate
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {  
        self.delegate?.selectedCell(row: indexPath.row)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.delegate?.willDisplay(row: indexPath.row)
    }
}
