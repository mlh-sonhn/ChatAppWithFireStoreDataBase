//
//  HomeFlow.swift
//  ChatWithFirebase
//
//  Created by SonHoang on 7/23/19.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit
import RxFlow

class HomeFlow: Flow {
    private lazy var rootViewController: UITabBarController = {
        let tabbarController = UITabBarController()
        return tabbarController
    }()
    
    var root: Presentable {
        return rootViewController
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        switch step {
        case .home:
            return navigateToHome()
        case .login:
            return navigateToLoginFlow()
        default:
            return .none
        }
    }
}

extension HomeFlow {
    private func navigateToHome() -> FlowContributors {
        let roomsFlow = RoomFlow()
        let profileFlow = ProfileFlow()
        let usersFlow = UsersFlow()
        
        Flows.whenReady(flow1: roomsFlow, flow2: usersFlow, flow3: profileFlow) { (roomsNavigation, usersNavigation, profileNavigation) in
            let roomsBarItem = UITabBarItem(title: "Rooms", image: nil, tag: 0)
            let usersBarItem = UITabBarItem(title: "Users", image: nil, tag: 1)
            let profileBarItem = UITabBarItem(title: "Profile", image: nil, tag: 2)
            
            roomsNavigation.tabBarItem = roomsBarItem
            usersNavigation.tabBarItem = usersBarItem
            profileNavigation.tabBarItem = profileBarItem
            
            self.rootViewController.setViewControllers([roomsNavigation, usersNavigation, profileNavigation], animated: false)
        }
        return FlowContributors.multiple(flowContributors: [
                FlowContributor.contribute(withNextPresentable: roomsFlow, withNextStepper: OneStepper(withSingleStep: AppStep.rooms)),
                FlowContributor.contribute(withNextPresentable: usersFlow, withNextStepper: OneStepper(withSingleStep: AppStep.users)),
                FlowContributor.contribute(withNextPresentable: profileFlow, withNextStepper: OneStepper(withSingleStep: AppStep.profile))
            ])
    }
    
    private func navigateToLoginFlow() -> FlowContributors {
        return FlowContributors.end(forwardToParentFlowWithStep: AppStep.login)
    }
}
