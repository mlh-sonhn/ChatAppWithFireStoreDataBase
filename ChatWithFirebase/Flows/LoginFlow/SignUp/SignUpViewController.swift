//
//  SignUpViewController.swift
//  ChatWithFirebase
//
//  Created by SonHoang on 7/22/19.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit
import RxSwift

class SignUpViewController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var fullNameTextfield: UITextField!
    @IBOutlet weak var phoneNumberTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    var viewModel: SignUpViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func bindViewModel() {
        signUpButton.rx.tap
            .bind(to: viewModel.buttonActionObserver())
            .disposed(by: disposeBag)
        fullNameTextfield.rx.text
            .orEmpty
            .map { return $0 == nil ? "" : $0! }
            .bind(to: viewModel.fullNameObserver())
            .disposed(by: disposeBag)
        phoneNumberTextfield.rx.text
            .orEmpty
            .map { return $0 == nil ? "" : $0! }
            .bind(to: viewModel.phoneNumberObserver())
            .disposed(by: disposeBag)
        emailTextfield.rx.text
            .orEmpty
            .map { return $0 == nil ? "" : $0! }
            .bind(to: viewModel.emailObserver())
            .disposed(by: disposeBag)
        passwordTextfield.rx.text
            .orEmpty
            .map { return $0 == nil ? "" : $0! }
            .bind(to: viewModel.passwordObserver())
            .disposed(by: disposeBag)
        
        viewModel.signUpVisibleObserver()
            .drive(signUpButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }

}
