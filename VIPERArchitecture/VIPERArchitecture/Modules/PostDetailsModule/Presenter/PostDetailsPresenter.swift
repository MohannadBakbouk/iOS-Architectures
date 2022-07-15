//
//  PostDetailsPresenter.swift
//  VIPERArchitecture
//
//  Created by Mohannad on 5/15/22.
//

import Foundation

class PostDetailsPresenter : ViewToPresenterPostDetailsProtocol{
    var view: PresenterToViewPostDetailsProtocol?
    
    var router: PresenterToRouterPostDetailsProtocol?
    
    var interactor: PresenterToInteractorPostDetailsProtocol?
    
    func loadComments(postId : String) {
        view?.onLoading()
        interactor?.fetchComment(postId : postId)
    }
}

extension PostDetailsPresenter : InteractorToPresenterPostDetailsProtocol {
    func successComments(items: [Comment]) {
        DispatchQueue.main.async {[weak self] in
            self?.view?.onFetchedComments(items: items.map{CommentViewData(info: $0)})
        }
    }
    
    func failsComments() {
        DispatchQueue.main.async {[weak self] in
            self?.view?.onError()
        }
    }
}
