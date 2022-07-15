//
//  CommentViewData.swift
//  MVVMArchitectureWithRxswift
//
//  Created by Mohannad on 12/28/21.
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
