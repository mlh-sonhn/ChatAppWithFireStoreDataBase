//
//  WellcomeViewController.swift
//  ChatWithFirebase
//
//  Created by SonHoang on 7/22/19.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit
import RxSwift

class WellcomeViewController: BaseViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    var viewModel: WellcomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bindViewModel() {
        let loginAction = loginButton.rx.tap.map { WellcomeUserAction.login }
        let signUpAction = signUpButton.rx.tap.map { WellcomeUserAction.signup }
        
        Observable.of(loginAction, signUpAction).merge()
            .bind(to: viewModel.userAction)
            .disposed(by: disposeBag)
    }
}
