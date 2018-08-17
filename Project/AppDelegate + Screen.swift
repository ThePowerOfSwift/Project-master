//
//  AppDelegate + Screen.swift
//  Project
//
//  Created by caven on 2018/8/2.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import Foundation

extension AppDelegate {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?)
        -> UIInterfaceOrientationMask {
            if self.cv_isAllowAutorotate {
                return [.portrait, .landscapeLeft, .landscapeRight]
            } else {
                return .portrait
            }
    }
    
}

