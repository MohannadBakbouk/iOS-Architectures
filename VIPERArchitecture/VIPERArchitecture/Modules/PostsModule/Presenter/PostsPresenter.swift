//
//  PostsPresenter.swift
//  VIPERArchitecture
//
//  Created by Mohannad on 5/8/22.
//

import Foundation

class PostsPresenter: ViewToPresenterPostsProtocol {
    var view: PresenterToViewPostsProtocol?
    
    var interactor: PresenterToInteractorPostsProtocol?
    
    var router: PresenterToRouterPostsProtocol?
    
    var isLoadingMore: Bool
    
    init() {
        isLoadingMore = false
    }
    
    func fetchPosts(page : Int) {
        guard !isLoadingMore else {return}
        view?.onLoading()
        interactor?.loadPosts(page : page)
        isLoadingMore = page > 1
    }
}

extension PostsPresenter : InteractorToPresenterPostsProtocol {
    func postsSuccess(items : [Post]) {
        DispatchQueue.main.async {[weak self] in
            let formattedItems = items.map{PostViewData(info: $0)}
            self?.view?.onFetchedPosts(items: formattedItems)
        }
        isLoadingMore = false
    }
    
    func postsFailed() {
        DispatchQueue.main.async {[weak self] in
            self?.view?.onError()
        }
        isLoadingMore = false
    }
}
