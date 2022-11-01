//
//  ImageListViewModel.swift
//  UnsplashMVVM
//
//  Created by Seokjune Hong on 2022/10/25.
//

import Foundation
import RxSwift
import RxCocoa

class ImageListViewModel: CommonViewModel {
    
    struct Input {
        let searchText: ControlProperty<String?>
        let prefetchItems: ControlEvent<[IndexPath]>
    }
    
    struct Output {
        let searchText: Observable<String>
        let prefetchItems: Observable<Int>
    }
    
    func transform(input: Input) -> Output {
        let searchText = input.searchText
            .orEmpty
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
        
        let prefetchItems = input.prefetchItems
            .compactMap { $0.last?.item }
        
        return Output(searchText: searchText, prefetchItems: prefetchItems)
    }
    
    let photoList = BehaviorSubject(value: SearchPhoto(total: 0, totalPages: 0, results: []))
    var currentPage = 1

    func requestPhoto(query: String) {
        UnsplashAPIManager.shared.requestUnsplashPhotoWithAPIRouter(router: APIRouter.get(query: query, page: 1)) { [weak self] result in
            switch result {
            case .success(let value): self?.photoList.onNext(value)
            case .failure(let error): print("error:: \(error)")
            }
            
        }
    }
    
    func requestPhotoPagination(query: String, index: Int) {
        let list = try! photoList.value()
        guard currentPage <= list.totalPages else { return }
        guard index == (list.results.count) - 2 else { return }
        
        UnsplashAPIManager.shared.requestUnsplashPhotoWithAPIRouter(router: APIRouter.get(query: query, page: currentPage)) { [weak self]  result in
            guard let self = self else { return }
            
            switch result {
            case .success(let value):
                if self.currentPage == 1 {
                    self.photoList.onNext(value)
                    self.currentPage += 1
                } else {
                    var photoListArray = list
                    photoListArray.results.append(contentsOf: value.results)
                    
                    self.photoList.onNext(photoListArray)
                    self.currentPage += 1
                }
            case .failure(let error):
                print("error:: \(error)")
            }
        }
    }
}
