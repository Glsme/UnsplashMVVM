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
    
//    func requsetUnsplashPhoto(query: String, page: Int, completionHandler: @escaping (SearchPhoto?, Error?) -> Void) {
//        let url = APIKey.searchURL + query + "&page=\(page)"
//        let header: HTTPHeaders = ["Authorization": APIKey.authorization]
//        
//        //상태 코드 정리: 열거형 (ex: 콜수 다 찾을 때 등)
//        AF.request(url, method: .get, headers: header).responseDecodable(of: SearchPhoto.self) { response in
//            
//            switch response.result {
//            case .success(let value): completionHandler(value, nil)
//            case .failure(let error): completionHandler(nil, error)
//            }
//        }
//    }
    
    func requestUnsplashPhotoWithAPIRouter(router: APIRouter, completionHandler: @escaping(Result<SearchPhoto, AFError>) -> Void) {
        AF.request(router).responseDecodable(of: SearchPhoto.self) { response in
            completionHandler(response.result)
        }
    }
}

// urlrequestconvertible
// escaping closure -> Result Type

