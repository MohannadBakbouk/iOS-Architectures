//
//  PostsViewModel.swift
//  MVVMArchitectureWithCombine
//
//  Created by Mohannad on 7/22/22.
//

import Foundation
import Combine

protocol PostsViewModelInput {
   var selectedPostIndex :  Int? {get set}
}

protocol PostsViewModelOutput {
    var posts : CurrentValueSubject<[PostViewData] , Never> {get}
    var selectedPost : PassthroughSubject<PostViewData , Never> {get}
    var onError : PassthroughSubject<String , Never> {get}
    var isLoading : CurrentValueSubject<Bool, Never> {get}
}

protocol PostsViewModelProtocol : PostsViewModelOutput, PostsViewModelInput {
    var  inputs : PostsViewModelInput {get set}
    var  outputs : PostsViewModelOutput {get}
    func loadPosts()
    func subscribingtoSelectedPost()
    var currentPage : Int {get set}
    var pageCount : Int {get}
    var loadingMore : Bool {get}
}

class PostsViewModel : PostsViewModelProtocol  {
    
    var inputs: PostsViewModelInput { get{return self} set {} }
    
    var outputs : PostsViewModelOutput  {return self}

    private var cancellable  = Set<AnyCancellable>()
    
    var currentPage = 1
    
    var pageCount = 8
    
    var loadingMore  : Bool
    
    var posts : CurrentValueSubject<[PostViewData] , Never>
    
    var selectedPost : PassthroughSubject<PostViewData , Never>
    
    var onError : PassthroughSubject<String , Never>
    
    var isLoading : CurrentValueSubject<Bool , Never>
    
    @Published var selectedPostIndex :  Int?
    
    init() {
        posts = CurrentValueSubject([])
        selectedPost = PassthroughSubject()
        onError = PassthroughSubject()
        isLoading = CurrentValueSubject(false)
        loadingMore = false
        subscribingtoSelectedPost()
    }
    
    func loadPosts(){
        loadingMore = currentPage != 1
        isLoading.value =  currentPage == 1 && posts.value.count == 0
        ApiService.shared.loadPosts(page: currentPage)
        .sink(receiveCompletion: {[weak self]  completed in
            guard let self = self else {return}
            self.loadingMore = false
            self.isLoading.value = false
            guard case .failure(let error) = completed  else { return}
            self.onError.send(error.localizedDescription)
        },
        receiveValue: {[weak self] items in
           guard let self = self else {return}
           let results =  items.map{PostViewData(info: $0)}
           self.posts.value = self.posts.value + results
        }).store(in: &cancellable)
    }
    
    func subscribingtoSelectedPost(){
        $selectedPostIndex.compactMap{$0}
        .sink(receiveValue: {[weak self] index in
            guard let self = self else {return}
            self.selectedPost.send(self.posts.value[index])
        }).store(in: &cancellable)
    }
}
