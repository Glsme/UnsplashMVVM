//
//  APIRouter.swift
//  UnsplashMVVM
//
//  Created by Seokjune Hong on 2022/10/30.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {
    case get(query: String, page: Int)
    
    var baseURL: URL {
        return URL(string: "https://api.unsplash.com/search")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .get: return .get
        }
    }
    
    var path: String {
        switch self {
        case .get(let query, let page): return "photos?query=\(query)&page=\(page)" //연관값으로 사용
        }
    }
   
    var headers: HTTPHeaders {
        return ["Authorization": APIKey.authorization]
    }
    
    func asURLRequest() throws -> URLRequest {
//        let url = baseURL.appendingPathComponent(path, conformingTo: .url)
        let url = URL(string: "\(baseURL)/\(path)")!
        var request = URLRequest(url: url)
        request.method = method
        request.headers = headers
        
        return request
    }
}
