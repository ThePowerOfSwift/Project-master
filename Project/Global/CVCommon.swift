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

}


