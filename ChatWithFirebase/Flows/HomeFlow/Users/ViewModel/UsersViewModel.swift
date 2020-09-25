//
//  UsersViewModel.swift
//  ChatWithFirebase
//
//  Created by SonHoang on 7/26/19.
//  Copyright © 2019 Example. All rights reserved.
//

import Foundation
import RxFlow
import RxCocoa
import RxSwift

enum UsersViewAction {
    case load
    case searchTextChange(String)
    case hideKeyboard
    case selectUser(IndexPath)
}

class UsersViewModel {
    private let disposeBag = DisposeBag()
    private var action = BehaviorRelay<UsersViewAction>(value: .load)
    private var service: WebService
    private var tableSection = BehaviorRelay<[ChatUser]>(value: [])
    
    let steps: PublishRelay<Step> = PublishRelay<Step>()
    
    init(_ injectService: WebService) {
        service = injectService
        configObservable()
    }
    
    private func configObservable() {
        action.subscribe(onNext: { [weak self] action in
            guard let self = self else { return }
            self.handlerAction(action)
        }).disposed(by: disposeBag)
    }
    
    private func handlerAction(_ action: UsersViewAction) {
        switch action {
        case .load:
            fetchAllUser()
        case .selectUser(let indexPath):
            let user = tableSection.value[indexPath.row]
            steps.accept(AppStep.roomDetail(user))
        default:
            break
        }
    }
    
    private func fetchAllUser() {
        service.getListUser()
            .bind(to: tableSection)
            .disposed(by: disposeBag)
    }
}

// MARK: - Public function
extension UsersViewModel {
    func tableSectionObserver() -> BehaviorRelay<[ChatUser]> {
        return tableSection
    }
    
    func actionObserver() -> BehaviorRelay<UsersViewAction> {
        return action
    }
}

// MARK: - Stepper
extension UsersViewModel: Stepper {
    
}
