//
//  MainCoordinator.swift
//  MVVMArchitectureWithRxswift
//
//  Created by Mohannad on 12/30/21.
//

import UIKit

class MainCoordinator : Coordinator {
   
    var childCoordinators : [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigation : UINavigationController) {
        self.navigationController = navigation
    }
    
    func start() {
        let main = PostsController.instantiateFromStoryboard("Posts")
        main.coordinator = self
        navigationController.pushViewController(main, animated: true)
    }
    
    func showPostDetails(info : PostViewData) {
        let details = PostDetailsViewController.instantiateFromStoryboard("PostDetails")
        let model = PostDetialsViewModel(details: info)
        details.viewModel = model
        navigationController.pushViewController(details, animated: true)
    }
}
