//
//  ProAPIManager.swift
//  MVVMArchitectureWithCombine
//
//  Created by Mohannad on 7/21/22.
//

import Foundation

protocol ProAPIManager {
    
    func fetchPosts(page : Int  , completion : @escaping (Result<PostsResponse, ApiError>) -> ())
    
    func fetchPostComments(with : String , completion : @escaping (Result<CommentsResponse, ApiError>) -> ())
}
