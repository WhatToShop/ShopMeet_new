//
//  YelpAPIClient.swift
//  MeetShoppers
//
//  Created by Kelvin Lui on 4/12/18.
//  Copyright © 2018 KevinVuNguyen. All rights reserved.
//
import SwiftyJSON
import Alamofire
import AlamofireObjectMapper

public class YelpAPIClient: NSObject {

    private let apiKey: String!
    private lazy var manager: Alamofire.SessionManager = {
        if let apiKey = self.apiKey, apiKey != "" {
            var headers = Alamofire.SessionManager.defaultHTTPHeaders
            headers["Authorization"] = "Bearer \(apiKey)"
            let configuration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = headers
            return Alamofire.SessionManager(configuration: configuration)
        } else {
            return Alamofire.SessionManager()
        }
    }()
    
    public func searchBusinesses(latitude: Double?, longitude: Double?, radius: Int?, completionHandler: @escaping (_ jsonResponse: JSON) -> ()) {
        assert((latitude != nil && longitude != nil), "Input latitude or longitude must not be null.")
        assert(radius != nil, "Input radius can not be null.")
        
        if self.isAuthenticated() {
            let param: Parameters = [
                "latitude": latitude,
                "longitude": longitude,
                "radius": radius
            ]
            
            self.manager.request(YelpAPIRouter.search(parameters: param)).responseJSON { (response) in
                switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    completionHandler(json)
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
                
                self.manager.session.finishTasksAndInvalidate() // Retains manager's instance
            }
        }
    }
    
    public init(apiKey: String!) {
        assert((apiKey != nil && apiKey != ""), "An API key is required to query the Yelp Fusion API.")
        self.apiKey = apiKey
        super.init()
    }
    
    public func isAuthenticated() -> Bool {
        if let _ = self.apiKey, self.apiKey != "" {
            return true
        }
        return false
    }
}










