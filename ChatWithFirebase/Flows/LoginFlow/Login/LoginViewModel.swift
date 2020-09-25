//
//  LoginViewModel.swift
//  ChatWithFirebase
//
//  Created by SonHoang on 7/22/19.
//  Copyright © 2019 Example. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxFlow
import FirebaseAuth
import SVProgressHUD

class LoginViewModel {

    private let disposeBag = DisposeBag()
    private var buttonAction = PublishRelay<Void>()
    private var emailText = BehaviorRelay<String>(value: "")
    private var passwordText = BehaviorRelay<String>(value: "")
    private var authen: AuthenService!
    private let signingIn = ActivityIndicator()

    let steps: PublishRelay<Step> = PublishRelay<Step>()
    
    init(_ injectAuthen : AuthenService) {
        authen = injectAuthen
        configObserver()
    }
    
    private func configObserver() {
        buttonAction.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.login(with: self.emailText.value, password: self.passwordText.value)
        }).disposed(by: disposeBag)
        signingIn.asDriver()
            .drive(SVProgressHUD.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    private func login(with email: String, password: String) {
        authen.login(with: email, password: password)
            .trackActivity(signingIn)
            .compactMap({ handler -> Step? in
                switch handler {
                case .success(let user):
                    print(user.displayName)
                    return AppStep.home
                case .failed(let message):
                    print(message)
                    return nil
                }
            }).bind(to: steps)
            .disposed(by: disposeBag)
        
    }
}

extension LoginViewModel {
    func buttonActionObserver() -> PublishRelay<Void> {
        return buttonAction
    }
    
    func emailTextObserver() -> BehaviorRelay<String> {
        return emailText
    }
    
    func passwordTextObserver() -> BehaviorRelay<String> {
        return passwordText
    }
    
    func buttonVisibleObserver() -> Driver<Bool> {
        return Observable.combineLatest(emailText, passwordText)
            .concatMap({ (email, password) -> Observable<Bool> in
                return .just(!email.isEmpty && !password.isEmpty)
            }).asDriver(onErrorJustReturn: false)
    }
    
}

extension LoginViewModel: Stepper {
}
