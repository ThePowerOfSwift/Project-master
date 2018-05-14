//
//  CVBaseTabbarController.swift
//  Project
//
//  Created by caven on 2018/3/15.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class CVBaseTabbarController: CVTabbarController {

    var isChangedLanguage: Bool = false
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: kCVAppWillChangeLanguageNotification, object: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillChangeLanguage), name: kCVAppWillChangeLanguageNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 首页
        let homeVC =  CVHomeViewController()
        let homeNav = CVBaseNavigationController(rootViewController: homeVC)
        homeNav.tabBarItem.title = LS(self, key: "Home", comment: "首页")
        
        // 我的
        let mineVC =  CVMineViewController()
        let mineNav = CVBaseNavigationController(rootViewController: mineVC)
        mineNav.tabBarItem.title = LS(self, key: "Mine", comment: "我的")
        IQKeyboardManager.sharedManager().toolbarDoneBarButtonItemText = LS(key: "Done", comment: "完成q")

        self.viewControllers = [homeNav, mineNav]
        
        if self.isChangedLanguage && self.selectedIndex == self.viewControllers?.index(of: mineNav) {
            let settingVC = CVSettingViewController()
            mineNav.pushViewController(settingVC, animated: true)
            self.isChangedLanguage = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func appWillChangeLanguage() {
        if self.isViewLoaded && self.view.window == nil {
            self.view = nil
            self.isChangedLanguage = true
            IQKeyboardManager.sharedManager().toolbarDoneBarButtonItemText = LS(key: "Done", comment: "完成q")
        }
    }
}
