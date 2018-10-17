//
//  UIViewControllerHelper.swift
//  Project
//
//  Created by caven on 2018/7/4.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import Foundation
import UIKit

//private let key_cv_tabbar_item = "com.caven.tabbar.item"
//private let key_cv_navigationController = "com.caven.navigationController"

@objc extension UIViewController {
    
    struct PrivateKey {
        static let tabbar_item = "com.caven.tabbar.item"
        static let nav_controller = "com.caven.navigationController"
        static let nav_bar = "com.caven.navigationBar"
        static let nav_item = "com.caven.navigationItem"

    }
    
    /// nav controller
    var cv_navigationController: CVNavigationController? {
        set {
            let key: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: PrivateKey.nav_controller.hashValue)
            objc_setAssociatedObject(self, key, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            let key: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: PrivateKey.nav_controller.hashValue)
            let navCon: CVNavigationController? = objc_getAssociatedObject(self, key) as? CVNavigationController
            return navCon
        }
    }
    
    /// nav bar
    var cv_navigationBar: CVNavigationBar? {
        set {
            let key: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: PrivateKey.nav_bar.hashValue)
            objc_setAssociatedObject(self, key, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            let key: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: PrivateKey.nav_bar.hashValue)
            let navBar: CVNavigationBar? = objc_getAssociatedObject(self, key) as? CVNavigationBar
            return navBar
        }
    }
    
    /// nav item
    var cv_leftBarButtonItem: CVBarButtonItem? {
        set {
            let key: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: PrivateKey.nav_item.hashValue)
            objc_setAssociatedObject(self, key, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            let key: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: PrivateKey.nav_item.hashValue)
            let navItem: CVBarButtonItem? = objc_getAssociatedObject(self, key) as? CVBarButtonItem
            return navItem
        }
    }
    
    /// tab item
    var cv_tabbarItem: CVTabBarItem {
        get {
            
            let key: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: PrivateKey.tabbar_item.hashValue)
            var tabBar: CVTabBarItem? = objc_getAssociatedObject(self, key) as? CVTabBarItem
            if tabBar == nil {
                tabBar = CVTabBarItem(frame: CGRect.zero)
                objc_setAssociatedObject(self, key, tabBar, .OBJC_ASSOCIATION_RETAIN)
            }
            return tabBar!
        }
    }
}
