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

    func requestPhoto(query: String) {
        UnsplashAPIManager.shared.requsetUnsplashPhto(query: query) { [weak self] value, error in
            guard let value = value else { return }
            self?.photoList.onNext(value)
        }
    }
}
