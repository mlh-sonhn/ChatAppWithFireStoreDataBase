//
//  ChatRoom.swift
//  ChatWithFirebase
//
//  Created by SonHoang on 7/24/19.
//  Copyright © 2019 Example. All rights reserved.
//

import Foundation

enum RoomType: Int {
    case group
    case single
}

struct ChatRoom {
    var id: String = ""
    var name: String = ""
    var roomType: RoomType = .single
    var admins: [String] = []
    var users: [String] = []
    var lastMessage: ChatMessage? = nil
}
