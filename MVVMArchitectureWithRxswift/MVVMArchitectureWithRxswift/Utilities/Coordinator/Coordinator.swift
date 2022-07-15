//
//  Coordinator.swift
//  MVVMArchitectureWithRxswift
//
//  Created by Mohannad on 12/30/21.
//

import UIKit

protocol Coordinator {
    var childCoordinators : [Coordinator] {get set}
    var navigationController : UINavigationController {get set}
    func start()
}
