//
//  YelpAPIRouter.swift
//  MeetShoppers
//
//  Created by Kelvin Lui on 4/14/18.
//  Copyright © 2018 KevinVuNguyen. All rights reserved.
//

import Alamofire

enum YelpAPIRouter: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: "https://api.yelp.com/v3/")!
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .search(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        }
        return urlRequest
    }
    
    case search(parameters: Parameters)

    var method: HTTPMethod {
        switch self {
        case .search(parameters: _):
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .search(parameters: _):
            return "businesses/search"
        }
    }
}
