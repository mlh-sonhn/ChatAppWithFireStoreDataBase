//
//  ProfileViewModel.swift
//  ChatWithFirebase
//
//  Created by SonHoang on 8/3/19.
//  Copyright © 2019 Example. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFlow

enum ProfileUserAction {
    case logOut
}

class ProfileViewModel {
    private let disposeBag = DisposeBag()
    private var userAction = PublishRelay<ProfileUserAction>()
    private var authenService: AuthenService
    var steps: PublishRelay<Step> = PublishRelay<Step>()
    
    init(_ injectAuthenService: AuthenService) {
        authenService = injectAuthenService
        configRxObserver()
    }
    
    private func configRxObserver() {
        userAction.subscribe(onNext: { [weak self] action in
            guard let self = self else { return }
            self.handler(action: action)
        }).disposed(by: disposeBag)
    }
    
    private func handler(action: ProfileUserAction) {
        switch action {
        case .logOut:
            authenService.logOut()
                .filter { $0 }
                .map { _ in AppStep.login }
                .bind(to: steps)
                .disposed(by: disposeBag)
        }
    }
    
}

extension ProfileViewModel {
    func userActionObsever() -> PublishRelay<ProfileUserAction> {
        return userAction
    }
}

extension ProfileViewModel: Stepper {

}
