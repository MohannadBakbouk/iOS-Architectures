//
//  PostsViewModel.swift
//  MVVMArchitectureWithRxswift
//
//  Created by Mohannad on 12/28/21.
//
import Foundation
import RxSwift

typealias PostsViewModelEvents = PostsViewModelOutput & PostViewModelInput & PostViewModelInternal

protocol PostsViewModelOutput {
    var isLoading : BehaviorSubject<Bool> {get}
    var loadingMore : BehaviorSubject<Bool>{get}
    var posts : BehaviorSubject<[PostViewData]> {get}
}

protocol PostViewModelInput {
    var reachedBottomTrigger : PublishSubject<Void> {get}
}

protocol PostViewModelInternal {
    var rawPosts : PublishSubject<[Post]> {get}
}

protocol PostsViewModelProtocol {
    
    var outputs : PostsViewModelOutput { get }
    var inputs : PostViewModelInput{get}
    var internals : PostViewModelInternal {get}
    
    func subscribingToReachedBottomTrigger()
    func subscribingToRawPosts()
    func loadPosts()
}


class PostsViewModel  :  PostsViewModelProtocol  , PostsViewModelEvents  {
    
    private let disposeBag = DisposeBag()
    
    var outputs: PostsViewModelOutput {self}
    
    var inputs: PostViewModelInput {self}
    
    var internals : PostViewModelInternal {self}
   
    // MARK: Outputs
    
    var posts : BehaviorSubject<[PostViewData]>
    
    var isLoading = BehaviorSubject<Bool>(value: false)
    
    var loadingMore = BehaviorSubject<Bool>(value: false)
    
    //MARK: Inputs
    
    var reachedBottomTrigger : PublishSubject<Void>
    
    var currentPage = 1
    
    var pageCount = 8
    
    //MARK: Internals
    
    var rawPosts: PublishSubject<[Post]>
    
    init() {
        posts =  BehaviorSubject<[PostViewData]>(value: [])
        reachedBottomTrigger = PublishSubject<Void>()
        rawPosts = PublishSubject()
        subscribingToReachedBottomTrigger()
        subscribingToRawPosts()
    }
    
    func loadPosts(){
        
        if currentPage == 1 {
          isLoading.onNext(true)
        }
        
        ApiService.shared.loadPosts(page: currentPage)
       .bind(to: internals.rawPosts)
       .disposed(by: disposeBag)
    }
    
    func subscribingToReachedBottomTrigger(){
         reachedBottomTrigger
        .filter{(self.currentPage < self.pageCount)}
        .filter{ ((try? !self.loadingMore.value() ?? false)) as! Bool}
        .subscribe { event in
            self.loadingMore.onNext(true)
            self.currentPage += 1
            self.loadPosts()
        }.disposed(by: disposeBag)
    }
    
    func subscribingToRawPosts(){
        
       rawPosts.map{ $0.map {PostViewData(info: $0) }}
      .subscribe(onNext : { [weak self] in
         guard let self = self else {return}
         if  var items = $0 as? [PostViewData]{
              if self.currentPage > 1 , var oldItems = try? self.posts.value() {
                 oldItems.append(contentsOf: items)
                 items = oldItems
              }
             self.posts.onNext(items)
             self.isLoading.onNext(false)
             self.loadingMore.onNext(false)
         }
       }).disposed(by: disposeBag)
    }
}
