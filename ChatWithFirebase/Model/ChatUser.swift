//
//  ChatUser.swift
//  ChatWithFirebase
//
//  Created by SonHoang on 7/24/19.
//  Copyright © 2019 Example. All rights reserved.
//

import ObjectMapper
struct ChatUser: Mappable {
    var id: String = ""
    var email: String = ""
    var fullName: String = ""
    var phone: String = ""
    var avatar: String = ""
    var isOnline: Bool = false
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        id           <- map["id"]
        email        <- map["email"]
        fullName     <- map["fullName"]
        phone        <- map["phone"]
        avatar       <- map["avatar"]
        isOnline     <- map["isOnline"]
    }
}
