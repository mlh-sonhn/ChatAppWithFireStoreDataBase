//
//  AppStep.swift
//  ChatWithFirebase
//
//  Created by SonHoang on 7/22/19.
//  Copyright © 2019 Example. All rights reserved.
//

import RxFlow

enum AppStep: Step {
    case wellcome
    case login
    case signUp
    
    case home
    
    case users
    case userDetail
    
    case profile
    case detailImage
    case editProfile
    
    case rooms
    case roomDetail(ChatUser)
    case roomInformation
    case roomSetting
}
