//
//  SignInViewModel.swift
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

class SignUpViewModel {
    private let disposeBag = DisposeBag()
    private var buttonAction = PublishRelay<Void>()
    private var fullNameText = BehaviorRelay<String>(value: "")
    private var phoneNumberText = BehaviorRelay<String>(value: "")
    private var emailText = BehaviorRelay<String>(value: "")
    private var passwordText = BehaviorRelay<String>(value: "")
    private let signingUp = ActivityIndicator()
    
    let steps: PublishRelay<Step> = PublishRelay<Step>()
    var service: SignUpServiceProtocol!
    
    init(_ injectService: SignUpServiceProtocol) {
        service = injectService
        configObserver()
    }
    
    private func configObserver() {
        buttonAction.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.createUser()
        }).disposed(by: disposeBag)
        
        signingUp.drive(SVProgressHUD.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    private func createUser() {
        let fullName = fullNameText.value
        let phoneNumber = phoneNumberText.value
        let email = emailText.value
        let password = passwordText.value
        service.createUser(with: fullName, phoneNumber: phoneNumber, email: email, password: password)
            .trackActivity(signingUp)
            .compactMap({ resultHandler -> Step? in
                switch resultHandler {
                case .failed(let message) :
                    print(message)
                    return nil
                case .success(let user) :
                    return AppStep.home
                }
            }).bind(to: steps)
            .disposed(by: disposeBag)
    }
}

extension SignUpViewModel {
    
    func buttonActionObserver() -> PublishRelay<Void> {
        return buttonAction
    }
    
    func fullNameObserver() -> BehaviorRelay<String> {
        return fullNameText
    }
    
    func phoneNumberObserver() -> BehaviorRelay<String> {
        return phoneNumberText
    }
    
    func emailObserver() -> BehaviorRelay<String> {
        return emailText
    }
    
    func passwordObserver() -> BehaviorRelay<String> {
        return passwordText
    }
    
    func signUpVisibleObserver() -> Driver<Bool> {
        return Observable.combineLatest(fullNameText, phoneNumberText, emailText, passwordText)
            .concatMap({ (fullName, phoneNumber, email, password) -> Observable<Bool> in
                return .just(!fullName.isEmpty && !phoneNumber.isEmpty && !email.isEmpty && !password.isEmpty)
            }).asDriver(onErrorJustReturn: false)
    }
}

extension SignUpViewModel: Stepper {

}
