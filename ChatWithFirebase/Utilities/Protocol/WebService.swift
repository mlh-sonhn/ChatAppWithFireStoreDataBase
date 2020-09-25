//
//  Service.swift
//  ChatWithFirebase
//
//  Created by SonHoang on 7/28/19.
//  Copyright © 2019 Example. All rights reserved.
//

import Foundation
import RxSwift

protocol WebServices {
    var service: WebService { get }
}

protocol WebService {
    func createUser(with fullName: String, phoneNumber: String, email: String, password: String) -> Observable<(Bool, String)>
    func sendMessage(to user: ChatUser, message: String) -> Observable<(Bool, String)>
    func getListUser() -> Observable<[ChatUser]>
    func getListMessage(inConverationWith receiver: ChatUser?, roomId: String, roomType: RoomType) -> Observable<[ChatMessage]>
}
