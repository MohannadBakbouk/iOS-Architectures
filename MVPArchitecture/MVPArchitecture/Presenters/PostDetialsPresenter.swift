//
//  PostDetialsPresenter.swift
//  MVPArchitecture
//
//  Created by Mohannad on 12/1/20.
//

import Foundation


protocol PostDetialsView  : NSObjectProtocol {
    
    func setComments(comments : [CommentViewData])
    
    func setEmptyComments()
    
    func showError()
    
    func startLoaging()
    
    func endLoading()
    
}


class PostDetialsPresenter  {
    
    weak private var postDetailsView : PostDetialsView?
    
    init(view : PostDetialsView) {
        self.postDetailsView = view
    }
    
    func attachView(view : PostDetialsView)  {
        self.postDetailsView = view
    }
    
    func deAttachView(view : PostDetialsView)  {
        self.postDetailsView = nil
    }
    
    
    func getPostComments(Id : String)  {
        
        self.postDetailsView?.startLoaging()
        
        APIManager.shared.fetchPostComments(postId: Id) { (res) in
            
            DispatchQueue.main.async {
            
                self.postDetailsView?.endLoading()
 
                if let response = res  {
                    
                    if  response.total > 0 {
                        
                        let mappedComments = response.data!.map { (item) -> CommentViewData in
                            
                            return CommentViewData(id: item.id, message: item.message, ownerName: item.owner.firstName, picture: item.owner.picture)
                        }
                        
                    

                        self.postDetailsView?.setComments(comments: mappedComments)
                    }
                    else {
                        
                        self.postDetailsView?.setEmptyComments()
                    }
                }
                else {
                    self.postDetailsView?.showError()
                }
            }
        }
    }
}
