//
//  Post.swift
//  MVVMArchitecture
//
//  Created by Mohannad on 13.06.2021.
//

import Foundation

struct Post : Codable {
    var text : String
    var image : String
    var likes : Int
    var link : String?
    var tags : [String]
    var publishDate : String
    var owner : User?
    var id : String
}



struct PostsResponse : Codable {
   var data : [Post]?
}



