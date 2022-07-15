//
//  PostsPresenter.swift
//  MVPArchitecture
//
//  Created by Mohannad on 11/10/20.
//

import Foundation

protocol PostsView : NSObjectProtocol {
    
    func startLoading()
    
    func endLoading()
    
    func setPosts(posts : [PostViewData])
    
    func updatePosts(newPosts : [PostViewData])

    func setEmptyPosts()
    
    func showError()
    
}

class PostsPresenter {
    
    weak private var postsView : PostsView?
    
    var loadingMore : Bool
    
    init(view : PostsView) {
        postsView = view
        loadingMore = false
    }
    
    
    func attachView(view : PostsView){
        postsView = view
    }
    
    func deattachView(view : PostsView)  {
        postsView = nil
    }
    
    //MARK : Get Posts
    func getPosts()  {
        
        self.postsView?.startLoading()
        
        APIManager.shared.fetchPosts { (res) in
            
            DispatchQueue.main.async {
                
                self.postsView?.endLoading()
                
                if let posts = res?.data {
                    
                    if posts.count > 0 {
                        
                        let mappedPosts = posts.map{
                            return  PostViewData(id: $0.id, text: $0.text, image: $0.image, likes: $0.likes, tags: $0.tags.joined(separator : ", "), author: "\($0.owner.firstName)_\($0.owner.lastName)" )
                        }
                        
                       self.postsView?.setPosts(posts: mappedPosts)
                    }
                    else {
                        self.postsView?.setEmptyPosts()
                    }
                }
                else{
                    self.postsView?.showError()
                }
                
            }
        }
    }
    
    func getNextPage(position : Int)  {
        
        loadingMore = true
        
        APIManager.shared.fetchPosts(page: position) { (res) in
            
            DispatchQueue.main.async {
                if let posts = res?.data {
                    
                    if posts.count > 0 {
                        
                        let mappedPosts = posts.map{
                            return  PostViewData(id: $0.id, text: $0.text, image: $0.image, likes: $0.likes, tags:  $0.tags.joined(separator : ","), author: "\($0.owner.firstName)_\($0.owner.lastName)" )
                        }
                        
                       self.postsView?.updatePosts(newPosts: mappedPosts)
                    }
                    
                    self.loadingMore = false
                
                }
            }
        }

    }

    
    
}
