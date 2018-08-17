//
//  AppDelegate.swift
//  Project
//
//  Created by caven on 2018/3/6.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit
import Reachability
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var cv_tabBarController: CVTabbarController?
    var cv_isAllowAutorotate: Bool = false      // 是否允许横屏，默认false，如果某一页面需要，在viewDidAppear中设为true，在viewDidDisAppear中设为false
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        CVLanguageHelper.setSupportLanguage(languages: COM.supportLanguage())
        
        self.window = UIWindow(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        self.window!.backgroundColor = UIColor.white
        
        // 计算app的启动次数，app每启动一次，计数+1
        statisticsAppRuns(showReview: true)
        
        self.cv_tabBarController = CVBaseTabbarController()
        self.window!.rootViewController = self.cv_tabBarController
        self.window!.makeKeyAndVisible()
        
        /// 键盘toolBar
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        IQKeyboardManager.sharedManager().shouldShowToolbarPlaceholder = true
        // IQKeyboardManager.sharedManager().shouldToolbarUsesTextFieldTintColor = true
        IQKeyboardManager.sharedManager().toolbarDoneBarButtonItemText = LS(key: "Done", comment: "完成q")
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        // 最新版的设置键盘的returnKey的关键字 ,可以点击键盘上的next键，自动跳转到下一个输入框，最后一个输入框点击完成，自动收起键盘
        IQKeyboardManager.sharedManager().toolbarManageBehaviour = .byPosition

        /// 检测网络
        let reachability = Reachability()!
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                CVLog("网络： WiFi")
            } else {
                CVLog("网络： Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            CVLog("没有网")
        }
        
        do {
            try reachability.startNotifier()
        } catch { }

       
        // 3DTouch
        self.cv_3dTouch_application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

