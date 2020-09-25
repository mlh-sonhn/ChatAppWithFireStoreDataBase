//
//  RoomFlow.swift
//  ChatWithFirebase
//
//  Created by SonHoang on 7/23/19.
//  Copyright © 2019 Example. All rights reserved.
//

import Foundation
import UIKit
import RxFlow

class RoomFlow: Flow {
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
        case .rooms:
            return navigateToRoomsViewController()
        default:
            return .none
        }
    }
}

extension RoomFlow {
    private func navigateToRoomsViewController() -> FlowContributors {
        let roomsViewController = RoomsViewController.instantiateFromStoryboard()
        roomsViewController.viewModel = RoomsViewModel(CloudFunctionService())
        rootViewController.pushViewController(roomsViewController, animated: false)
        return FlowContributors.one(flowContributor: FlowContributor.contribute(withNextPresentable: roomsViewController, withNextStepper: OneStepper(withSingleStep: AppStep.rooms)))
    }
}
