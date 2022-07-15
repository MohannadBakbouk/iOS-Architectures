//
//  PostsInteractor.swift
//  VIPERArchitecture
//
//  Created by Mohannad on 5/8/22.
//

import Foundation

class PostsInteractor : PresenterToInteractorPostsProtocol {
    
    var presenter: InteractorToPresenterPostsProtocol?
    
    func loadPosts(page : Int) {
        APIManager.shared.fetchPosts(page : page) {[weak self] response in
            if let posts = response?.data {
                self?.presenter?.postsSuccess(items: posts)
            }
            else {
                self?.presenter?.postsFailed()
            }
        }
    }
}
