//
//  Business.swift
//  MeetShoppers
//
//  Created by Kelvin Lui on 4/14/18.
//  Copyright © 2018 KevinVuNguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

struct BusinessKey {
    static let name = "name"
    static let imageURL = "image_url"
    static let location = "location"
    static let distance = "distance"
}

struct LocationKey {
    static let address = "address"
    static let neighborhoods = "neighborhoods"
}

class Business: NSObject {
    let name: String?
    let address: String?
    let imageURL: URL?
    let distance: String?
    
    init(dictionary: JSON) {
        name = dictionary[BusinessKey.name].string
        
        let imageURLString = dictionary[BusinessKey.imageURL].string
        if imageURLString != nil {
            imageURL = URL(string: imageURLString!)!
        } else {
            imageURL = nil
        }
        
        let location = dictionary[BusinessKey.location] as? NSDictionary
        var address = ""
        if location != nil {
            let addressArray = location![LocationKey.address] as? NSArray
            if addressArray != nil && addressArray!.count > 0 {
                address = addressArray![0] as! String
            }
            
            let neighborhoods = location![LocationKey.neighborhoods] as? NSArray
            if neighborhoods != nil && neighborhoods!.count > 0 {
                if !address.isEmpty {
                    address += ", "
                }
                address += neighborhoods![0] as! String
            }
        }
        self.address = address
        
        let distanceMeters = dictionary[BusinessKey.distance] as? NSNumber
        if distanceMeters != nil {
            let milesPerMeter = 0.000621371
            distance = String(format: "%.2f mi", milesPerMeter * distanceMeters!.doubleValue)
        } else {
            distance = nil
        }
    }
    
    class func businesses(json: JSON) -> [Business] {
        var businesses = [Business]()
        let businessDictionary = json["businesses"]
        for i in 0..<businessDictionary.count {
            let business = Business(dictionary: businessDictionary[i])
            businesses.append(business)
        }
        
        return businesses
    }
}
