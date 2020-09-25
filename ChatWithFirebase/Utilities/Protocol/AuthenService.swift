//
//  Authen.swift
//  ChatWithFirebase
//
//  Created by SonHoang on 7/28/19.
//  Copyright © 2019 Example. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseAuth

protocol AuthenServices {
    var authen: AuthenService { get }
}

enum AuthenResultHandler {
    case success(User)
    case failed(String)
}

protocol AuthenService {
    func login(with email: String, password: String) -> Observable<AuthenResultHandler>
    func logOut() -> Observable<Bool>
}
