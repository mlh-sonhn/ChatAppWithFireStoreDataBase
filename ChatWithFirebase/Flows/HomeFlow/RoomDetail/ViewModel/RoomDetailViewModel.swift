//
//  RoomDetailViewModel.swift
//  ChatWithFirebase
//
//  Created by SonHoang on 7/29/19.
//  Copyright © 2019 Example. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SVProgressHUD

enum RoomDetailAction {
    case load
    case sendMessage(String)
}

enum ViewSource {
    case userList
    case roomList
}

struct RoomInfor {
    var receiver: ChatUser?
    var chatRoom: ChatRoom?
    var roomType: RoomType = .single
    var source: ViewSource = .roomList
    
    init(_ injectRoomType: RoomType, injectSource: ViewSource, injectChatRoom: ChatRoom? = nil, injectReceiver: ChatUser? = nil) {
        roomType = injectRoomType
        chatRoom = injectChatRoom
        receiver = injectReceiver
        source = injectSource
    }
    
    func getRoomId() -> String {
        return chatRoom?.id ?? ""
    }
    
    func isFromUserList() -> Bool {
        return source == .userList
    }
}

class RoomDetailViewModel {

    private let disposeBag = DisposeBag()
    private var service: WebService
    private var dbService: DatabaseService
    private var messages = BehaviorRelay<[ChatMessage]>(value: [])
    private var loadingIndicator = ActivityIndicator()
    private var action = BehaviorRelay<RoomDetailAction>(value: .load)
    private var roomInfor: RoomInfor?
    
    init(_ injectService: WebService, injectDBService: DatabaseService, injectRoomInfor: RoomInfor) {
        service = injectService
        dbService = injectDBService
        roomInfor = injectRoomInfor
        configObservable()
    }
    
    private func configObservable() {
        action.subscribe(onNext: { [weak self] action in
            guard let self = self else { return }
            self.handlerAction(action)
        }).disposed(by: disposeBag)
        loadingIndicator.drive(SVProgressHUD.rx.isAnimating)
            .disposed(by: disposeBag)
        addObserverToMessage()
    }
    
    private func addObserverToMessage() {
        // Add room message observer
        guard let roomInfor = roomInfor else { return }
        if !roomInfor.isFromUserList() {
            dbService.addObserver(to: roomInfor.getRoomId()).subscribe(onNext: { message in
                print(message)
            }).disposed(by: disposeBag)
        }
    }

    private func handlerAction(_ action: RoomDetailAction) {
        switch action {
        case .load:
            loadMessage()
        case .sendMessage(let message):
            sendMessage(message: message)
        }
    }
    
    private func loadMessage() {
        guard let roomInfor = roomInfor else { return }
        service.getListMessage(inConverationWith: roomInfor.receiver, roomId: roomInfor.getRoomId(), roomType: roomInfor.roomType)
            .bind(to: messages)
            .disposed(by: disposeBag)
    }
    
    private func sendMessage(message: String) {
        guard let roomInfor = roomInfor else { return }
        if let receiver = roomInfor.receiver, roomInfor.isFromUserList() {
            service.sendMessage(to: receiver, message: message).subscribe(onNext: { _ in
            }).disposed(by: disposeBag)
        } else if let _ = roomInfor.chatRoom {
            
        }
    }
}

extension RoomDetailViewModel {
    func actionObserver() -> BehaviorRelay<RoomDetailAction> {
        return action
    }
    
    func messagesObserver() -> BehaviorRelay<[ChatMessage]> {
        return messages
    }
    
    func sendMessage(_ message: String) {
        action.accept(.sendMessage(message))
    }
    
    func sizeOfItem(at indexPath: IndexPath, with collectionWidth: CGFloat) -> CGFloat {
        let string = messages.value[indexPath.row].message
        let font = UIFont.systemFont(ofSize: 17.0)
        let height = string.heightWithConstrainedWidth(width: collectionWidth - 94, font: font)
        return height + 20
    }
}

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font: font], context: nil)
        return boundingBox.height
    }
}
