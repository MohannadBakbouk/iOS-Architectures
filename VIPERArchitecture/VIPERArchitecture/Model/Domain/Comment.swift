//
//  Comment.swift
//  VIPERArchitecture
//
//  Created by Mohannad on 5/8/22.
//

import Foundation

struct Comment : Codable {
    var owner : User
    var id : String
    var message : String
    var publishDate : String
    
}

struct CommentsResponse : Codable {
    var data : [Comment]?
    var total : Int
    var page : Int
    var limit : Int
    //var offset : Int
}


