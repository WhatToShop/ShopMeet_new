//
//  DetailedBusiness.swift
//  MeetShoppers
//
//  Created by Kelvin Lui on 5/12/18.
//  Copyright © 2018 KevinVuNguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class DetailedBusiness: Business {
    
    struct APIDetailedBusinessKey {
        static let hours = "hours"
    }
    
    struct HourDictionaryKey {
        static let hoursType = "hours_type" // ex. REGULAR
        static let dayHours = "open"    // An array of hours from Monday to Sunday (0-6)
        static let isOpenNow = "is_open_now"
    }
    
    var endTimes: [String]?
    var startTimes: [String]?
    var isOpenNow: Bool?
    var hoursType: String?
    
    override init(dictionary: JSON) {
        super.init(dictionary: dictionary)
        
        let hoursDictionary = dictionary[APIDetailedBusinessKey.hours].arrayValue[0]
        if let isOpenNow = hoursDictionary[HourDictionaryKey.isOpenNow].bool { self.isOpenNow = isOpenNow }
        if let hoursType = hoursDictionary[HourDictionaryKey.hoursType].string { self.hoursType = hoursType}
        
        if let dayHours = hoursDictionary[HourDictionaryKey.dayHours].array {
            endTimes = []
            startTimes = []
            for hour in dayHours {
                startTimes!.append(formattedHour(time: hour["start"].stringValue))
                endTimes!.append(formattedHour(time: hour["end"].stringValue))
            }
        }
    }
    
    private func formattedHour(time: String) -> String {
        if time == "1200" {
            return "noon"
        } else if time == "0000" {
            return "midnight"
        }
        
        let cutoffIndex = time.index(time.startIndex, offsetBy: 2)
        let postfix = Int(String(time[..<cutoffIndex]))! >= 12 ? "PM" : "AM"
        
        return time[..<cutoffIndex] + ":" + time[cutoffIndex...] + " \(postfix)"
    }
}



































