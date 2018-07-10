//
//  Global.swift
//  CVKeyboardTextField
//
//  Created by caven on 2018/3/1.
//  Copyright © 2018年 com.caven. All rights reserved.
//

/************************************************************
 本文件放置工程中固定的东西，适用于所有的项目工程
 ************************************************************/

import Foundation
import UIKit
import SnapKit      // 自动布局的库
import GTMRefresh  // 下拉、上拉的库
import HandyJSON    // 字典 - 模型 - json
import Kingfisher


/**
 *   定义DUBUG宏 TARGETS --> Build Settings --> Swift Complier - Custom Flags --> Other Swift Flags --> DEBUG
 　　　　格式 -D DEBUG 。也就是声明的宏之前要加一个这样的符号 -D 。它会自动分成两行显示。
 */
func CVLog<N>(_ message: N, file: String = #file, method: String = #function, line: Int = #line) {
    #if DEBUG // 若是Debug模式下，则打印
        let fileName = (file as NSString).lastPathComponent
        print("\n文件名: \(fileName)\n方法: \(method)\n行号: \(line)\n打印信息: \(message)");
    #endif
}

/// 屏幕尺寸
let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height
let cv_safeAreaInsets = cv_safeAreaInsetsIn(view: cv_AppDelegate.window)
let cv_safeScreenHeight = cv_screen_height_safe()
let cv_safeNavBarHeight = cv_navigation_height()
let cv_safeTabBarHeight = cv_tabBar_height()
let cv_AppDelegate = UIApplication.shared.delegate as! AppDelegate

/// 系统版本
let IOS8 = (UIDevice.current.systemVersion as NSString).doubleValue >= 8.0
let IOS9 = (UIDevice.current.systemVersion as NSString).doubleValue >= 9.0
let IOS10 = (UIDevice.current.systemVersion as NSString).doubleValue >= 10.0
let IOS11 = (UIDevice.current.systemVersion as NSString).doubleValue >= 11.0

/// 根据 375 的设计图，进行尺寸变换
func cv_format_375(x: CGFloat) -> CGFloat {
    return SCREEN_WIDTH / 375 * x
}
/** 这个参数,看公司项目UI图 具体是哪款机型,默认  iphone6
 RealUISrceenWidth  (4/4s 5/5s) 320.0  (6/6s 7/7s 8/8s) 375.0  (6p/6sp 7p/7ps 8p/8ps)  414.0 (x) 375
 RealUISrceenHeight (4/4s) 修改480 (5/5s) 568.0  (6/6s 7/7s 8/8s) 667.0  (6p/6sp 7p/7ps 8p/8ps) 736.0  (x) 812 (备用)
 */

/// 系统版本号
let cv_sysVersion = UIDevice.current.systemVersion
/// 系统名称("iOS", "tvOS", "watchOS", "macOS")
let cv_sysName = UIDevice.current.systemName
/// 设备名称
let cv_deviceName = PhoneDeviceModel.get()
/// 程序名称
let cv_appDisplayName = Bundle.main.infoDictionary!["CFBundleDisplayName"] as? String
/// 主程序版本号
let cv_appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
/// build版本
let cv_appBuildVersion = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
// 设备的唯一标示UUID
let cv_UUID = CVKeyChain.appIdentifier()

/// 安全区域
func cv_safeAreaInsetsIn(view: UIView?) -> UIEdgeInsets {
    
    if #available(iOS 11.0, *) {
        if let view = view {
            return view.safeAreaInsets
        } else {
            return UIEdgeInsets.zero
        }
    } else {
        return UIEdgeInsets.zero
    }
}

/// 屏幕的安全高度：屏幕高-上安全区域-下安全区域
private func cv_screen_height_safe() -> CGFloat {
    let insets = cv_safeAreaInsetsIn(view: cv_AppDelegate.window)
    return SCREEN_HEIGHT - insets.top - insets.bottom
}

/// 导航栏的高度：导航栏高（44）+ 状态栏高（普通的20，iPhoneX是44）
private func cv_navigation_height() -> CGFloat {
    let safeAreaTop: CGFloat = UIApplication.shared.statusBarFrame.size.height
    return 44.0 + safeAreaTop;
}

/// tabBar的高度：tabBar高（49）+ 下安全序区域（普通是0，iPhoneX是34）
private func cv_tabBar_height() -> CGFloat {
    let height = 49 + cv_safeAreaInsets.bottom
    return height
}


/// 国际化
func LS(key: String, comment: String?) -> String {
    return LS(nil, key: key, comment: comment)
}
func LS(_ target: Any?, key: String, comment: String?) -> String {
    
    // 第一步: 处理key， 如果 target存在，则从target中取header，如果不存在，则默认Common
    var header = ""
    if target != nil {
        header = "\(type(of: target!))."
    }
    var newKey = header + key //"\(header).\(key)"

    newKey = newKey.replacingOccurrences(of: ".Type", with: "")
    
    let path: String? = Bundle.main.path(forResource: header, ofType: "strings")
    var result: String = ""
    if path != nil {
        result = NSLocalizedString(newKey, tableName: header, comment: comment ?? key)
    } else {
        result = NSLocalizedString(newKey, comment: comment ?? key)
    }
//    if result == newKey { result = comment ?? key }
    return result
}


/// 目录路径
// Documents目录路径
let DocumentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
let LibraryPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
// Library/Caches目录路径方法
let CachesPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
// Library/Application Support目录路径
let ApplicationSupportPath = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)[0]
// tmp目录路径
let TmpPath = NSTemporaryDirectory()
// 沙盒主目录路径
let HomePath = NSHomeDirectory()


/// 取随机数
func cv_arc4random(min: UInt32 = 0, max: UInt32) -> UInt32 {
    guard max > min else { return 0 }
    return Darwin.arc4random() % max + min
}


/// 文本的位置
enum CVTextAlignment {
    case left
    case center
    case right
}

