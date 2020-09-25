//
//  WebSerivce.swift
//  ChatWithFirebase
//
//  Created by SonHoang on 7/23/19.
//  Copyright © 2019 Example. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseFunctions
import SVProgressHUD

enum POSTCloudFucntionHandler {
    case success(String)
    case failed(String)
}

enum GETCloudFucntionHandler {
    case success([String: Any])
    case failed(String)
}

protocol CloudFunctionServices {
    var cloudService: CloudFunctionService { get }
}

protocol CloudFucntionProtocol {
    func callPostApi(api: ApiName, params: [String: Any]) -> Observable<POSTCloudFucntionHandler>
    func callGetApi(api: ApiName, params: [String: Any]) -> Observable<GETCloudFucntionHandler>
}

extension CloudFucntionProtocol {
    func callPostApi(api: ApiName, params: [String: Any]) -> Observable<POSTCloudFucntionHandler> {
        let postFunction = Functions.functions().httpsCallable(api.rawValue)
        postFunction.timeoutInterval = 5
        return Observable.create({ observable -> Disposable in
            postFunction.call(params) { (result, error) in
                if let error = error {
                    observable.onNext(.failed(error.localizedDescription))
                    observable.onCompleted()
                } else if let result = result?.data as? [String: Any] {
                    if let statusCode = result["statusCode"] as? Int, statusCode == 200 {
                        observable.onNext(.success((result["message"] as? String) ?? "Success!"))
                        observable.onCompleted()
                    } else {
                        observable.onNext(.failed((result["message"] as? String) ?? "Something error!"))
                        observable.onCompleted()
                    }
                } else {
                    observable.onNext(.failed("Something error!"))
                    observable.onCompleted()
                }
            }
            return Disposables.create()
        })
    }
    
    func callGetApi(api: ApiName, params: [String: Any]) -> Observable<GETCloudFucntionHandler> {
        let postFunction = Functions.functions().httpsCallable(api.rawValue)
        postFunction.timeoutInterval = 5
        return Observable.create({ observable -> Disposable in
            postFunction.call(params) { (result, error) in
                if let error = error {
                    observable.onNext(.failed(error.localizedDescription))
                    observable.onCompleted()
                } else if let result = result?.data as? [String: Any] {
                    if let statusCode = result["statusCode"] as? Int, statusCode == 200 {
                        observable.onNext(.success(result))
                        observable.onCompleted()
                    } else {
                        observable.onNext(.failed((result["message"] as? String) ?? "Something error!"))
                        observable.onCompleted()
                    }
                }
            }
            return Disposables.create()
        })
    }
}


class CloudFunctionService: CloudFucntionProtocol, WebService {
    func createUser(with fullName: String, phoneNumber: String, email: String, password: String) -> Observable<(Bool, String)> {
        let params: [String: Any] = ["fullName": fullName, "phoneNumber": phoneNumber, "email": email, "password": password]
        return callPostApi(api: .createUser, params: params).flatMap({ handler -> Observable<(Bool, String)> in
            switch handler {
            case .success(let successMessage):
                return .just((true, successMessage))
            case .failed(let failedMessage):
                return .just((false, failedMessage))
            }
        })
    }
    
    func sendMessage(to user: ChatUser, message: String) -> Observable<(Bool, String)> {
        let params: [String : Any] = ["receiverId": user.id, "imageUrl": "", "message": message]
        return callPostApi(api: .sendSingleMessage, params: params).flatMap({ handler -> Observable<(Bool, String)> in
            switch handler {
            case .failed(let message):
                return .just((false, message))
            case .success(let message):
                return .just((true, message))
            }
        })
    }
    
    func getListUser() -> Observable<[ChatUser]> {
        return callGetApi(api: .listUser, params: [:])
            .flatMap({ handler -> Observable<[ChatUser]> in
                switch handler {
                case .failed(let message):
                    print(message)
                    return .just([])
                case .success(let resultDict):
                    var users: [ChatUser] = []
                    if let usersJson = resultDict["body"] as? [[String: Any]] {
                        users = usersJson.compactMap { ChatUser(JSON: $0) }
                    }
                    return .just(users)
                }
            })
    }
    
    func getListMessage(inConverationWith receiver: ChatUser?, roomId: String, roomType: RoomType) -> Observable<[ChatMessage]> {
        var params: [String : Any] = ["roomType": roomType.rawValue]
        if !roomId.isEmpty {
            params["roomId"] = roomId
        }
        if let receiver = receiver {
            params["receiverId"] = receiver.id
        }
        return callGetApi(api: .allMessageInRoom, params: params).flatMap({ handler -> Observable<[ChatMessage]> in
            switch handler {
            case .failed(let message):
                print("Error \(message)")
                return .just([])
            case .success(let resultDict):
                var mesasges: [ChatMessage] = []
                if let messageJson = resultDict["body"] as? [[String: Any]] {
                    mesasges.append(contentsOf: messageJson.compactMap { ChatMessage(JSON: $0) })
                }
                return .just(mesasges)
            }
        })
    }
}

