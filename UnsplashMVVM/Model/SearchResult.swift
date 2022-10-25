//
//  SearchResult.swift
//  UnsplashMVVM
//
//  Created by Seokjune Hong on 2022/10/25.
//

import Foundation

struct SearchResult: Codable, Hashable {
    let id: String
    let urls: Urls
    let likes: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case urls, likes
    }
}
