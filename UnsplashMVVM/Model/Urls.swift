//
//  Urls.swift
//  UnsplashMVVM
//
//  Created by Seokjune Hong on 2022/10/25.
//

import Foundation

struct Urls: Codable, Hashable {
    let raw, full, regular, small: String
    let thumb, smallS3: String

    enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
        case smallS3 = "small_s3"
    }
}
