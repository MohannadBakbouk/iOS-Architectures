//
//  MainCoordinator.swift
//  MVVMArchitecture
//
//  Created by Mohannad on 2.07.2021.
//

import UIKit


class MainCoordinator : Coordinator{
   
    var childCoordinators: [Coordinator] = []
    
    var navigationController : UINavigationController
    
    init(navigation : UINavigationController) {
        self.navigationController = navigation
    }
    
    func start() {
        let main = PostsController.instantiateFromStoryboard()
        main.coordinator = self
        navigationController.pushViewController(main, animated: true)
    }
    
    func showPostDetails(info : PostViewData){
        let details = PostDetailsViewController.instantiateFromStoryboard("PostDetails")
        let model = PostDetialsViewModel()
        model.postInfo = info
        details.viewModel = model
        navigationController.pushViewController(details, animated: true)
    }
    
    
}
