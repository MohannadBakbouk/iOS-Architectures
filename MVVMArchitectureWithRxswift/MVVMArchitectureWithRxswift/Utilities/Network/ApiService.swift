//
//  ApiService.swift
//  MVVMArchitectureWithRxswift
//
//  Created by Mohannad on 12/29/21.
//

import Foundation
import RxSwift

protocol ProApiService {
    
    func loadPosts(page : Int) -> Observable<[Post]>
    
    func loadPostComments(id : String) -> Observable<[Comment]>
    
}

class ApiService  :  ProApiService {
    
    private var api : ProAPIManager
    
    static let shared = ApiService(apiManager: APIManager())
    
    init(apiManager : ProAPIManager) {
        self.api = apiManager
    }
    
    func loadPosts(page: Int) -> Observable<[Post]> {
        
        return Observable.create { [weak self] observable in
            
            self?.api.fetchPosts(page: page) {  result in
                
                if case .success(let info) = result , let items = info.data  {
                    observable.onNext(items)
                }
                else if  case .failure(let error) = result {
                    observable.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func loadPostComments(id: String) -> Observable<[Comment]> {
        
        return Observable.create { [weak self] observable in
            
            self?.api.fetchPostComments(with: id) {  result in
                
                if case .success(let info) = result , let items = info.data  {
                    observable.onNext(items)
                }
                else if  case .failure(let error) = result {
                    observable.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    
}
