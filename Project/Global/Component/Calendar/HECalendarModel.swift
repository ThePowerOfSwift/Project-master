//
//  HECalendarModel.swift
//  Project
//
//  Created by weixhe on 2018/5/2.
//  Copyright © 2018年 com.weixhe. All rights reserved.
//

import Foundation
import UIKit

enum DayType {
    case empty          // 显示空白
    case past           // 过去的日期
    case workday        // 工作日
    case weekend        // 周末
    case holiday        // 节假日
}

enum HolidaySort: String {
    case solar = "solar"  // 公历
    case lunar = "lunar"  // 农历
    case solarTerm = "solarTerm" // 二十四节气
}

class HECalendarModel {
    var dayType: DayType = .empty
    
    var year: Int
    var month: Int
    var day: Int
    var week: Int!
    var date: Date {
        return Date.dateFromString("\(year)-\(month)-\(day)", format: yyyy_MM_dd)!
    }
    
    var isDisplayChineseCalendar: Bool!        // 是否是中国日历，若为true，则返回chineseCalendar， 若为false，则lunar不返回值
    var lunar: String?
    var lunar_year: String?
    var lunar_month: String?
    var lunar_day: String?
    
    var isDisplayHoliday: Bool!        // 是否展示节日
    var holiday: [String]?  // 节日顺序：[公历节日，农历节日，二十四节气]
    
    var isEnable: Bool = true   // 能否被点击
    var isSelected = false  // 是否被选中
    
    
    init(year: Int, month: Int, day: Int) {
        self.year = year
        self.month = month
        self.day = day
    }
    
//     func calendar(year: Int, month: Int, day: Int) -> HECalendarModel {
//        let model = HECalendarModel()
//        model.year = year
//        model.month = month
//        model.day = day
//        return model
//    }
}
