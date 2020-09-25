//
//  WellcomeViewModel.swift
//  ChatWithFirebase
//
//  Created by SonHoang on 7/22/19.
//  Copyright © 2019 Example. All rights reserved.
//

import Foundation
import RxFlow
import RxSwift
import RxCocoa

enum WellcomeUserAction {
    case login
    case signup
}

class WellcomeViewModel: Stepper {
    private let disposeBag = DisposeBag()
    let userAction: PublishRelay<WellcomeUserAction> = PublishRelay<WellcomeUserAction>()
    let steps: PublishRelay<Step> = PublishRelay<Step>()
    
    init() {
        configObservable()
    }
    
    private func configObservable() {
        userAction.map { action -> Step in
            switch action {
            case .login:
                return AppStep.login
            case .signup :
                return AppStep.signUp
            }
        }.bind(to: steps).disposed(by: disposeBag)
    }
}
