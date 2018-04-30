//
//  BusinessComment.swift
//  MeetShoppers
//
//  Created by Kelvin Lui on 4/29/18.
//  Copyright © 2018 KevinVuNguyen. All rights reserved.
//

import UIKit

struct CommentKey {
    static let text = "text"
    static let fromId = "fromId"
    static let timestamp = "timestamp"
}

class BusinessComment {
    var text: String?
    var fromId: String?
    var timestamp: Double?
    
    init(comment: NSDictionary) {
        if let text = comment[CommentKey.text] as? String {
            self.text = text
        }
        
        if let fromId = comment[CommentKey.fromId] as? String {
            self.fromId = fromId
        }
        
        if let timestamp = comment[CommentKey.timestamp] as? Double {
            self.timestamp = timestamp
        }
    }
}
