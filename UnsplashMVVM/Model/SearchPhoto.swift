//
//  SearchPhoto.swift
//  UnsplashMVVM
//
//  Created by Seokjune Hong on 2022/10/25.
//

import Foundation

struct SearchPhoto: Codable, Hashable {
    let total, totalPages: Int
    let results: [SearchResult]
    
    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}
