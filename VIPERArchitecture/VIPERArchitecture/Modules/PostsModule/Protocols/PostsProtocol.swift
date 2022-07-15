//
//  PostsProtocol.swift
//  VIPERArchitecture
//
//  Created by Mohannad on 5/8/22.
//

import Foundation

protocol PresenterToViewPostsProtocol {
    func onFetchedPosts(items : [PostViewData])
    func onError()
    func onLoading()
}

protocol PresenterToRouterPostsProtocol {
    static func createPostsModule(postsViewRef : PostsController)
}

protocol PresenterToInteractorPostsProtocol {
    var presenter : InteractorToPresenterPostsProtocol? {get set}
    func loadPosts(page : Int)
}

protocol ViewToPresenterPostsProtocol {
    var view : PresenterToViewPostsProtocol? { get set }
    var interactor : PresenterToInteractorPostsProtocol? { get set }
    var router : PresenterToRouterPostsProtocol? { get set }
    var  isLoadingMore : Bool {get set}
    func fetchPosts(page : Int)
}

protocol InteractorToPresenterPostsProtocol {
    func postsSuccess(items : [Post])
    func postsFailed()
}
