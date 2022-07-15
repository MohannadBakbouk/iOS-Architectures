//
//  PostDetailsController.swift
//  VIPERArchitecture
//
//  Created by Mohannad on 5/9/22.
//
import UIKit

class PostDetailsController: UIViewController {
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var likesLab: UILabel!
    
    @IBOutlet weak var authLab: UILabel!
    
    @IBOutlet weak var tagsLab: UILabel!
    
    @IBOutlet weak var contentLab: UILabel!
    
    @IBOutlet weak var commentCollection: UICollectionView!
    
    let commentFlowLayout = CommentFlowLayout()
    
    var collectionSource : CollectionDataSource<CommentViewData>!
    
    var collectionDelegate : CollectionViewDelegate!
    
    var presenter : ViewToPresenterPostDetailsProtocol!
    
    var postInfo : PostViewData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureFlowLayout()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Post Details"
        displayPostInfo()
        presenter.loadComments(postId: postInfo.id)
    }
    
    func displayPostInfo()  {
        img.kf.setImage(with: URL(string: postInfo.image)!)
        contentLab.text = postInfo.text
        likesLab.text = "\(postInfo.likes)"
        authLab.text = postInfo.author
        tagsLab.text = "Tags : \(postInfo.tags)"
    }
    
    func configure(){
        collectionSource = CollectionDataSource(items: [], reuseIdentifier: "Cell", cellConfigurator: { (item , cell , index ) in
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

extension PostDetailsController : PresenterToViewPostDetailsProtocol ,  CollectionDelegate {
    func onFetchedComments(items: [CommentViewData]) {
        commentCollection.toggleActivityIndicator()
        guard items.count > 0 else {
            commentCollection.setMessage(Constants.messages.noComments, icon: Constants.icons.empty)
            return
        }
        collectionSource.data = items
        commentCollection.reloadData()
    }
    
    func onLoading() {
        commentCollection.toggleActivityIndicator()
    }
    
    func onError() {
      commentCollection.toggleActivityIndicator()
      commentCollection.setMessage(Constants.messages.internetError, icon: Constants.icons.wifi)
    }
}

