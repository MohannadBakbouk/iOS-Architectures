//
//  MainCoordinator.swift
//  MVVMArchitectureWithCombine
//
//  Created by Mohannad on 7/21/22.
//

import Foundation

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
        let details = PostDetailsController.instantiateFromStoryboard("PostDetails")
        let model = PostDetailsViewModel(details: info)
        details.viewModel = model
        navigationController.pushViewController(details, animated: true)
    }
}

