//
//  PostCell.swift
//  MVVMArchitecture
//
//  Created by Mohannad on 12/06/21.
//

import UIKit
import Kingfisher

class PostCell: UICollectionViewCell {
    
    
    var post : PostViewData!  {
        
        didSet {
            renderPostInfo()
        }
    }
    
    
    var titleLab : UILabel = {
        let lab = UILabel()
        lab.text = "Post's Title "
        lab.numberOfLines = 2
        return lab
    }()
    
    var authorLab : UILabel = {
        let lab = UILabel()
        lab.text = "Mohannad Bakbouk"
        lab.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return lab
    }()
    
    var likeLab : UILabel = {
        let lab = UILabel()
        lab.text = "566"
        lab.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return lab
    }()
    
    var img : UIImageView = {
      let img = UIImageView()
      img.backgroundColor = .gray
      img.contentMode = .scaleAspectFill
      img.clipsToBounds = true
      img.kf.indicatorType = .activity
      return img
    }()
    
    var likeIcon : UIImageView = {
      let img = UIImageView()
      img.image = UIImage(systemName: "hand.thumbsup.fill")!
      img.tintColor = .darkGray
      img.contentMode = .scaleAspectFit
      return img
    }()
    
    var authIcon : UIImageView = {
      let img = UIImageView()
      img.image = UIImage(systemName: "person.fill")!
      img.tintColor = .darkGray
      img.contentMode = .scaleAspectFit
      return img
    }()
    
   lazy var mainStack : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [img , titleLab , subtitleStack])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        return stack
    }()
    
    lazy var subtitleStack : UIStackView = {
         let stack = UIStackView(arrangedSubviews: [authIcon , authorLab , likeIcon , likeLab])
         stack.axis = .horizontal
         stack.spacing = 10
         stack.distribution = .fill
         return stack
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
        
        contentView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        contentView.layer.borderWidth = 0.5
        
        contentView.addSubview(mainStack)
        mainStack.anchor(top: contentView.topAnchor, paddingTop: 5, bottom: contentView.bottomAnchor, paddingBottom: -5, left: contentView.leadingAnchor, paddingLeft: 5, right: contentView.trailingAnchor , paddingRight: -5, width: 0, height: 0)
        
        img.proportionalSize(width: mainStack.widthAnchor, widthPercent: 1.0, height: mainStack.heightAnchor, heightPercent: 0.7)
        
        likeIcon.setSize(width: 20, height: 20)
        authIcon.setSize(width: 20, height: 20)
        
        
    }
    
    func renderPostInfo()  {
        titleLab.text = post.text
        likeLab.text = "\(post.likes)"
        authorLab.text = post.author
        img.kf.setImage(with: URL(string: post.image)!)
    }
    
}
