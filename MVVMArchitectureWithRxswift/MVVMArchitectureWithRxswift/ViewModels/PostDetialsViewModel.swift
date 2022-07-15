//
//  PostDetialsViewModel.swift
//  MVVMArchitectureWithRxswift
//
//  Created by Mohannad on 12/30/21.
//
import Foundation
import RxSwift

typealias PostDetialsViewModelEvents = PostDetialsViewModelOutput

protocol PostDetialsViewModelOutput {
    
    var info : BehaviorSubject<PostViewData> {get}
    
    var comments : BehaviorSubject<[CommentViewData]> {get}
    
    var isRefreshing : BehaviorSubject<Bool>{get}
    
    var onError : PublishSubject<String> {get}

}

protocol PostDetialsViewModelProtocol  {
    var outputs : PostDetialsViewModelOutput{get}
    
    func getPostComments()
}

class PostDetialsViewModel : PostDetialsViewModelProtocol , PostDetialsViewModelEvents {

    private let disposeBag = DisposeBag()
    
    var info : BehaviorSubject<PostViewData>
    
    var comments: BehaviorSubject<[CommentViewData]>
    
    var outputs: PostDetialsViewModelOutput {self}
    
     var onError: PublishSubject<String>
     
     var isRefreshing : BehaviorSubject<Bool>
    
    init(details : PostViewData) {
        info = BehaviorSubject<PostViewData>(value: details)
        comments = BehaviorSubject(value: [])
        isRefreshing = BehaviorSubject(value: false)
        onError = PublishSubject()
    }
    
    func getPostComments() {
        guard let postId = try? info.value().id  else {return}
        isRefreshing.on(.next(true))
        let result =  ApiService.shared.loadPostComments(id: postId)
        result.subscribe({ event in
            if let item = event.element  {
                let items = item.map{CommentViewData(info: $0)}
                self.comments.onNext(items)
                self.isRefreshing.on(.next(false))
            }
            else {
                self.onError.onNext("Something went wrong")
            }
        }).disposed(by: disposeBag)
    }
    
}
