//
//  UserWebservice.swift
//  ChatWithFirebase
//
//  Created by SonHoang on 7/28/19.
//  Copyright © 2019 Example. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseAuth

protocol SignUpServiceProtocol: WebServices, AuthenServices {
    func createUser(with fullName: String, phoneNumber: String, email: String, password: String) -> Observable<SignUpResultHandler>
}

enum SignUpResultHandler {
    case failed(String)
    case success(User)
}

class SignUpService: SignUpServiceProtocol {
    var authen: AuthenService
    var service: WebService
    
    init(_ injectService: WebService, injectAuthen: AuthenService) {
        service = injectService
        authen = injectAuthen
    }

    func createUser(with fullName: String, phoneNumber: String, email: String, password: String) -> Observable<SignUpResultHandler> {
        return service.createUser(with: fullName, phoneNumber: phoneNumber, email: email, password: password)
            .flatMap({ [weak self] (isSuccess, message) -> Observable<SignUpResultHandler> in
                guard let self = self, isSuccess else { return .just(.failed(message)) }
                return self.authen.login(with: email, password: password).flatMap({ handler -> Observable<SignUpResultHandler> in
                    switch handler {
                    case .failed(let message):
                        print(message)
                        return .just(.failed(message))
                    case .success(let user):
                        return .just(.success(user))
                    }
                })
            })
    }

}
