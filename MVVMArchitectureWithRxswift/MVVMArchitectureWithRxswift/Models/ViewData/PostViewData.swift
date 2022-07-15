//
//  PostViewData.swift
//  MVVMArchitectureWithRxswift
//
//  Created by Mohannad on 12/28/21.
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
        guard let owner = info.owner  else {self.author = "anonymous author"
            return}
        self.author = "\(owner.firstName)_\(owner.lastName)"
    }
}

