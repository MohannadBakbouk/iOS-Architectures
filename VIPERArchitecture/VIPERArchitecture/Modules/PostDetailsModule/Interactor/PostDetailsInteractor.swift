//
//  PostDetailsInteractor.swift
//  VIPERArchitecture
//
//  Created by Mohannad on 5/15/22.
//

import Foundation

class  PostDetailsInteractor: PresenterToInteractorPostDetailsProtocol {


    var presenter: InteractorToPresenterPostDetailsProtocol?
    
    func fetchComment(postId : String) {
        APIManager.shared.fetchPostComments(postId: postId) {[weak self] response in
            if let comments = response?.data {
                self?.presenter?.successComments(items: comments)
            }
            else {
                self?.presenter?.failsComments()
            }
        }
    }
}
