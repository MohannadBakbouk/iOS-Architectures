//
//  ProAPIManager.swift
//  MVVMArchitectureWithRxswift
//
//  Created by Mohannad on 12/29/21.
//
import Foundation

protocol ProAPIManager {
    
    func fetchPosts(page : Int  , completion : @escaping (Result<PostsResponse, ApiError>) -> ())
    
    func fetchPostComments(with : String , completion : @escaping (Result<CommentsResponse, ApiError>) -> ())
}
