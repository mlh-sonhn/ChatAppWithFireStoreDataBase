//
//  FirestoreService.swift
//  ChatWithFirebase
//
//  Created by SonHoang on 7/30/19.
//  Copyright © 2019 Example. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseFirestore


class FirestoreService: DatabaseService {
    func addObserver(to roomId: String) -> Observable<ChatMessage> {
        return Observable.create({ observalbe -> Disposable in
            let roomRef = Firestore.firestore().collection("rooms").document(roomId).addSnapshotListener({ (snapShot, error) in
                do {
                    if let error = error {
                        throw error
                    }
                    if let data = snapShot?.data() {
                        if let lastMessageJson = data["lastMessage"] as? [String: Any], let chatMessage = ChatMessage(JSON: lastMessageJson) {
                            observalbe.onNext(chatMessage)
                        } else {
                            throw NSError(domain: "Can not get data", code: 9999, userInfo: nil)
                        }
                    } else {
                        throw NSError(domain: "Can not get data", code: 9999, userInfo: nil)
                    }
                } catch let error {
                    observalbe.onError(error)
                    observalbe.onCompleted()
                }
            })
            return Disposables.create {
                roomRef.remove()
            }
        })
    }
}
