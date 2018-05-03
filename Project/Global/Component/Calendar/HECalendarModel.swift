//
//  HECalendarModel.swift
//  Project
//
//  Created by weixhe on 2018/5/2.
//  Copyright © 2018年 com.weixhe. All rights reserved.
//

import Foundation

enum DayType {
    case empty          // 不显示
    case past           // 过去的日期
    case future         // 将来的日期
    case weekend        // 周末
    case workday        // 工作日
    case click          // 被选中的日期
}

protocol SomeCalendarProtocol {
    var dayType: Array<DayType>! {get set}
    var year: Int! {get set}
    var month: Int! {get set}
    var day: Int! {get set}
    var week: Int! {get set}
    var isEnable: Bool? {get set}      // 是否能被点击，过去的日期一定不可以点击，将来的日期可根据 ‘isEnable’ 判定
    var lunar: String? {get}        // 农历
    var lunar_year: String? {get}
    var lunar_month: String? {get}
    var lunar_day: String? {get}
    
    var holiday: String?  {get set}               // 假日
    
    
}

class HECalendarModel : SomeCalendarProtocol {
    var dayType: Array<DayType>!
    
    var year: Int!
    
    var month: Int!
    
    var day: Int!
    
    var week: Int!
    
    var isEnable: Bool?
    
    var isChineseCalendar: Bool!        // 是否是中国日历，若为true，则返回chineseCalendar， 若为false，则lunar不返回值
    var lunar: String?
    var lunar_year: String?
    var lunar_month: String?
    var lunar_day: String?
    
    var holiday: String?  // 节日分阳历节日，农历节日，农历二四节气中的节日
    
    var date: Date? {
        var component = DateComponents()
        component.year = year
        component.month = month
        component.day = day
        return Date.currentCalendar.date(from: component)
    }
    
    
    convenience init(year: Int, month: Int, day: Int) {
        self.init()
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
