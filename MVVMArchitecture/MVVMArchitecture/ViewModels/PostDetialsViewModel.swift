//
//  PostDetialsViewModel.swift
//  MVVMArchitecture
//
//  Created by Mohannad on 3.07.2021.
//

import Foundation


class PostDetialsViewModel {
    

    /* Output Event */
    var onFetchedComments : (([CommentViewData]) -> Void)?
    var onError : (() -> Void)?
    var isRefreshing : ((Bool)->Void)?
    
    
    var comments = [CommentViewData]() {
        didSet{
            self.onFetchedComments?(comments)
        }
    }
    
    var postInfo : PostViewData!

    
    func getPostComments()  {
        
        self.isRefreshing?(true)
        
        APIManager.shared.fetchPostComments(postId: postInfo.id) { (res) in
            
            DispatchQueue.main.async {
            
                self.isRefreshing?(false)
 
                if let response = res  {
                    
                    if  response.total > 0 {
                        let mapped = response.data!.map { (item) -> CommentViewData in
                            return CommentViewData(info: item)
                        }
                        self.comments = mapped
                    }
                }
                else {
                    self.onError?()
                }
            }
        }
    }
    
}
