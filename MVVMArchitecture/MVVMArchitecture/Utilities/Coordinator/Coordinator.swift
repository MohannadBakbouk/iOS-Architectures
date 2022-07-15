//
//  Coordinator.swift
//  MVVMArchitecture
//
//  Created by Mohannad on 15.02.2021.
//

import UIKit


protocol Coordinator {
    
    var childCoordinators : [Coordinator] { get set}
    
    var navigationController : UINavigationController { get set }
    
    func start()

}
