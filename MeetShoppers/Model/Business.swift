//
//  Business.swift
//  MeetShoppers
//
//  Created by Kelvin Lui on 4/14/18.
//  Copyright © 2018 KevinVuNguyen. All rights reserved.
//

import SwiftyJSON
import UIKit
import Firebase

struct APIBusinessKey {
    static let name = "name"
    static let imageURL = "image_url"
    static let location = "location"
    static let distance = "distance"
    static let coordinates = "coordinates"
    static let id = "id"
}

struct CustomizedBusinessKey {
    static let likes = "likes"
    static let likeCount = "likeCount"
    static let comments = "comments" // Returns a JSON object of comments
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
    var hasFinishedInitialization = false   // Identifies whether initialization of fields have been completed
    
    let name: String?
    let address: String?
    let imageURL: URL?
    var distance: String?
    let longitude: Float?
    let latitude: Float?
    let id: String?
    var likeCount: Int? {
        didSet {
            guard let id = id else { return }
            if !hasFinishedInitialization { return }
            if likeCount! < 0 { likeCount = 0 } // Some safety protocol that may avoid bugs
            Database.database().reference().child("businesses").child(id).child("likeCount").setValue(likeCount!)
        }
    }
    
    var likes: [String: Any]? {
        didSet {
//            guard let id = id else { return }
//            let uid = Auth.auth().currentUser!.uid
//            Database.database().reference().child("businesses").child(id).child("likes").child(uid)
        }
    }
    
    init(dictionary: JSON) {
        // Get data from Yelp API
        name = dictionary[APIBusinessKey.name].string
        id = dictionary[APIBusinessKey.id].string
        
        let imageURLString = dictionary[APIBusinessKey.imageURL].string
        if imageURLString != nil {
            imageURL = URL(string: imageURLString!)!
        } else {
            imageURL = nil
        }
        
        var latitude: Float = 0
        var longitude: Float = 0
        if let coordinates = dictionary[APIBusinessKey.coordinates].dictionaryObject{
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
        if let location = dictionary[APIBusinessKey.location].dictionaryObject {
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
        
        let distanceMeters = dictionary[APIBusinessKey.distance].number
        if distanceMeters != nil {
            let milesPerMeter = 0.000621371
            distance = String(format: "%.2f mi", milesPerMeter * distanceMeters!.doubleValue)
        } else {
            distance = nil
        }
        
        // Get data from customized realtime database for businesses
//        let businessRef = Database.database().reference().child("businesses").child(id!)
//        businessRef.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
//            if !snapshot.hasChild("likeCount") {
//                businessRef.child("likeCount").setValue(0)
//                self.likeCount = 0
//            }
//        }) { (error) in
//            debugPrint(error)
//        }
        likeCount = 0   // TODO
        likes = [:] // TODO
        
        hasFinishedInitialization = true
    }
    
    func observeLikeStatus(by uid: String, completion: @escaping (_ result: Bool) -> ()) -> Void {
        let ref = Database.database().reference().child("businesses").child(uid)
        let result = true
        ref.observeSingleEvent(of: DataEventType.value) { (snapshot) in
//            completion(snapshot.hasChild(uid))
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
