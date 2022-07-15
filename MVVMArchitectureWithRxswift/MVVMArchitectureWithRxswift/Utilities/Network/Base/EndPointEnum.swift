//
//  EndPointEnum.swift
//  MVVMArchitectureWithRxswift
//
//  Created by Mohannad on 3/13/22.
//
import Foundation

public typealias JSON =  [String : Any]

enum ApiError : Error{
    case serverError
    case parseError
    case internalError
}

enum Method : String {
    case GET
    case POST
}

enum EndPoint   {
    case random
    case comments(postId : String)
    
    var path : String {
        switch self {
            case .random:
                return "post"
            case .comments(let postId):
                return "post/\(postId)/comment"
        }
    }
}
