//
//  ImageListViewModel.swift
//  UnsplashMVVM
//
//  Created by Seokjune Hong on 2022/10/25.
//

import Foundation
import RxSwift

class ImageListViewModel {
    var photoList = BehaviorSubject<SearchPhoto>(value: SearchPhoto(total: 0, totalPages: 0, results: []))
    
    func requestSearchPhoto(query: String) {
        print(#function)
        APIService.searchPhoto(query: query) { photo, status, error in
            guard let photo = photo else { return }
            self.photoList.onNext(photo)
        }
    }
}
