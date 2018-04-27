//
//  HESettingModel.swift
//  Project
//
//  Created by weixhe on 2018/3/23.
//  Copyright © 2018年 com.weixhe. All rights reserved.
//

import Foundation


enum HESettingCellKey: String {
    case language = "language"
    case cleanCache = "cleanCache"
    case appVersion = "appVersion"

}

class HESettingModel {
    var title: String
    var key: HESettingCellKey     // key表示某行cell是
    var detail: String?
    
    init(_ title: String, _ key: HESettingCellKey, _ detail: String?) {
        self.title = title
        self.key = key
        self.detail = detail
    }
}
