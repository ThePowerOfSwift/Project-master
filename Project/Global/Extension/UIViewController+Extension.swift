//
//  UIViewController+Extension.swift
//  Project
//
//  Created by caven on 2018/7/4.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import Foundation
import UIKit

private let key_cv_tabbar_item = "com.caven.tabbar.item"
extension UIViewController {
    var cv_tabbarItem: CVTabBarItem {
        get {
            
            let key: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: key_cv_tabbar_item.hashValue)
            var tabBar: CVTabBarItem? = objc_getAssociatedObject(self, key) as? CVTabBarItem
            if tabBar == nil {
                tabBar = CVTabBarItem(frame: CGRect.zero)
                objc_setAssociatedObject(self, key, tabBar, .OBJC_ASSOCIATION_RETAIN)
            }
            return tabBar!
        }
    }
}
