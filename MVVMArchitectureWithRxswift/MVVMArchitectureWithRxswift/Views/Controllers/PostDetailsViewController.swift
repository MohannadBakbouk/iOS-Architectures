//
//  PostDetailsViewController.swift
//  MVVMArchitectureWithRxswift
//
//  Created by Mohannad on 12/28/21.
//

import UIKit
import RxSwift

class PostDetailsViewController: UIViewController {
    
    var coordinator : MainCoordinator?
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var likesLab: UILabel!
    
    @IBOutlet weak var authLab: UILabel!
    
    @IBOutlet weak var tagsLab: UILabel!
    
    @IBOutlet weak var contentLab: UILabel!
    
    @IBOutlet weak var commentCollection: UICollectionView!
    
    let commentFlowLayout = CommentFlowLayout()
    
   /* var collectionSource : CollectionDataSource<CommentViewData>!
    
    var collectionDelegate : CollectionViewDelegate!*/
    
    var viewModel : PostDetialsViewModel!
    
    private let disposeBag  = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureFlowLayout()
        bindingPostInfoToUI()
        bindingCommentsToCollectionDataSource()
        bindingRefreshingToIndicator()
        bindingOnErrorToLabel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Post Details"
        viewModel.getPostComments()
    }
    
    func bindingPostInfoToUI() {
        viewModel.outputs.info
        .subscribe(onNext : {[weak self] postInfo in
            guard let self = self else {return}
            self.img.kf.setImage(with: URL(string: postInfo.image)!)
            self.contentLab.text = postInfo.text
            self.likesLab.text = "\(postInfo.likes)"
            self.authLab.text = postInfo.author
            self.tagsLab.text = "Tags : \(postInfo.tags)"
        }).disposed(by: disposeBag)
    }
    
    
    func bindingCommentsToCollectionDataSource(){
        viewModel.outputs.comments
        .bind(to: commentCollection.rx.items) { (collection , index , item) in
            
            let indexPath = IndexPath(row: index, section: 0)
            
            let cell = collection.dequeueReusableCell(withReuseIdentifier: Constants.CollCells.comment, for: indexPath)  as! CommentCell
            
            cell.comment = item
            
            return cell
        }.disposed(by: disposeBag)
        
    }
    
    func bindingRefreshingToIndicator(){
        
        commentCollection.setupLoadingIndicator()
        
        guard let indicator = commentCollection.backgroundView as? UIActivityIndicatorView else {
            return
        }
        
        viewModel.outputs.isRefreshing
        .bind(to: indicator.rx.isAnimating)
        .disposed(by: disposeBag)
    }
    
    func bindingOnErrorToLabel(){
        viewModel.outputs.onError
        .subscribe(onNext :{[weak self] item in
            self?.commentCollection.setMessage(item, icon: "wifi")
        }).disposed(by: disposeBag)
    }
    

    
    /*func bindToViewModel()  {
        
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
    }*/
    
   func configure(){
      commentCollection.register(CommentCell.self, forCellWithReuseIdentifier: Constants.CollCells.comment)
    }
    
    func configureFlowLayout()  {
        commentFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        commentFlowLayout.minimumInteritemSpacing = 10
        commentFlowLayout.minimumLineSpacing = 10
        commentCollection.collectionViewLayout = commentFlowLayout
        commentCollection.contentInsetAdjustmentBehavior = .always
    }
    
    
    
}
