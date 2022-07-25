//
//  ViewController.swift
//  MVVMArchitectureWithCombine
//
//  Created by Mohannad on 7/21/22.
//

import UIKit
import Combine

class PostsController: UIViewController {
    
    var coordinator : MainCoordinator?
    
    var viewModel :  PostsViewModelProtocol!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var collectionSource : CollectionDataSource<PostViewData>!
    
    var collectionDelegate : CollectionViewDelegate!
    
    var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        confirgureCellsSize()
        bindCollectionViewDataSource()
        bindCollectionViewSelectItem()
        bindCollectionLoadingIndicator()
        bindErrorMessage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadPosts()
    }
    
    func configure(){
        viewModel = PostsViewModel()
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: Constants.CollCells.post)
        collectionSource = CollectionDataSource(items: viewModel.posts.value, reuseIdentifier: "PostCell", cellConfigurator: { (item , cell , index ) in
            if let casted = cell as? PostCell {
              casted.post = item
            }
        })
        collectionDelegate = CollectionViewDelegate(withDelegate : self)
        collectionView.dataSource = collectionSource
        collectionView.delegate = collectionDelegate
        navigationItem.title = "Home"
    }
    
    func confirgureCellsSize()  {

        let size = collectionView.frame.size
        
        let cellSize = CGSize(width: (CGFloat(size.width / 2.3 )) , height: (size.height / 4))
        
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        
        layout.itemSize = cellSize
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        layout.minimumLineSpacing = 10.0
        
        layout.minimumInteritemSpacing = 0
        
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
}

extension PostsController : CollectionDelegate{
    func selectedCell(row: Int) {
        viewModel.inputs.selectedPostIndex = row
    }
    
    func willDisplay(row: Int) {
        if (row == collectionSource.data.count / 2) && !viewModel.loadingMore{
            viewModel.currentPage += 1
            viewModel.loadPosts()
        }
    }
    
}

extension PostsController {
    
    func bindCollectionViewDataSource(){
        viewModel.outputs.posts
        .receive(on: DispatchQueue.main)
        .sink(receiveValue: {[weak self] items in
            guard let self = self else {return}
            self.collectionSource.data = items
            self.collectionView.reloadData()
        }).store(in: &cancellables)
    }
    
    func bindCollectionViewSelectItem(){
        viewModel.outputs.selectedPost
        .receive(on: DispatchQueue.main)
        .sink {[weak self] selected in
                self?.coordinator?.showPostDetails(info: selected)
        }.store(in: &cancellables)
    }
    
    func bindCollectionLoadingIndicator(){
        viewModel.outputs.isLoading.receive(on: DispatchQueue.main)
        .sink(receiveValue: {[weak self] status in
            _ = status ? self?.collectionView.showIndicator() : self?.collectionView.hideIndicator()
        }).store(in: &cancellables)
    }
    
    func bindErrorMessage(){
        viewModel.outputs.onError
        .receive(on: DispatchQueue.main)
        .sink{[weak self] error in
                self?.collectionView.setMessage(error, icon: Constants.icons.wifi)
        }.store(in: &cancellables)
    }
    
    /*func bindCollectionLoadingIndicator(){
        viewModel.$isLoading.sink(receiveValue: {[weak self] status in
            DispatchQueue.main.async {
                _ = status ? self?.collectionView.showIndicator() : self?.collectionView.hideIndicator()
            }
        }).store(in: &cancellables)
    }*/
}
