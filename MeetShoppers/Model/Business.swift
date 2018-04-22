//
//  Business.swift
//  MeetShoppers
//
//  Created by Kelvin Lui on 4/14/18.
//  Copyright © 2018 KevinVuNguyen. All rights reserved.
//

import SwiftyJSON

struct BusinessKey {
    static let name = "name"
    static let imageURL = "image_url"
    static let location = "location"
    static let distance = "distance"
    static let coordinates = "coordinates"
    static let id = "id"
}

struct CoordinateKey {
    static let latitude = "latitude"
    static let longitude = "longitude"
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
    let longitude: Float?
    let latitude: Float?
    let id: String?
    
    init(dictionary: JSON) {
        name = dictionary[BusinessKey.name].string
        id = dictionary[BusinessKey.id].string
        
        let imageURLString = dictionary[BusinessKey.imageURL].string
        if imageURLString != nil {
            imageURL = URL(string: imageURLString!)!
        } else {
            imageURL = nil
        }
        
        var latitude: Float = 0
        var longitude: Float = 0
        if let coordinates = dictionary[BusinessKey.coordinates].dictionaryObject{
            if let latitudeNumber = coordinates[CoordinateKey.latitude] as? NSNumber {
                latitude = latitudeNumber.floatValue
            }
            if let longitudeNumber = coordinates[CoordinateKey.longitude] as? NSNumber {
                longitude = longitudeNumber.floatValue
            }
        }
        self.latitude = latitude
        self.longitude = longitude
        
        var address = ""
        if let location = dictionary[BusinessKey.location].dictionaryObject {
            if let addressArray = location[LocationKey.address] as? NSArray {
                address = addressArray[0] as! String
            }
            
            if let neighborhoods = location[LocationKey.neighborhoods] as? NSArray {
                if !address.isEmpty {
                    address += ", "
                }
                address += neighborhoods[0] as! String
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
