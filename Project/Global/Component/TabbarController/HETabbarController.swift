//
//  HETabbarController.swift
//  Project
//
//  Created by weixhe on 2018/3/15.
//  Copyright © 2018年 com.weixhe. All rights reserved.
//

import UIKit

class HETabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        hidenRealTabBar()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hidenRealTabBar()  {
        for view in self.view.subviews {
            if view.isKind(of: UITabBar.self) {
                view.isHidden = true
                view.frame.origin.y = SCREEN_HEIGHT
            }
        }
    }

}
