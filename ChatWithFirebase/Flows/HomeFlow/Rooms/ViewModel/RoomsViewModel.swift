//
//  RoomsViewModel.swift
//  ChatWithFirebase
//
//  Created by SonHoang on 7/24/19.
//  Copyright © 2019 Example. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxFlow

enum RoomsAction {
    case load
    case searchTextChange(String)
    case searchButtonPress
    case hideKeyboard
    case directToRoomDetail(IndexPath)
    case deleteRoom(IndexPath)
}

class RoomsViewModel {
    private let disposeBag = DisposeBag()
    let steps: PublishRelay<Step> = PublishRelay<Step>()
    var action = BehaviorRelay<RoomsAction>(value: .load)
    var cloudService: CloudFunctionService!
    
    init(_ injectService: CloudFunctionService) {
        cloudService = injectService
        configObservable()
    }
    
    private func configObservable() {
        action.subscribe(onNext: { [weak self] action in
            guard let self = self else { return }
            self.handlerAction(action)
        }).disposed(by: disposeBag)
    }
    
    private func handlerAction(_ action: RoomsAction) {
        switch action {
        case .load:
            break
        default:
            break
        }
    }
}

extension RoomsViewModel: Stepper {
    
}
