//
//  HENavigationController.swift
//  Project
//
//  Created by weixhe on 2018/3/6.
//  Copyright © 2018年 com.weixhe. All rights reserved.
//

import UIKit

class HENavigationController: UINavigationController {

    override var isNavigationBarHidden: Bool {
        set {
            super.isNavigationBarHidden = true
        }
        get {
            return true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isNavigationBarHidden = true
        self.interactivePopGestureRecognizer?.delegate = self
        self.hidesBottomBarWhenPushed = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}

extension HENavigationController : UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.viewControllers.count == 1 {
            return false;
        }
        return true;
    }
}

