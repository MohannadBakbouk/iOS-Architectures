//
//  PostDetailsProtocol.swift
//  VIPERArchitecture
//
//  Created by Mohannad on 5/9/22.
//

import Foundation
import class UIKit.UIViewController

protocol PresenterToViewPostDetailsProtocol {
    func onFetchedComments(items : [CommentViewData])
    func onLoading()
    func onError()
}

protocol PresenterToInteractorPostDetailsProtocol {
    var presenter : InteractorToPresenterPostDetailsProtocol? {get set}
    func fetchComment(postId : String)
}

protocol PresenterToRouterPostDetailsProtocol {
    func back(viewRef : UIViewController)
}


protocol ViewToPresenterPostDetailsProtocol {
    var view : PresenterToViewPostDetailsProtocol? {get set}
    var router : PresenterToRouterPostDetailsProtocol? {get set}
    var interactor : PresenterToInteractorPostDetailsProtocol? {get set}
    func loadComments(postId : String)
}

protocol  InteractorToPresenterPostDetailsProtocol {
    func successComments(items : [Comment])
    func failsComments()
}
