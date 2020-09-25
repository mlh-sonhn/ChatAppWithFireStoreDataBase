//
//  AppFlow.swift
//  ChatWithFirebase
//
//  Created by SonHoang on 7/22/19.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxFlow
import UIWindowTransitions

class AppFlow: Flow {
let disposeBag = DisposeBag()
    private var rootWindow: UIWindow

    var root: Presentable {
        return self.rootWindow
    }
    
    init(_ window: UIWindow) {
        rootWindow = window
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        switch step {
        case .wellcome:
//            return navigateToLoginFlow()
            if FirebaseAuthen.isAlreadyLogin() {
                return navigateToHomeFlow()
            } else {
                return navigateToLoginFlow()
            }
        case .login:
            return navigateToLoginFlow()
        case .home:
            return navigateToHomeFlow()
        default:
            return .none
        }
    }
    
}

extension AppFlow {
    private func navigateToLoginFlow() -> FlowContributors {
        let loginFlow = LoginFlow()
        Flows.whenReady(flow1: loginFlow) { [weak self] root in
            if let strongSelf = self {
                strongSelf.rootWindow.rootViewController = root
            }            
        }
        return FlowContributors.one(flowContributor: FlowContributor.contribute(withNextPresentable: loginFlow, withNextStepper: OneStepper(withSingleStep: AppStep.wellcome)))
    }
    
    private func navigateToHomeFlow() -> FlowContributors {
        let homeFlow = HomeFlow()
        Flows.whenReady(flow1: homeFlow) { [weak self] root in
            guard let strongSelf = self else { return }
            strongSelf.rootWindow.rootViewController = root
        }
        return FlowContributors.one(flowContributor: FlowContributor.contribute(withNextPresentable: homeFlow, withNextStepper: OneStepper(withSingleStep: AppStep.home)))
    }
}
