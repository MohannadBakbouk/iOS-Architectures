//
//  PostDetailsViewController.swift
//  MVPArchitecture
//
//  Created by Mohannad on 12/1/20.
//

import UIKit

class PostDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var likesLab: UILabel!
    
    @IBOutlet weak var authLab: UILabel!
    
    @IBOutlet weak var tagsLab: UILabel!
    
    @IBOutlet weak var contentLab: UILabel!
    
    @IBOutlet weak var commentCollection: UICollectionView!
    
    let commentFlowLayout = CommentFlowLayout()
    
    var postInfo : PostViewData!
    
    private var comments = [CommentViewData]()
    
    private var presenter : PostDetialsPresenter!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = PostDetialsPresenter(view: self)
        presenter.getPostComments(Id: postInfo.id)
        commentCollection.dataSource = self
      //  commentCollection.delegate = self
        commentCollection.register(CommentCell.self, forCellWithReuseIdentifier: "cell")
        commentFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        commentFlowLayout.minimumInteritemSpacing = 10
        commentFlowLayout.minimumLineSpacing = 10
        commentCollection.collectionViewLayout = commentFlowLayout
        commentCollection.contentInsetAdjustmentBehavior = .always
        dispalyPostInfo()
    }
    
    func dispalyPostInfo()  {
        
       img.kf.setImage(with: URL(string: postInfo.image)!)
       contentLab.text = postInfo.text
       likesLab.text = "\(postInfo.likes)"
       authLab.text = postInfo.author
       tagsLab.text = "Tags : \(postInfo.tags)"
        
        
    }
    
}


extension PostDetailsViewController : PostDetialsView{
    func setComments(comments: [CommentViewData]) {
        
        print("comments \(comments)")
        
        self.comments = comments
        
        commentCollection.reloadData()
    }
    
    func setEmptyComments() {
        
        commentCollection.setMessage("There are no comments", icon: "text.bubble.fill")
    }
    
    func showError() {
        
        commentCollection.setMessage("make sure you are connected to the internet ", icon: "wifi.slash")
    }
    
    func startLoaging() {
        
        commentCollection.toggleActivityIndicator()
    }
    
    func endLoading() {
        
        commentCollection.toggleActivityIndicator()
    }
}

extension PostDetailsViewController : UICollectionViewDataSource  {
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CommentCell
        
         cell.index = indexPath.row
        
         cell.comment = comments[indexPath.row]
        
         
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let size = collectionView.frame
//
//        return CGSize(width: size.width, height: size.height / 3)
//    }
//
    
    

}
