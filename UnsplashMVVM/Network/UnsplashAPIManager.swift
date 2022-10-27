//
//  UnsplashAPIManager.swift
//  UnsplashMVVM
//
//  Created by Seokjune Hong on 2022/10/27.
//

import Foundation
import Alamofire

class UnsplashAPIManager {
    static let shared = UnsplashAPIManager()
    
    private init() { }
    
    func requsetUnsplashPhto(query: String, completionHandler: @escaping (SearchPhoto?, Error?) -> Void) {
        let url = APIKey.searchURL + query
        let header: HTTPHeaders = ["Authorization": APIKey.authorization]
        
        AF.request(url, method: .get, headers: header).responseDecodable(of: SearchPhoto.self) { responce in
            switch responce.result {
            case .success(let value): completionHandler(value, nil)
            case .failure(let error): completionHandler(nil, error)
            }
        }
    }
}

// urlrequestconvertible
// escaping closure -> Result Type

