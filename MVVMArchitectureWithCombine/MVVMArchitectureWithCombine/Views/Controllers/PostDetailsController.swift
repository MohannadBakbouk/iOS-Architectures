//
//  PostDetailsController.swift
//  MVVMArchitectureWithCombine
//
//  Created by Mohannad on 7/22/22.
//

import UIKit
import Combine

class PostDetailsController: UIViewController , CollectionDelegate {
    
    var coordinator : MainCoordinator?
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var likesLab: UILabel!
    
    @IBOutlet weak var authLab: UILabel!
    
    @IBOutlet weak var tagsLab: UILabel!
    
    @IBOutlet weak var contentLab: UILabel!
    
    @IBOutlet weak var commentCollection: UICollectionView!
    
    let commentFlowLayout = CommentFlowLayout()
    
    var collectionSource : CollectionDataSource<CommentViewData>!
    
    var collectionDelegate : CollectionViewDelegate!
    
    var viewModel : PostDetailsViewModelProtocol!
    
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureFlowLayout()
        bindingPostInfoToUI()
        bindingCommentsCollectionDataSource()
        bindingLoadingIndicator()
        bindingErrorMessage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getPostComments()
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


extension PostDetailsController {
    func bindingPostInfoToUI() {
        viewModel.outputs.info.sink{[weak self] postInfo  in
            guard let self = self  else {return}
            self.img.kf.setImage(with: URL(string: postInfo.image)!)
            self.contentLab.text = postInfo.text
            self.likesLab.text = "\(postInfo.likes)"
            self.authLab.text = postInfo.author
            self.tagsLab.text = "Tags : \(postInfo.tags)"
        }.store(in: &cancellables)
    }
    
    func bindingCommentsCollectionDataSource(){
        viewModel.outputs.comments.sink{[weak self] items in
            guard let self = self  else {return}
            DispatchQueue.main.async {
                self.collectionSource.data = items
                self.commentCollection.reloadData()
            }
        }.store(in: &cancellables)
    }
    
    func bindingLoadingIndicator(){
        viewModel.outputs.isLoading.sink{[weak self] status in
            DispatchQueue.main.async {
                _ = status ? self?.commentCollection.showIndicator() : self?.commentCollection.hideIndicator()
            }
        }.store(in: &cancellables)
    }
    
    func bindingErrorMessage(){
        viewModel.onError.sink{[weak self] message in
            DispatchQueue.main.async {
                self?.commentCollection.setMessage(message, icon: Constants.icons.wifi)
            }
        }.store(in: &cancellables)
    }
}
