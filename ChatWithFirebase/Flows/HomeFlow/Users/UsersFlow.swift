//
//  UsersFlow.swift
//  ChatWithFirebase
//
//  Created by SonHoang on 7/23/19.
//  Copyright © 2019 Example. All rights reserved.
//

import RxFlow
class UsersFlow: Flow {
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
        case .users:
            return navigateToUsersViewController()
        case .roomDetail(let chatUser):
            return navigateToRoomDetailController(with: chatUser)
        default:
            return .none
        }
    }
}

extension UsersFlow {
    private func navigateToUsersViewController() -> FlowContributors {
        let usersViewController = UsersViewController.instantiateFromStoryboard()
        usersViewController.viewModel = UsersViewModel(CloudFunctionService())
        rootViewController.pushViewController(usersViewController, animated: false)
        return FlowContributors.one(flowContributor: FlowContributor.contribute(withNextPresentable: usersViewController, withNextStepper: usersViewController.viewModel))
    }
    
    private func navigateToRoomDetailController(with user: ChatUser) -> FlowContributors {
        let roomDetailViewController = RoomDetailViewController.instantiateFromStoryboard()
        let roomInfor = RoomInfor(.single, injectSource: .userList, injectReceiver: user)
        roomDetailViewController.viewModel = RoomDetailViewModel(CloudFunctionService(), injectDBService: FirestoreService(), injectRoomInfor: roomInfor)
        rootViewController.pushViewController(roomDetailViewController, animated: true)
        return FlowContributors.one(flowContributor: FlowContributor.contribute(withNextPresentable: roomDetailViewController, withNextStepper: OneStepper(withSingleStep: AppStep.roomDetail(user))))
    }
}
