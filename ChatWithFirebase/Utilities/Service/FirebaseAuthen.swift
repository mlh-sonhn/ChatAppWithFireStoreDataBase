//
//  AuthenService.swift
//  ChatWithFirebase
//
//  Created by SonHoang on 7/23/19.
//  Copyright © 2019 Example. All rights reserved.
//

import FirebaseAuth
import RxSwift
import RxCocoa

class FirebaseAuthen: AuthenService {
    func login(with email: String, password: String) -> Observable<AuthenResultHandler> {
        return Observable.create({ observable -> Disposable in
            Auth.auth().signIn(withEmail: email, password: password, completion: { (result, error) in
                if let error = error {
                    observable.onNext(.failed(error.localizedDescription))
                }
                if let result = result {
                    observable.onNext(.success(result.user))
                }
                observable.onCompleted()
            })
            return Disposables.create()
        })
    }
    
    func logOut() -> Observable<Bool> {
        return Observable.create({ observable -> Disposable in
            do {
                try Auth.auth().signOut()
                observable.onNext(true)
                observable.onCompleted()
            } catch (let error) {
                print(error.localizedDescription)
                observable.onNext(false)
                observable.onCompleted()
            }
            return Disposables.create()
        })
    }
    
    static func isAlreadyLogin() -> Bool {
        return Auth.auth().currentUser != nil
    }
}
