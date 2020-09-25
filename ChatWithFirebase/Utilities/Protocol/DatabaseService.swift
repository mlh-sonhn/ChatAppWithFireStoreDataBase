//
//  DatabaseService.swift
//  ChatWithFirebase
//
//  Created by SonHoang on 7/30/19.
//  Copyright © 2019 Example. All rights reserved.
//

import Foundation
import RxSwift

protocol DBServices {
    var dbService: DatabaseService { get }
}

protocol DatabaseService {
    func addObserver(to roomId: String) -> Observable<ChatMessage>
}
