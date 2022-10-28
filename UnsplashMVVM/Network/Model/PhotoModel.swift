//
//  SearchPhoto.swift
//  UnsplashMVVM
//
//  Created by Seokjune Hong on 2022/10/27.
//

import Foundation

struct SearchPhoto: Codable, Hashable {
    let total, totalPages: Int
    var results: [PhotoResults]

    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}

// MARK: - Result
struct PhotoResults: Codable, Hashable {
    let id: String
    let urls: Urls
    let likes: Int
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case urls, likes
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Urls
struct Urls: Codable, Hashable {
    let raw, full, regular, small: String
    let thumb, smallS3: String

    enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
        case smallS3 = "small_s3"
    }
}
