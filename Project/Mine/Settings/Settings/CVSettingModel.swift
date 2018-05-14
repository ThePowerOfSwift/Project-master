//
//  CVSettingModel.swift
//  Project
//
//  Created by caven on 2018/3/23.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import Foundation


enum CVSettingCellKey: String {
    case language = "language"
    case cleanCache = "cleanCache"
    case appVersion = "appVersion"

}

class CVSettingModel {
    var title: String
    var key: CVSettingCellKey     // key表示某行cell是
    var detail: String?
    
    init(_ title: String, _ key: CVSettingCellKey, _ detail: String?) {
        self.title = title
        self.key = key
        self.detail = detail
    }
}
