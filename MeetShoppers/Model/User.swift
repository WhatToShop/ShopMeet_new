//
//  User.swift
//  MeetShoppers
//
//  Created by Kelvin Lui on 4/13/18.
//  Copyright © 2018 KevinVuNguyen. All rights reserved.
//
import UIKit

class User: NSObject {
    var uid: String? {
        didSet {
            profileImageUrl = "users/\(uid!)/profileImage/profileImage.jpg"
        }
    }
    
    var name: String?
    var email: String?
    var profileImageUrl: String?

    init(dictionary: NSDictionary) {
        uid = dictionary["name"] as? String
        email = dictionary["email"] as? String
    }
}
