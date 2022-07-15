//
//  PostsViewModel.swift
//  MVVMArchitecture
//
//  Created by Mohannad on 26.06.2021.
//

import Foundation



class PostsViewModel {
    
    /* Closures The view has to implement*/
    
    /* Output Event */
    var onFetchedPosts : (([PostViewData]) -> Void)?
    var onError : (() -> Void)?
    var isRefreshing : ((Bool)->Void)?
    
    /* Input Events */
    var onSelectedPost : ((Int)->PostViewData)?
    
    init() {
        
        loadingMore = false
        
        onSelectedPost = { row in
            print("The user has just selected", row)
            return self.posts[row]
        }
        
      
    }
    
     
    var posts = [PostViewData]() {
        didSet{
            onFetchedPosts?(posts)
        }
    }
    
    var loadingMore  : Bool
    
    func getPosts()  {
        
        isRefreshing?(true)
        
        APIManager.shared.fetchPosts { (res) in
            
            DispatchQueue.main.async {
                
                if let posts = res?.data {
                        let mapped = posts.map{return  PostViewData(info: $0)}
                        self.posts = mapped
                }
                else{
                    self.onError?()
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
                        
                        let mapped = posts.map{
                            return  PostViewData(info: $0)
                        }
                        
                        self.posts.append(contentsOf: mapped)
                        
                    }
                    
                    self.loadingMore = false
                
                }
            }
        }
    }

}
