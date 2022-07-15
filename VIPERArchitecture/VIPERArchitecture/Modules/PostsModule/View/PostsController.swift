//
//  ViewController.swift
//  VIPPERArchitecture
//
//  Created by Mohannad on 5/8/22.
//

import UIKit

class PostsController: UIViewController {

    @IBOutlet weak var postsCollection: UICollectionView!
    
    var collectionSource : CollectionDataSource<PostViewData>!
    
    var collectionDelegate : CollectionViewDelegate!
    
    var presenter : ViewToPresenterPostsProtocol!
    
    var posts : [PostViewData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PostsRouter.createPostsModule(postsViewRef: self)
        configure()
        confirgureCellsSize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         navigationItem.title = "Home"
        presenter.fetchPosts(page: 1)
    }
    
    func configure(){
        
        collectionSource = CollectionDataSource(items: posts, reuseIdentifier: "PostCell", cellConfigurator: { (item , cell , index ) in
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
}

extension PostsController : CollectionDelegate{
    
    func selectedCell(row: Int) {
        let target =  collectionSource.data[row]
        PostsRouter.showPostDetails(selected: target)
    }
    
    
    func willDisplay(row: Int) {
        if (row == posts.count / 2) && !presenter.isLoadingMore{
            let page = (Int(posts.count) / 20) + 1
            presenter.fetchPosts(page: page)
        }
    }
}

extension PostsController : PresenterToViewPostsProtocol{
    func onFetchedPosts(items: [PostViewData]) {
        posts.append(contentsOf: items)
        collectionSource.data = posts
        postsCollection.toggleActivityIndicator()
        postsCollection.reloadData()
    }
    
    func onError() {
        postsCollection.toggleActivityIndicator()
        postsCollection.setMessage(Constants.messages.internetError, icon: Constants.icons.wifi)
    }
    
    func onLoading() {
        postsCollection.toggleActivityIndicator()
    }
}




