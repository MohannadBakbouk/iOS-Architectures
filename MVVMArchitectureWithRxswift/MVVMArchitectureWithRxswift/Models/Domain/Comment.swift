//
//  Comment.swift
//  MVVMArchitectureWithRxswift
//
//  Created by Mohannad on 12/28/21.
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


