//
//  PostViewData.swift
//  MVVMArchitecture
//
//  Created by Mohannad on 13.06.2021.
//

import Foundation

struct PostViewData {
    var id : String
    var text : String
    var image : String
    var likes : Int
    var tags :String
    var author : String
    
    init(info : Post) {
        
        self.id = info.id
        self.text = info.text
        self.image = info.image
        self.likes = info.likes
        self.tags =  info.tags.joined(separator : ", ")
        if let owner = info.owner {
           self.author = "\(owner.firstName)_\(owner.lastName)"
        }
        else {
           self.author = "anonymous author"
        }
        
        

    }
}
