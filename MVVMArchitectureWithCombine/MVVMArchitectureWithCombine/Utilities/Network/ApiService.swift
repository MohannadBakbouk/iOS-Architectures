//
//  ApiService.swift
//  MVVMArchitectureWithCombine
//
//  Created by Mohannad on 7/21/22.
//

import Foundation
import Combine

protocol ProApiService {
    
    func loadPosts(page : Int) -> AnyPublisher<[Post] , ApiError>
    
    func loadPostComments(id : String) -> AnyPublisher<[Comment], ApiError>
    
}

class ApiService  :  ProApiService {
    
    private var api : ProAPIManager
    
    static let shared = ApiService(apiManager: APIManager())
    
    private init(apiManager : ProAPIManager) {
        self.api = apiManager
    }
    
    func loadPosts(page: Int) -> AnyPublisher<[Post] , ApiError> {
        
        return Future<[Post], ApiError> { [weak self] promise in
            
            self?.api.fetchPosts(page: page) {  result in
                
                if case .success(let info) = result , let items = info.data  {
                    promise(.success(items))
                   // promise(.failure(.internalError))
                }
                else if  case .failure(let error) = result {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func loadPostComments(id: String) -> AnyPublisher<[Comment], ApiError> {
        return Future<[Comment], ApiError> {[weak self] promise in
            self?.api.fetchPostComments(with: id) {  result in
                if case .success(let info) = result , let items = info.data  {
                    promise(.success(items))
                   //promise(.failure(.internalError))
                }
                else if  case .failure(let error) = result {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}
