//
//  Message.swift
//  MeetShoppers
//
//  Created by Kelvin Lui on 4/23/18.
//  Copyright © 2018 KevinVuNguyen. All rights reserved.
//

import UIKit

class Message: NSObject {
    var fromId: String?
    var timestamp: Double?
    var text: String?
    var toId: String?
    
    init(dictionary: NSDictionary) {
        fromId = dictionary["fromId"] as? String
        timestamp = dictionary["timestamp"] as? Double
        text = dictionary["text"] as? String
    }
}
