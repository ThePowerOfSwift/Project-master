//
//  CVCommon.swift
//  Project
//
//  Created by caven on 2018/3/15.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit

let COM = CVCommon.default

enum CVAppSuportLanguage: String {
    case simplifiedChinese = "zh-Hans"
    case english = "en"
    
    static func languages() -> [String] {
        return [self.simplifiedChinese.rawValue, self.english.rawValue]
    }
}

//这里继承自 NSObject 有问题 “override class func setValue(_ value: Any?, forKey key: String) -> Void {” 只能写成 override 的了  
final class CVCommon {

    /// 单例
    static let `default` = CVCommon()
    let appDisplayName = Bundle.main.infoDictionary!["CFBundleDisplayName"] as? String // 程序名称
    let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String   // 主程序版本号
    let appBuildVersion = Bundle.main.infoDictionary!["CFBundleVersion"] as! String     // build版本
    let UUID = CVKeyChain.appIdentifier()   // 设备的唯一标示UUID
    
    func currentLanguage() -> String {
        return CVLanguageHelper.getCurrentRunningLanguage()
    }
    
    func supportLanguage() -> [String] {
        return CVAppSuportLanguage.languages()
    }
    
    /// 全局存储
    func setValue(_ value: Any?, forKey key: String) -> Void {
        UserDefaults.standard.setValue(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    func value(forKey key: String) -> Any? {
        return UserDefaults.standard.value(forKey: key)
    }
    

    // MARK: Alert 弹框
    @discardableResult
    func alert(vc: UIViewController, title: String?, msg: String?, cancel: String?, ok: String?, cancelCallBack:(()->(Void))?, okCallBack:(()->(Void))?) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        if cancel != nil, cancelCallBack != nil {
            let alertAction = UIAlertAction(title: cancel!, style: .cancel, handler: {(_) in cancelCallBack!() })
            alertController.addAction(alertAction)
        }
        
        if ok != nil, okCallBack != nil {
            let alertAction = UIAlertAction(title: ok!, style: .default, handler: {(_) in okCallBack!() })
            alertController.addAction(alertAction)
        }
        vc.present(alertController, animated: true, completion: nil)
        return alertController
    }
    
    // MARK: ActionSheet 弹框
    @discardableResult
    func actionSheet(vc: UIViewController, title: String?, sheets: [String], callBack:(@escaping (_ index: Int)->(Void))) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        for (i, value) in sheets.enumerated() {
            let alertAction = UIAlertAction(title: value, style: .default, handler: { (_) in
                callBack(i)
            })
            alertController.addAction(alertAction)
        }

        let alertAction = UIAlertAction(title: LS(key: "Cancel", comment: "取消"), style: .cancel, handler: nil)
        alertController.addAction(alertAction)

        vc.present(alertController, animated: true, completion: nil)
        return alertController
    }
    
    
    
    /// 取随机数
    func arc4random(min: UInt32 = 0, max: UInt32) -> UInt32 {
        guard max > min else { return 0 }
        return Darwin.arc4random() % max + min
    }
    
//    func arc4random(max: UInt32) -> UInt32 {
//        return arc4random(min: 0, max: max)
//    }
    
}


