//
//  APIManager.swift
//  MVVMArchitectureWithCombine
//
//  Created by Mohannad on 7/21/22.
//

import Foundation


class APIManager : NSObject ,  ProAPIManager{
    

    func fetchPosts(page : Int  = 1 , completion : @escaping (Result<PostsResponse, ApiError>) -> ()) {
        
        let params = [ "page" : page]
        request(endpoint: .random, method: .GET , params: params , completion: completion)
    }
    
    func fetchPostComments(with id: String , completion : @escaping (Result<CommentsResponse, ApiError>) -> ()) {
        request(endpoint: .comments(postId: id), method: .GET, completion: completion)
    }
    
    private func request<T: Codable>(endpoint : EndPoint , method : Method ,
            params : JSON? = nil , completion : @escaping (Result<T, ApiError>) -> Void ){
        
        let urlStr = "\(Constants.identifiers.apiUrl)\(endpoint.path)"
        
        guard  var urlComp = URLComponents(string: urlStr) else {
            completion(.failure(.internalError))
            return
        }
        
        if let body = params , method == .GET {
            urlComp.queryItems = []
            for item in body {
                 let value = String(describing: item.value)
                  urlComp.queryItems!.append(URLQueryItem(name: item.key, value: value))
                
            }
        }
        print("urlComp\(urlComp.string!)")
        var request = URLRequest(url:urlComp.url!)
        
        request.httpMethod = method.rawValue

        request.setValue(Constants.identifiers.apiContent, forHTTPHeaderField: "Content-Type")
         
        request.setValue(Constants.identifiers.apiAccept, forHTTPHeaderField: "Accept")
       
        request.setValue(Constants.identifiers.apiKey, forHTTPHeaderField: "app-id")
        
        call(with: request, completion: completion)

    }
    
    func call<T : Codable> (with request : URLRequest , completion : @escaping (Result<T , ApiError>) -> Void) {
        
        let task = URLSession.shared.dataTask(with: request) { (data , response , error) in
            
            guard let data = data , error == nil else {
                completion(.failure(.serverError))
                return
            }
            
            do {
                let info = try JSONDecoder().decode(T.self, from: data)
                completion(.success(info))
            }
            catch(let ex){
                
                print("\(ex)")
                completion(.failure(.parseError))
            }
        }
        
        task.resume()
    }
    
}
