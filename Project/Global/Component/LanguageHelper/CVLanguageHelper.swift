//
//  CVLanguageHelper.swift
//  Project
//
//  Created by caven on 2018/3/14.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit

public let kCVAppWillChangeLanguageNotification =  NSNotification.Name(rawValue: "CV_app_will_change_language")

private let kSupportLanguage = "CV_support_language_key"
private let kCurrentLanguage = "CV_current_language_key"
private let kSysLanguage = "FollowSystem"
private let kAutoLanguage = "CV_auto_language"
private let kUniqueSimplifiedChinese = "unique_simplified_chinese"
private var kBundlePath = "CV_cus_bundle_path"
class CVLanguageHelper: NSObject, SelfAware {
    
    // 该方法相当于OC中的load()方法
    static func awake() {
        object_setClass(Bundle.main, CVBundleEX.self /*NSClassFromString("HEBundleEX")*/)
        let language = CVLanguageHelper.getLanguage()
        if language != kSysLanguage {   // 自定义的语言
            self.setLanguage(language: language)
        } else {
            // 跟随系统语言
            self.restoreSysLanguage()
        }
        
    }
    
    /// 设置语言
    class func setLanguage(language: String) {
        var path: String? = Bundle.main.path(forResource: language, ofType: "lproj")
        COM.setValue(nil, forKey: kAutoLanguage)
        if path != nil {    // 如果 path 存在，则为自定义语言
            COM.setValue(language, forKey: kCurrentLanguage)
        } else {    // 否则，其他的都是跟随系统语言
            COM.setValue(kSysLanguage, forKey: kCurrentLanguage)
            // 先判断app是否支持当前系统语言
            var willLanguage: String?
            for sysLanguage in Locale.preferredLanguages {
                for lan in self.getSupportLanguage() {
                    if sysLanguage.lowercased().hasPrefix(lan.lowercased()) {
                        path = Bundle.main.path(forResource: lan, ofType: "lproj")
                        willLanguage = lan
                        break
                    }
                }
                
                // 如果系统语言app内刚好支持
                if willLanguage != nil {
                    // 即将设置语言，直接跳出
                    COM.setValue(willLanguage, forKey: kAutoLanguage)
                    break
                }
            }
            
            // 如果首选语言列表中的语言app都不支持，则默认显示app所支持语言的第一个
            if willLanguage == nil {
                let language = self.getSupportLanguage().first
                path = Bundle.main.path(forResource: language, ofType: "lproj")
                COM.setValue(language, forKey: kAutoLanguage)
            }
        }
        COM.setValue(path, forKey: kBundlePath)
        NotificationCenter.default.post(name: kCVAppWillChangeLanguageNotification, object: nil)
    }
    
    /// 获取当前设置的语言, 若为跟随系统语言，则返回“FollowSystem”
    class func getLanguage() -> String {
        let language = COM.value(forKey: kCurrentLanguage) as? String
        return language ?? kSysLanguage
    }
    
    /// 获取当前正在运行中的语言，如果语言设置为‘跟随系统’，则根据语言列表获取app运行的语言
    class func getCurrentRunningLanguage() -> String {
        var language = getLanguage()
        if language == kSysLanguage {
            language = COM.value(forKey: kAutoLanguage) as! String
        }
        return language
    }
    
    /// 恢复跟随系统语言
    class func restoreSysLanguage() {
        self.setLanguage(language: kSysLanguage)
    }
    
    /// 设置app支持的语言
    class func setSupportLanguage(languages: [String]) {
        COM.setValue(languages, forKey: kSupportLanguage)
    }
    
    /// 获取自定义的app支持语言
    private class func getSupportLanguage() -> [String] {
        let lags = COM.value(forKey: kSupportLanguage) as? Array<String>
        return lags != nil ? lags! : []
    }
}


class CVBundleEX: Bundle {
    
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        let path = COM.value(forKey: kBundlePath) as? String
        if path != nil ,let bundle = Bundle(path: path!) {
            return bundle.localizedString(forKey: key, value: value, table: tableName)
        }
        return super.localizedString(forKey: key, value: value, table: tableName)
    }
}


