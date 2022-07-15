//
//  RouterPosts.swift
//  VIPERArchitecture
//
//  Created by Mohannad on 5/8/22.
//

import UIKit


class PostsRouter : PresenterToRouterPostsProtocol {
    static func createPostsModule(postsViewRef: PostsController) {
        let presenter : ViewToPresenterPostsProtocol & InteractorToPresenterPostsProtocol = PostsPresenter()
        postsViewRef.presenter = presenter
        postsViewRef.presenter.view = postsViewRef
        postsViewRef.presenter.interactor = PostsInteractor()
        postsViewRef.presenter.router = PostsRouter()
        postsViewRef.presenter.interactor?.presenter = presenter
    }
    
    static func showPostDetails(selected : PostViewData ){
        let navigation = (SceneDelegate.shared.window?.rootViewController as? UINavigationController)
        let details = PostDetailsController.instantiateFromStoryboard("PostDetails")
        details.postInfo  = selected
        let presener : ViewToPresenterPostDetailsProtocol & InteractorToPresenterPostDetailsProtocol = PostDetailsPresenter()
        details.presenter = presener
        details.presenter.view = details
        details.presenter.interactor = PostDetailsInteractor()
        details.presenter.router = PostDetailsRouter()
        details.presenter.interactor?.presenter = presener
        navigation?.pushViewController(details, animated: true)
    }
}
