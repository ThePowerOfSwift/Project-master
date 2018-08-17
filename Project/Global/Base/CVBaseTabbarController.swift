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
    
    /* 开启屏幕旋转 */
    override var shouldAutorotate: Bool {
        return self.selectedViewController?.shouldAutorotate ?? false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.selectedViewController?.supportedInterfaceOrientations ?? .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return self.selectedViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
    
    
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
        homeVC.cv_tabbarItem.setImage(UIImageNamed("Tabbar_Home_N"), title: LS(self, key: "Home", comment: "首页"), titleColor: UIColor.grayColor_99)
        homeVC.cv_tabbarItem.setImageH(UIImageNamed("Tabbar_Home_H"), titleH: LS(self, key: "Home", comment: "首页"), titleColorH: UIColor.colorWithHex(0xFF6600))
        
        // 我的
        let mineVC =  CVMineViewController()
        let mineNav = CVBaseNavigationController(rootViewController: mineVC)
        mineVC.cv_tabbarItem.setImage(UIImageNamed("Tabbar_Mine_N"), title: LS(self, key: "Mine", comment: "我的"), titleColor: UIColor.grayColor_99)
        mineVC.cv_tabbarItem.setImageH(UIImageNamed("Tabbar_Mine_H"), titleH: LS(self, key: "Mine", comment: "我的"), titleColorH: UIColor.colorWithHex(0xFF6600))
        cv_delay(2) {
            mineVC.cv_tabbarItem.badge = 1            
        }
        

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
            IQKeyboardManager.sharedManager().toolbarDoneBarButtonItemText = LS(key: "Done", comment: "完成")
        }
    }
}
