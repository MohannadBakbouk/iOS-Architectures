//
//  PostsController.swift
//  MVVMArchitectureWithRxswift
//
//  Created by Mohannad on 12/28/21.
//

import UIKit
import RxSwift
import RxCocoa

class PostsController : UIViewController {

    var viewModel :  PostsViewModel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var coordinator : MainCoordinator?
    
    private let disposeBag  = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        confirgureCollectionCellsSize()
        bindCollectionViewDataSource()
        bindCollectionViewSelectItem()
        bindCollectionLoadingIndicator()
        bindingCollectionViewScrolling()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadPosts()
    }
    
    func configure(){
        
        viewModel = PostsViewModel()
        
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: Constants.CollCells.post)
        
        navigationItem.title = "Home"
        
    }
}

extension PostsController  {
    
    func bindCollectionViewDataSource(){
        
        viewModel.posts.bind(to: collectionView.rx.items) {  (collection , index , item) in
            
            let indexPath = IndexPath(row: index, section: 0)
            
            let cell = collection.dequeueReusableCell(withReuseIdentifier: Constants.CollCells.post, for: indexPath)  as! PostCell
            
            cell.post = item
            
            return cell
        }.disposed(by: disposeBag)
        
  
    }
    
    func bindCollectionViewSelectItem(){
        
        collectionView.rx.modelSelected(PostViewData.self).subscribe(onNext : {[weak self] item in
            print("\(item) was selected")
            self?.coordinator?.showPostDetails(info: item)
        }).disposed(by: disposeBag)
    }
    
    func bindCollectionLoadingIndicator(){
        
        collectionView.setupLoadingIndicator()
        
        guard let indicator = collectionView.backgroundView as? UIActivityIndicatorView else {
            return
        }
        viewModel.isLoading.bind(to: indicator.rx.isAnimating).disposed(by: disposeBag)
        
    }
    
    func bindingCollectionViewScrolling(){
       
        collectionView.rx.reachedBottom.asObservable().bind(to: viewModel.reachedBottomTrigger)
        .disposed(by: disposeBag)
    }
    
    func confirgureCollectionCellsSize()  {

        let size = collectionView.frame.size
        
        let width  = UIScreen.main.bounds.width - 20
        
        let cellSize = CGSize(width: (CGFloat(  width  / 2 )) , height: (size.height / 4))
        
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        
        layout.itemSize = cellSize
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        layout.minimumLineSpacing = 10.0
        
        layout.minimumInteritemSpacing = 0
        
        collectionView.setCollectionViewLayout(layout, animated: true)
    }

}
