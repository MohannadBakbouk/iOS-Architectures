//
//  IndicatorCell.swift
//  MVVMArchitecture
//
//  Created by Mohannad on 12/06/21.
//

import UIKit

class IndicatorCell: UICollectionViewCell {
    
    
    
    var inidicator : UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .large
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    
    
    func setup(){
        
        contentView.addSubview(inidicator)
        inidicator.center(centerX: contentView.centerXAnchor, centerY: contentView.centerYAnchor)
        inidicator.startAnimating()
    }
}
