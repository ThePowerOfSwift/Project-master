//
//  CVDeviceModel.swift
//  Project
//
//  Created by caven on 2018/7/9.
//  Copyright © 2018年 com.caven. All rights reserved.
//

/**
 *   @brief 设备型号
 */
import Foundation

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
