//
//  LoginViewController.swift
//  ChatWithFirebase
//
//  Created by SonHoang on 7/22/19.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit
import RxSwift

class LoginViewController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var viewModel: LoginViewModel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func bindViewModel() {
        loginButton.rx.tap
            .bind(to: viewModel.buttonActionObserver())
            .disposed(by: disposeBag)
        emailTextfield.rx.text
            .orEmpty
            .map { return $0 == nil ? "" : $0! }
            .bind(to: viewModel.emailTextObserver())
            .disposed(by: disposeBag)
        passwordTextfield.rx.text
            .orEmpty
            .map { return $0 == nil ? "" : $0! }
            .bind(to: viewModel.passwordTextObserver())
            .disposed(by: disposeBag)
        viewModel.buttonVisibleObserver()
            .drive(loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }

}
