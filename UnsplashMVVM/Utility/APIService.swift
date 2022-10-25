//
//  APIService.swift
//  UnsplashMVVM
//
//  Created by Seokjune Hong on 2022/10/25.
//

import Foundation
import Alamofire

class APIService {
    static func searchPhoto(query: String, completion: @escaping (SearchPhoto?, Int?, Error?) -> Void) {
        let url = "\(APIKey.searchURL)\(query)"
        let header: HTTPHeaders = ["Authorization": APIKey.authorization]
        
        AF.request(url, method: .get, headers: header).responseDecodable(of: SearchPhoto.self) { respose in
            let statusCode = respose.response?.statusCode
            
            switch respose.result {
            case .success(let value): completion(value, statusCode, nil)
            case .failure(let error): completion(nil, statusCode, error)
            }
        }
    }
    
    private init() { }
}
