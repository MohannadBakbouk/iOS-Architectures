//
//  ViewController.swift
//  MVPArchitecture
//
//  Created by Mohannad on 11/10/20.
//

import UIKit

class PostsViewController: UIViewController {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var collectrionView: UICollectionView!
    
    private var presenter : PostsPresenter!
    
    private var posts = [PostViewData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = PostsPresenter(view: self)
        collectrionView.register(PostCell.self, forCellWithReuseIdentifier: "cell")
        collectrionView.register(IndicatorCell.self, forCellWithReuseIdentifier: "indicator")
        collectrionView.dataSource = self
        collectrionView.delegate = self
        presenter.getPosts()
    }
}


extension PostsViewController : PostsView {
   
    
    func startLoading() {
    
        collectrionView.toggleActivityIndicator()
    }
    
    func endLoading() {
        
        collectrionView.toggleActivityIndicator()
    }
    
    func setPosts(posts: [PostViewData]) {
        
        self.posts = posts
        collectrionView.isHidden = false
        collectrionView.reloadData()
    }
    
    func updatePosts(newPosts: [PostViewData]) {
        
        self.posts.append(contentsOf: newPosts)
        collectrionView.reloadData()
    }
    
    func setEmptyPosts() {
        collectrionView.setMessage("There are no results", icon: "icloud.slash.fill")
    }
    
    func showError() {
        
        collectrionView.setMessage("make sure you are connected to the internet ", icon: "wifi.slash")
    }
}


extension PostsViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return (self.posts.count > 0) ? (self.posts.count + 1) : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row != posts.count {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PostCell
            
            cell.post = posts[indexPath.row]
            
            return cell
        }
        else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "indicator", for: indexPath) as! IndicatorCell
            
            cell.inidicator.startAnimating()
            
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        let cellHeight =  (indexPath.row != posts.count ) ? size.height / 3 : 40
        return CGSize(width: size.width , height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == posts.count ) && !presenter.loadingMore{
            let page = (Int(posts.count) / 20) + 1
            presenter.getNextPage(position: page)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let story = UIStoryboard(name: "PostDetails", bundle: nil)
        
        let controller = story.instantiateViewController(identifier: "PostDetails") as! PostDetailsViewController
        
        controller.postInfo = posts[indexPath.row]

        navigationController?.pushViewController(controller, animated: true)
    }
    
 
}
