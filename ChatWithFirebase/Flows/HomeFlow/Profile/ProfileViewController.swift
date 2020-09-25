//
//  ProfileViewController.swift
//  ChatWithFirebase
//
//  Created by SonHoang on 7/23/19.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit
import RxSwift

class ProfileViewController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    var viewModel: ProfileViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }
    
    private func setupNavigation() {
        let logOutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: nil)
        logOutButton.rx.tap
            .map { _ in ProfileUserAction.logOut }
            .bind(to: viewModel.userActionObsever())
            .disposed(by: disposeBag)
        navigationItem.rightBarButtonItem = logOutButton
    }

}
