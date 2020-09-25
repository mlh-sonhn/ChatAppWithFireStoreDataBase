//
//  LoginFlow.swift
//  ChatWithFirebase
//
//  Created by SonHoang on 7/22/19.
//  Copyright © 2019 Example. All rights reserved.
//

import RxFlow
import UIKit

class LoginFlow: Flow {
    
    private lazy var rootViewController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isTranslucent = true
        return navigationController
    }()

    var root: Presentable {
        return rootViewController
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        switch step {
        case .wellcome:
            return navigateToWellcomeViewController()
        case .login:
            return navigateToLoginViewController()
        case .signUp:
            return navigateToSignInViewController()
        case .home:
            return navigateToHomeFlow()
        default:
            return .none
        }
    }
    
}

extension LoginFlow {
    private func navigateToWellcomeViewController() -> FlowContributors {
        let wellcomeViewController = WellcomeViewController.instantiateFromStoryboard()
        wellcomeViewController.viewModel = WellcomeViewModel()
        rootViewController.pushViewController(wellcomeViewController, animated: false)
        return FlowContributors.one(flowContributor: FlowContributor.contribute(withNextPresentable: wellcomeViewController, withNextStepper: wellcomeViewController.viewModel))
    }
    
    private func navigateToLoginViewController() -> FlowContributors {
        let loginViewController = LoginViewController.instantiateFromStoryboard()
        loginViewController.viewModel = LoginViewModel(FirebaseAuthen())
        rootViewController.pushViewController(loginViewController, animated: true)
        return FlowContributors.one(flowContributor: FlowContributor.contribute(withNextPresentable: loginViewController, withNextStepper: loginViewController.viewModel))
    }
    
    private func navigateToSignInViewController() -> FlowContributors {
        let signInViewController = SignUpViewController.instantiateFromStoryboard()
        let signInService = SignUpService(CloudFunctionService(), injectAuthen: FirebaseAuthen())
        signInViewController.viewModel = SignUpViewModel(signInService)
        rootViewController.pushViewController(signInViewController, animated: true)
        return FlowContributors.one(flowContributor: FlowContributor.contribute(withNextPresentable: signInViewController, withNextStepper: signInViewController.viewModel))
    }
    
    private func navigateToHomeFlow() -> FlowContributors {
        return FlowContributors.end(forwardToParentFlowWithStep: AppStep.home)
    }
}
