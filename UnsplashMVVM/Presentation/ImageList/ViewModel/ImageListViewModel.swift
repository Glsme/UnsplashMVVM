//
//  ImageListViewModel.swift
//  UnsplashMVVM
//
//  Created by Seokjune Hong on 2022/10/25.
//

import Foundation
import RxSwift

class ImageListViewModel {
    
    let photoList = BehaviorSubject(value: SearchPhoto(total: 0, totalPages: 0, results: []))
    var currentPage = 1

    func requestPhoto(query: String) {
        UnsplashAPIManager.shared.requsetUnsplashPhto(query: query, page: 1) { [weak self] value, error in
            guard let value = value else { return }
            self?.photoList.onNext(value)
        }
    }
    
    func requestPhotoPagination(query: String, index: Int) {
        let list = try! photoList.value()
        guard currentPage <= list.totalPages else { return }
        guard index == (list.results.count) - 2 else { return }
        
        UnsplashAPIManager.shared.requsetUnsplashPhto(query: query, page: currentPage) { [weak self]  value, error in
            guard let self = self else { return }
            guard let value = value else { return }
            
            if self.currentPage == 1 {
                self.photoList.onNext(value)
                self.currentPage += 1
            } else {
                var photoListArray = list
                photoListArray.results.append(contentsOf: value.results)
                
                self.photoList.onNext(photoListArray)
                self.currentPage += 1
            }
        }
    }
}
