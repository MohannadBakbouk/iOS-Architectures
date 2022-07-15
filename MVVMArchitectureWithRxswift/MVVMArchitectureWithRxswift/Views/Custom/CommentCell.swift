//
//  CommentCell.swift
//  MVVMArchitecture
//
//  Created by Mohannad on 12/06/21.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    
    var index : Int! //= 0
    
    var temp = [String](arrayLiteral: "Every language I've used has some sort of default textual representation for a collection of objects that it will spit out when you try to concatenate the Array with a string, or pass it to a print() function, etc. Does Apple's Swift language have a built-in way of easily turning an Array into a String, or do we always have to be explicit when stringifying an array?" , "Does Apple's Swift language have a built-in way of easily turning an Array into a String, or do we always have to be explicit when stringifying an array?" , "Every language I've used has some sort of default textual representation for a collection of objects that it will spit out when you try to concatenate the Array with a string, or pass it to a print() function, etc.")

    
    var  comment : CommentViewData! {
        
        didSet {
            
            index = Int.random(in: 0...2)
            messageLab.text = temp[index]   //comment.message
            nameLab.text = comment!.ownerName
            img.kf.setImage(with: URL(string: comment.picture)!)

            
        }
    }
    
    var messageLab : UILabel = {
        let lab = UILabel()
        lab.text = ""
        lab.numberOfLines = 10
        return lab
    }()
    
    var nameLab : UILabel = {
        let lab = UILabel()
        lab.text = "Mohannad bakbouk"
        lab.numberOfLines = 1
        return lab
    }()
    
    var img : UIImageView = {
      let img = UIImageView()
      img.backgroundColor = .gray
      img.contentMode = .scaleAspectFill
      img.clipsToBounds = true
      img.kf.indicatorType = .activity
      img.layer.cornerRadius = 25
      return img
    }()
    
    var container : UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 8
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    func setupViews(){
        
        contentView.addSubview(img)
        contentView.addSubview(container)
        container.addSubview(nameLab)
        container.addSubview(messageLab)

        img.anchor(top: contentView.topAnchor, paddingTop: 5, bottom: nil, paddingBottom: 0, left: contentView.leadingAnchor, paddingLeft: 10, right: nil, paddingRight: 0, width: 50, height: 50)

        container.anchor(top: contentView.topAnchor, paddingTop: 0, bottom: contentView.bottomAnchor, paddingBottom: -10, left: img.trailingAnchor, paddingLeft: 10, right: contentView.trailingAnchor, paddingRight: -10, width: 0, height: 0)


        nameLab.anchor(top: container.topAnchor, paddingTop: 10, bottom: nil, paddingBottom: 0, left: container.leadingAnchor, paddingLeft: 10, right: container.trailingAnchor, paddingRight: -10, width: 0, height: 0)

        messageLab.anchor(top: nameLab.bottomAnchor, paddingTop: 10, bottom: container.bottomAnchor, paddingBottom: -5, left: container.leadingAnchor, paddingLeft: 10, right: container.trailingAnchor, paddingRight: -10, width: 0, height: 0)
        

        
    }
    
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }
    
}
