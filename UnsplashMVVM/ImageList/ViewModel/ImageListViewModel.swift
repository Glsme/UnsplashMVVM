//
//  ImageListViewModel.swift
//  UnsplashMVVM
//
//  Created by Seokjune Hong on 2022/10/25.
//

import Foundation
import RxSwift

class ImageListViewModel {
    var photoList = PublishSubject<SearchPhoto>()
    
    func requestSearchPhoto(query: String) {
        print(#function)
        APIService.searchPhoto(query: query) { photo, status, error in
            guard let photo = photo else { return }
            self.photoList.onNext(photo)
        }
    }
}
