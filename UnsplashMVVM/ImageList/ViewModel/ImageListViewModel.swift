//
//  ImageListViewModel.swift
//  UnsplashMVVM
//
//  Created by Seokjune Hong on 2022/10/25.
//

import Foundation
import RxSwift

class ImageListViewModel {

    func requestPhoto(query: String) {
        UnsplashAPIManager.shared.requsetUnsplashPhto(query: query) { value, error in
            guard let value = value else { return }
            print(value)
        }
    }
}
