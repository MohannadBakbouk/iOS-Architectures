//
//  PostDetailsRouter.swift
//  VIPERArchitecture
//
//  Created by Mohannad on 5/15/22.
//

import UIKit

class PostDetailsRouter: PresenterToRouterPostDetailsProtocol {
    func back(viewRef : UIViewController) {
        viewRef.navigationController?.popViewController(animated: true)
    }
}
