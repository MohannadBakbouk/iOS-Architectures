//
//  ViewController.swift
//  MVVMArchitecture
//
//  Created by Mohannad on 12.06.2021.
//

import UIKit

class PostsController: UIViewController {
    
    @IBOutlet weak var postsCollection: UICollectionView!
    
    var viewModel : PostsViewModel!
    
    var collectionSource : CollectionDataSource<PostViewData>!
    
    var collectionDelegate : CollectionViewDelegate!
    
    var coordinator : MainCoordinator?
    {
        didSet{
            
            print("val \(coordinator)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        confirgureCellsSize()
        bindToViewModel()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         navigationItem.title = "Home"
         viewModel.getPosts()
    }
    
    
    
    func configure(){
        
        viewModel = PostsViewModel()
        
        collectionSource = CollectionDataSource(items: viewModel.posts, reuseIdentifier: "PostCell", cellConfigurator: { (item , cell , index ) in
            
            if let casted = cell as? PostCell {
              casted.post = item
            }
        })
        
        collectionDelegate = CollectionViewDelegate(withDelegate : self)
        
        postsCollection.dataSource = collectionSource
        
        postsCollection.register(PostCell.self, forCellWithReuseIdentifier: "PostCell")
        postsCollection.register(IndicatorCell.self, forCellWithReuseIdentifier: "Indicator")
        
        postsCollection.delegate = collectionDelegate
    }
    
    func confirgureCellsSize()  {

        let size = postsCollection.frame.size
        
        
        let cellSize = CGSize(width: (CGFloat(size.width / 2.3 )) , height: (size.height / 4))
        
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        
        layout.itemSize = cellSize
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        layout.minimumLineSpacing = 10.0
        
        layout.minimumInteritemSpacing = 0
        
        postsCollection.setCollectionViewLayout(layout, animated: true)
    }
    
    
    
    func bindToViewModel(){
        
        viewModel.isRefreshing = { [weak self] status in
            self?.postsCollection.toggleActivityIndicator()
        }
        
        viewModel.onFetchedPosts = { [weak self]  posts in
            self?.showFetchedPosts(items: posts)
        }
        
        viewModel.onError = {[weak self] in
            self?.showError()
        }
    }
}


extension PostsController {
    /*the implementation of view model closures */
    func showFetchedPosts(items : [PostViewData]){
        
        self.postsCollection.toggleActivityIndicator()

        if items.count > 0 {
            self.collectionSource.data = items
            self.postsCollection.reloadData()
        }
        else {
            self.postsCollection.setMessage(Constants.messages.noPosts, icon: Constants.icons.empty)
        }
    }

    func showError(){
        
        self.postsCollection.toggleActivityIndicator()
        
        self.postsCollection.setMessage(Constants.messages.internetError, icon: Constants.icons.wifi)
    }
}


extension PostsController : CollectionDelegate{
    
    //I need to illustrate how we can send data into viewmodel
    func selectedCell(row: Int) {
        if let target =  viewModel.onSelectedPost?(row) {
          coordinator?.showPostDetails(info: target)
        }
    }
    
    
    func willDisplay(row: Int) {
        if (row == viewModel.posts.count / 2) && !viewModel.loadingMore{
            let page = (Int(viewModel.posts.count) / 20) + 1
            viewModel.getNextPage(position: page)
            print("ssds")
        }
    }
    
    
}
