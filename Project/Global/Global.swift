//
//  Global.swift
//  HEKeyboardTextField
//
//  Created by weixhe on 2018/3/1.
//  Copyright © 2018年 com.weixhe. All rights reserved.
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
func HELog<N>(message: N, file: String = #file, method: String = #function, line: Int = #line) {
    #if DEBUG // 若是Debug模式下，则打印
        let fileName = (file as NSString).lastPathComponent
        print("\n文件名: \(fileName)\n方法: \(method)\n行号: \(line)\n打印信息: \(message)");
    #endif
}

/// 屏幕尺寸
let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height
let SCREEN_HEIGHT_S = screen_height_safe()
let appDelegate = UIApplication.shared.delegate as! AppDelegate

/// 系统版本
let IOS8 = (UIDevice.current.systemVersion as NSString).doubleValue >= 8.0
let IOS9 = (UIDevice.current.systemVersion as NSString).doubleValue >= 9.0
let IOS10 = (UIDevice.current.systemVersion as NSString).doubleValue >= 10.0
let IOS11 = (UIDevice.current.systemVersion as NSString).doubleValue >= 11.0

/// 根据 375 的设计图，进行尺寸变换
let kFormat_375 = SCREEN_WIDTH / 375;
func kFormat_375(x: CGFloat) -> CGFloat {
    return kFormat_375 * x
}
/** 这个参数,看公司项目UI图 具体是哪款机型,默认  iphone6
 RealUISrceenWidth  (4/4s 5/5s) 320.0  (6/6s 7/7s 8/8s) 375.0  (6p/6sp 7p/7ps 8p/8ps)  414.0 (x) 375
 RealUISrceenHeight (4/4s) 修改480 (5/5s) 568.0  (6/6s 7/7s 8/8s) 667.0  (6p/6sp 7p/7ps 8p/8ps) 736.0  (x) 812 (备用)
 */

/// 系统版本号
let SysVersion = UIDevice.current.systemVersion
/// 系统名称("iOS", "tvOS", "watchOS", "macOS")
let SysName = UIDevice.current.systemName
/// 设备名称
let DeviceName = PhoneDeviceModel.get()

/// 安全区域
func safeAreaInsetsIn(view: UIView?) -> UIEdgeInsets {
    
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

func screen_height_safe() -> CGFloat {
    let insets = safeAreaInsetsIn(view: appDelegate.window)
    return SCREEN_HEIGHT - insets.top - insets.bottom
}


func navigation_height() -> CGFloat {
//    if #available(iOS 11.0, *) {
        let safeAreaTop: CGFloat = UIApplication.shared.statusBarFrame.size.height
        return 44.0 + safeAreaTop;
//    } else {
//        return 64.0;
//    }
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

// MARK: 获取手机设备型号  4s 5 5s 6 6p
// 获取手机型号 5s 6 6p 6ps等
enum PhoneDeviceModel {
    // 获取手机设备型号
    static func get() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 , value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone4"
        case "iPhone4,1":                               return "iPhone4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone5s"
        case "iPhone8,4":                               return "iPhoneSE"
        case "iPhone7,2":                               return "iPhone6"
        case "iPhone7,1":                               return "iPhone6Plus"
        case "iPhone8,1":                               return "iPhone6s"
        case "iPhone8,2":                               return "iPhone6sPlus"
        case "iPhone9,1":                               return "iPhone7"
        case "iPhone9,2":                               return "iPhone7Plus"
        case "iPhone10,1":                              return "iPhone8"
        case "iPhone10,2":                              return "iPhone8Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPadAir"
        case "iPad5,3", "iPad5,4":                      return "iPadAir2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPadMini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPadMini2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPadMini3"
        case "iPad5,1", "iPad5,2":                      return "iPadMini4"
        case "iPad6,7", "iPad6,8":                      return "iPadPro"
        case "AppleTV5,3":                              return "AppleTV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return "processor"
        }
    }
}

