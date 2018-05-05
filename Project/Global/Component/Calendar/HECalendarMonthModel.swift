//
//  HECalendarMonthModel.swift
//  Project
//
//  Created by weixhe on 2018/5/4.
//  Copyright © 2018年 com.weixhe. All rights reserved.
//

import Foundation

class HECalendarMonthModel {
    
    var date: Date {             // 年-月
        return Date.dateFromString(dateString, format: yyyy_MM_dd)!
    }
    var dateString: String {     // 年-月
        return "\(year)-\(month)"
    }
    var year: Int
    var month: Int
    
    var isChineseCalendar: Bool!        // 是否是中国日历，若为true，则返回chineseCalendar， 若为false，则lunar不返回值
    var lunar: String?
    var lunar_year: String?
    var lunar_month: String?
    
    var days: [HECalendarModel]
    
    
    init(year: Int, month: Int, days: [HECalendarModel]) {
        self.year = year
        self.month = month
        self.days = days
    }
}
