//
//  PostDetialsViewModel.swift
//  MVVMArchitectureWithCombine
//
//  Created by Mohannad on 7/22/22.
//

import Foundation
import Combine

protocol PostDetailsViewModelOutput{
    var info : CurrentValueSubject<PostViewData , Never> {get}
    
    var comments : CurrentValueSubject<[CommentViewData] , Never> {get}
    
    var onError : PassthroughSubject<String , Never> {get}
    
    var isLoading : CurrentValueSubject<Bool , Never> {get}
}


protocol PostDetailsViewModelProtocol : PostDetailsViewModelOutput {
    var outputs : PostDetailsViewModelOutput {get}
    func getPostComments()
}

class PostDetailsViewModel : PostDetailsViewModelProtocol {
    
    var cancellables = Set<AnyCancellable>()
    
    var outputs : PostDetailsViewModelOutput {return self}
    
    var info : CurrentValueSubject<PostViewData , Never>
    
    var comments : CurrentValueSubject<[CommentViewData] , Never>
    
    var onError : PassthroughSubject<String , Never>
    
    var isLoading : CurrentValueSubject<Bool , Never>
    
    init(details : PostViewData){
        info = CurrentValueSubject(details)
        isLoading = CurrentValueSubject(false)
        comments = CurrentValueSubject([])
        onError = PassthroughSubject()
    }
    
    func getPostComments(){
        isLoading.value = true
        ApiService.shared.loadPostComments(id: info.value.id)
        .sink(receiveCompletion: {[weak self] completed in
            guard let self = self else {return}
            self.isLoading.value = false
            guard case .failure(let error) = completed else {return}
            self.onError.send(error.localizedDescription)
        }, receiveValue: {[weak self] items in
            self?.comments.send(items.map{CommentViewData(info: $0)})
        }).store(in: &cancellables)
    }
}
