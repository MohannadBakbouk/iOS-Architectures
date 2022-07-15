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
    
    var collectionSource : CollectionDataSource<CommentViewData>!
    
    var collectionDelegate : CollectionViewDelegate!
    
    var viewModel : PostDetialsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureFlowLayout()
        bindToViewModel()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Post Details"
        displayPostInfo()
        viewModel.getPostComments()
    }
    
    func displayPostInfo()  {
        img.kf.setImage(with: URL(string: viewModel.postInfo.image)!)
        contentLab.text = viewModel.postInfo.text
        likesLab.text = "\(viewModel.postInfo.likes)"
        authLab.text = viewModel.postInfo.author
        tagsLab.text = "Tags : \(viewModel.postInfo.tags)"
    }
    
    func bindToViewModel()  {
        
        viewModel.isRefreshing = { status in
            self.commentCollection.toggleActivityIndicator()
        }
        
        viewModel.onError = {
            self.commentCollection.toggleActivityIndicator()
            self.commentCollection.setMessage(Constants.messages.internetError, icon: Constants.icons.wifi)
        }
        
        viewModel.onFetchedComments = { comments in
            self.commentCollection.toggleActivityIndicator()
            if comments.count > 0 {
               self.collectionSource.data = comments
               self.commentCollection.reloadData()
            }
            else {
                self.commentCollection.setMessage(Constants.messages.noComments, icon: Constants.icons.empty)
            }
        }
    }
    
    func configure(){
        
        collectionSource = CollectionDataSource(items: viewModel.comments, reuseIdentifier: "Cell", cellConfigurator: { (item , cell , index ) in
            
            let casted = (cell as! CommentCell)
            
            casted.comment = item

        })
        collectionDelegate = CollectionViewDelegate(withDelegate: self)
        commentCollection.dataSource = collectionSource
        commentCollection.delegate = collectionDelegate
        commentCollection.register(CommentCell.self, forCellWithReuseIdentifier: "Cell")
        
    }
    
    func configureFlowLayout()  {
        commentFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        commentFlowLayout.minimumInteritemSpacing = 10
        commentFlowLayout.minimumLineSpacing = 10
        commentCollection.collectionViewLayout = commentFlowLayout
        commentCollection.contentInsetAdjustmentBehavior = .always
    }
    
    
    
}


extension PostDetailsViewController : CollectionDelegate{
    

}
