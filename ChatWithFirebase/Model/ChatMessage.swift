//
//  ChatMessage.swift
//  ChatWithFirebase
//
//  Created by SonHoang on 7/24/19.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit
import ObjectMapper

enum MessageType {
    case text
    case image
    case link
}

struct ChatMessage: Mappable {
    var type: MessageType = .text
    var imageUrl: String = ""
    var message: String = ""
    var receiverId: String = ""
    var senderId: String = ""
    var status: String = ""
    var timeStamp: TimeInterval = Date().timeIntervalSince1970
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        imageUrl        <- map["imageUrl"]
        message         <- map["message"]
        receiverId      <- map["receiverId"]
        senderId        <- map["senderId"]
        status          <- map["status"]
        timeStamp       <- map["timeStamp"]
        
        type = !imageUrl.isEmpty ? .image : message.isValidURL ? .link : .text
    }
    
}

extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}
