//
//  APIRouter.swift
//  UnsplashMVVM
//
//  Created by Seokjune Hong on 2022/10/30.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    case get, post
    
    var baseURL: URL {
        return URL(string: "https://httpbin.org")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .get: return .get
        case .post: return .post
        }
    }
    
    var path: String {
        switch self {
        case .get: return "get"
        case .post: return "post"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        
        return request
    }
}
