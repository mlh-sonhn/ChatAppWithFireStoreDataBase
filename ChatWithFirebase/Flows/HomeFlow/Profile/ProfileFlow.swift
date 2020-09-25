//
//  ProfileFlow.swift
//  ChatWithFirebase
//
//  Created by SonHoang on 7/23/19.
//  Copyright © 2019 Example. All rights reserved.
//

import Foundation
import RxFlow

class ProfileFlow: Flow {
    private lazy var rootViewController: UINavigationController = {
        let navigationController = UINavigationController()
        return navigationController
    }()
    
    var root: Presentable {
        return rootViewController
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        switch step {
        case .profile:
            return navigateToProfileViewController()
        case .login:
            return navigateToLoginFlow()
        default:
            return .none
        }
    }
}

extension ProfileFlow {
    private func navigateToProfileViewController() -> FlowContributors {
        let profileViewController = ProfileViewController.instantiateFromStoryboard()
        let viewModel = ProfileViewModel(FirebaseAuthen())
        profileViewController.viewModel = viewModel
        rootViewController.pushViewController(profileViewController, animated: false)
        return FlowContributors.one(flowContributor: FlowContributor.contribute(withNextPresentable: profileViewController, withNextStepper: profileViewController.viewModel))
    }
    
    private func navigateToLoginFlow() -> FlowContributors {
        return FlowContributors.end(forwardToParentFlowWithStep: AppStep.login)
    }
}
