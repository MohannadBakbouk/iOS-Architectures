//
//  CommentViewData.swift
//  MVVMArchitectureWithCombine
//
//  Created by Mohannad on 7/21/22.
//

import Foundation

struct CommentViewData {
    
    var id : String
    var message : String
    var ownerName : String
    var picture : String
    
    init (info : Comment){
        self.id = info.id
        self.message = info.message
        self.ownerName = info.owner.firstName
        self.picture = info.owner.picture
    }
}

