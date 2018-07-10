//
//  AppDelegate + 3DTouch.swift
//  Project
//
//  Created by caven on 2018/5/14.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import Foundation
import UIKit

extension AppDelegate {
    
    private struct Pointer {
        static var locationVC: String = "locationVC"
        static var commitVC: String = "commitVC"
        static var sourceVC: String = "sourceVC"
    }
    
    var locationVC: UIViewController? {
        set {
            objc_setAssociatedObject(self, &Pointer.locationVC, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, &Pointer.locationVC) as? UIViewController
        }
    }
    var commitVC: UIViewController? {
        set {
            objc_setAssociatedObject(self, &Pointer.commitVC, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, &Pointer.commitVC) as? UIViewController
        }
    }
    var sourceVC: UIViewController? {
        set {
            objc_setAssociatedObject(self, &Pointer.sourceVC, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, &Pointer.sourceVC) as? UIViewController
        }
    }


    /*
     
     3D Touch的主要体现形式有三种：
     
     主屏交互(Home Screen Interaction)
     预览和跳转(Peek and Pop)
     LivePhoto（涉及到相册资源）
     
     这里是第一种
     
     */
    
    func cv_3dTouch_application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        if #available(iOS 9.0, *) {
            var shortcutItems = [UIApplicationShortcutItem]()
            let share = UIApplicationShortcutItem.init(type: "com.caven.cv.share", localizedTitle: "分享", localizedSubtitle: "分享给朋友吧", icon: UIApplicationShortcutIcon.init(type: UIApplicationShortcutIconType.share), userInfo: ["share":"toFriends"])
            
            let play = UIApplicationShortcutItem.init(type: "com.caven.cv.share", localizedTitle: "播放", localizedSubtitle: nil, icon: UIApplicationShortcutIcon.init(type: UIApplicationShortcutIconType.play), userInfo: ["play":"songs"])

            let add = UIApplicationShortcutItem.init(type: "com.caven.cv.add", localizedTitle: "添加", localizedSubtitle: nil, icon: UIApplicationShortcutIcon.init(type: UIApplicationShortcutIconType.add), userInfo: ["add":"somethings"])

            let search = UIApplicationShortcutItem.init(type: "com.caven.cv.search", localizedTitle: "添加", localizedSubtitle: nil, icon: UIApplicationShortcutIcon.init(type: UIApplicationShortcutIconType.search), userInfo: ["search":"historys"])

            
            /*  如果自定义icon：图片必须是正方形、单色并且尺寸是35*35像素的图片   */
            shortcutItems.append(share)
            shortcutItems.append(play)
            shortcutItems.append(add)
            shortcutItems.append(search)
            
            application.shortcutItems = shortcutItems
        } else {

        }
    }
    
    /// 事件的响应
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        CVLog("\(shortcutItem.localizedTitle), \(shortcutItem.type)")
        
        CVAlertView.show(title: "提示", message: "\(shortcutItem.localizedTitle), \(shortcutItem.type)", cancelButtonTitle: "取消", otherButtonTitles: "确定") { (index) in
            
        }
        
        completionHandler(true)
    }
    
    /// 3D Touch
    func register3D_TouchInController(_ controller: UIViewController, for view: UIView, locationVC: UIViewController, commitVC: UIViewController) {
        /**
         从iOS9开始，我们可以通过这个类来判断运行程序对应的设备是否支持3D Touch功能。
         unknown = 0,     //未知
         unavailable = 1, //不可用
         available = 2    //可用
         */
        
        if #available(iOS 9.0, *) {
            if controller.traitCollection.forceTouchCapability == .available {
                controller.registerForPreviewing(with: self, sourceView: view)
                self.locationVC = locationVC;
                self.commitVC = commitVC
                self.sourceVC = controller
            }
        } else {
            // Fallback on earlier versions
        }
        
    }
}

@available(iOS 9.0, *)
extension AppDelegate: UIViewControllerPreviewingDelegate {
    
    /// 当用力按压的时候要预览的VC
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        return self.locationVC
    }
    /// 当用力按压持续用力的时候，所要进行的操作
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
        if let nav = self.sourceVC!.navigationController {
            nav.pushViewController(self.commitVC!, animated: true)
        } else {
            self.sourceVC!.present(self.commitVC!, animated: true, completion: nil)
        }
    }
    
    
}


