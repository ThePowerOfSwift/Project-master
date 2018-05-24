//
//  Date+Extension.swift
//  Project
//
//  Created by caven on 2018/4/3.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import Foundation

private let D_MINUTE: Int     = 60
private let D_HOUR: Int       = 3600
private let D_DAY: Int        = 86400
private let D_WEEK: Int       = 604800
private let D_YEAR: Int       = 31556926


private let flags: Set = [Calendar.Component.year, Calendar.Component.month, Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second, Calendar.Component.weekday]
extension Date {
  
    /// 获取本地时间,  Date()是GMT时间，比本地时间少8个小时
    static var locatonDate: Date {
        get {
            return Date().formatTimeZone()
        }
    }
    
    /// 获取当前日历
    static let currentCalendar = Calendar(identifier: Calendar.Identifier.gregorian) //Calendar.current
    
    /// 这个月有多少天
    func daysInThisMonth() -> Int {
        let totaldaysInMonth: Range = Date.currentCalendar.range(of: .day, in: .month, for: self)!
        return totaldaysInMonth.count
    }
    
    /// 这个月有多少周
    func weeksInThisMonth() -> Int {
        
        let weekday = self.startOfThisMonth().weekInThisMonth() //[[self firstDayOfCurrentMonth] weeklyOrdinality];
        var days = self.daysInThisMonth()
        var weeks = 0;
        
        if (weekday > 1) {
            weeks += 1
            days -= (7 - weekday + 1)
        }
        weeks += days / 7;
        weeks += (days % 7 > 0) ? 1 : 0
        return weeks
    }
    
    
    /// 某日期是周几（1-周日， 2-周一 ...）
    func weekInThisMonth() -> Int {
        let week: Int = Date.currentCalendar.ordinality(of: .day, in: .weekOfMonth, for: self)!
        return week
    }
    
    /// 本月的第一天是周几（1-周日， 2-周一 ...）
    func firstWeeklyInThisMonth() -> Int {
        let firstDayInMonth: Date = "\(self.year)-\(self.month)-01".formatToDate("yyyy-MM-dd")!
        return firstDayInMonth.weekInThisMonth()
    }
    
    /// 本月的开始日期
    func startOfThisMonth() -> Date {
        let components = Date.currentCalendar.dateComponents(Set<Calendar.Component>([.year, .month]), from: self)
        let startOfMonth = Date.currentCalendar.date(from: components)!
        return startOfMonth.formatTimeZone()
    }
    
    /// 本月结束日期
    func endOfThisMonth(returnEndTime:Bool = false) -> Date {
        var components = DateComponents()
        components.month = 1
        if returnEndTime {
            components.second = -1
        } else {
            components.day = -1
        }
        
        let endOfMonth = Date.currentCalendar.date(byAdding: components, to: startOfThisMonth())!
        return endOfMonth.formatTimeZone()
    }
    
    /// 某个日期的起始时间（）
    func startOfThisDay() -> Date {
        let date: Date = "\(self.year)-\(self.month)-\(self.day) 00:00:00".formatToDate("yyyy-MM-dd HH:mm:ss")!
        return date.formatTimeZone()
    }
    /// 某个日期的结束时间（）
    func endOfThisDay() -> Date {
        let date: Date = "\(self.year)-\(self.month)-\(self.day) 23:59:59".formatToDate("yyyy-MM-dd HH:mm:ss")!
        return date.formatTimeZone()
    }
    
    /// 本日期在上个月的日期
    func dayInThePreviousMonth() -> Date {
        var component = DateComponents()
        component.month = -1
        return Date.currentCalendar.date(byAdding: component, to: self)!
    }
    
    /// 本日期在下个月的日期
    func dayInTheFollowingMonth() -> Date {
        var component = DateComponents()
        component.month = 1
        return Date.currentCalendar.date(byAdding: component, to: self)!
    }
    
    /// 本日期之前的几个月的日期
    func dayInThePreviousMonth(_ month: Int) -> Date {
        var component = DateComponents()
        component.month = -month
        return Date.currentCalendar.date(byAdding: component, to: self)!
    }
    
    /// 本日期之后几个月的日期
    func dayInTheFollowingMonth(_ month: Int) -> Date {
        var component = DateComponents()
        component.month = month
        return Date.currentCalendar.date(byAdding: component, to: self)!
    }
    
    /// 两个日期之间有多少个月
    static func monthsBetween(from: Date, to: Date) -> Int {
        return abs(Date.currentCalendar.dateComponents([.month], from: from, to: to).month! + 1)
    }
    
    /// 两个日期之间有多少周
    static func weeksBetween(from: Date, to: Date) -> Int {
        return abs(Date.currentCalendar.dateComponents([.weekOfYear], from: from, to: to).weekOfYear! + 1)
    }
    
    /// 两个日期之间有多少天
    static func daysBetween(from: Date, to: Date) -> Int {
        return abs(Date.currentCalendar.dateComponents(flags, from: from, to: to).day! + 1)
    }
    
    /// 通过数字返回周几, 周日是“1”，周一是“2”...
    func getWeekStringFromInt(_ week: Int) -> String {
        var str_week = ""
        switch (week) {
        case 1:
            str_week = "周日";
        case 2:
            str_week = "周一";
        case 3:
            str_week = "周二";
        case 4:
            str_week = "周三";
        case 5:
            str_week = "周四";
        case 6:
            str_week = "周五";
        case 7:
            str_week = "周六";
        default:
            str_week = ""
        }
        return str_week;
    }
    
    /// 判断 今天，明天，昨天
    func compareIfTodayWithDate() -> String {

        if self.isEqualToDate(Date()) {
            return "今天"
        } else if self.isEqualToDate(Date().addingDays(1)) {
            return "明天"
        } else if self.isEqualToDate(Date().addingDays(-1)) {
            return "昨天"
        }
        return self.getWeekStringFromInt(self.weekInThisMonth())
    }
}

// MARK: - 常用日期
extension Date {
    /// 返回当前日期 年份
    var year: Int {
        return Date.stringFormDate(self, format: "yyyy").toInt()!
    }
    /// 返回当前日期 月份
    var month: Int {
        return Date.stringFormDate(self, format: "MM").toInt()!
    }
    /// 返回当前日期 天
    var day: Int {
        return Date.stringFormDate(self, format: "dd").toInt()!
    }
    /// 返回当前日期 小时
    var hour: Int {
        return Date.stringFormDate(self, format: "HH").toInt()!
    }
    /// 返回当前日期 分钟
    var minute: Int {
        return Date.stringFormDate(self, format: "mm").toInt()!
    }
    /// 返回当前日期 秒数
    var second: Int {
        return Date.stringFormDate(self, format: "ss").toInt()!
    }
    
    /// 日期的不同格式，使用系统的转换方式
    /// 2018/4/4 下午3:49
    func shortString() -> String {
        return self.formatToString(dateStyle: .short, timeStyle: .short)
    }
    
    /// 下午3:53
    func shortTimeString() -> String {
        return self.formatToString(dateStyle: .none, timeStyle: .short)
    }
    
    /// 2018/4/4
    func shortDateString() -> String {
        return self.formatToString(dateStyle: .short, timeStyle: .none)
    }
    
    /// 2018年4月4日 下午3:54:20
    func mediumString() -> String {
        return self.formatToString(dateStyle: .medium, timeStyle: .medium)
    }
    
    /// 下午3:54:51
    func mediumTimeString() -> String {
        return self.formatToString(dateStyle: .none, timeStyle: .medium)
    }
    
    /// 2018年4月4日
    func mediumDateString() -> String {
        return self.formatToString(dateStyle: .medium, timeStyle: .none)
    }
    
    /// 2018年4月4日 GMT+8 下午3:55:27
    func longString() -> String {
        return self.formatToString(dateStyle: .long, timeStyle: .long)
    }
    
    /// GMT+8 下午3:56:45
    func longTimeString() -> String {
        return self.formatToString(dateStyle: .none, timeStyle: .long)
    }
    
    /// 2018年4月4日
    func longDateString() -> String {
        return self.formatToString(dateStyle: .long, timeStyle: .none)
    }
    
    /// 2018年4月4日 星期三 中国标准时间 下午3:57:15
    func fullString() -> String {
        return self.formatToString(dateStyle: .full, timeStyle: .full)
    }
    
    /// 中国标准时间 下午3:57:52
    func fullTimeString() -> String {
        return self.formatToString(dateStyle: .none, timeStyle: .full)
    }
    
    /// 2018年4月4日 星期三
    func fullDateString() -> String {
        return self.formatToString(dateStyle: .full, timeStyle: .none)
    }
}

// MARK: - 日期转换
extension Date {
    
    /// Date转换成String
    static func stringFormDate(_ date: Date, format: String = TimeFormat.format_yMd.rawValue) -> String {
        let formatter: DateFormatter = DateFormatter();
        formatter.dateFormat = format;
        return formatter.string(from: date)
    }
    
    /// String转换成Date
    static func dateFromString(_ string: String, format: String = TimeFormat.format_yMd.rawValue) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format;
        formatter.timeZone = TimeZone(secondsFromGMT: 0)        // 0时区
        return formatter.date(from: string)
    }
    
    /// 使用系统的转换方式
    func formatToString(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        return formatter.string(from: self)
    }
    
    /// 时区转换
    func formatTimeZone() -> Date {
        let interval = NSTimeZone.system.secondsFromGMT(for: Date())
        return self.addingTimeInterval(TimeInterval(interval))
    }
}

// MARK: - 日期加减
extension Date {
    
    /// 根据date获取其他的日期
    func addingYears(_ years: Int) -> Date {
        var component = DateComponents()
        component.year = years
        return Date.currentCalendar.date(byAdding: component, to: self)!
    }
    
    func addingMonths(_ months: Int) -> Date {
        var component = DateComponents()
        component.month = months
        return Date.currentCalendar.date(byAdding: component, to: self)!
    }
    
    func addingDays(_ days: Int) -> Date {
        var component = DateComponents()
        component.day = days
        return Date.currentCalendar.date(byAdding: component, to: self)!
    }
    
    func addingHours(_ hours: Int) -> Date {
        var component = DateComponents()
        component.hour = hours
        return Date.currentCalendar.date(byAdding: component, to: self)!
    }
    
    func addingMinutes(_ minutes: Int) -> Date {
        var component = DateComponents()
        component.minute = minutes
        return Date.currentCalendar.date(byAdding: component, to: self)!
    }
    
    func addingSeconds(_ seconds: Int) -> Date {
        var component = DateComponents()
        component.second = seconds
        return Date.currentCalendar.date(byAdding: component, to: self)!
    }
}

// MARK: - 日期间隔
extension Date {
    /// 两个日期相差多少天
    func daysBetweenDate(_ date: Date) -> Int {
        return Int(date.timeIntervalSince(self)) / D_DAY
    }
    
    /// 两个日期相差多少小时
    func hoursBetweenDate(_ date: Date) -> Int {
        return Int(date.timeIntervalSince(self)) / D_HOUR
    }
    
    /// 两个日期相差多少分
    func minutesBetweenDate(_ date: Date) -> Int {
        return Int(date.timeIntervalSince(self)) / D_MINUTE
    }
    
    /// 两个日期相差多少秒
    func secondsBetweenDate(_ date: Date) -> Int {
        return Int(date.timeIntervalSince(self))
    }
}

// MARK: - 日期对比
extension Date {
    /// 是否是周末
    func isWeekend() -> Bool {
        let component: DateComponents = Date.currentCalendar.dateComponents([.weekday], from: self)
        if component.weekday == 1 || component.weekday == 7 {
            return true
        }
        return false
    }
    
    /// 是否是工作日
    func isWorkDay() -> Bool {
        return !self.isWeekend()
    }
    
    func isToday() -> Bool {
        return isEqualToDate(Date())
    }
    
    /// 是否是明天
    func isTomorrow() -> Bool {
        return isEqualToDate(Date().addingDays(1))
    }
    
    /// 是否是昨天
    func isYesterday() -> Bool {
        return isEqualToDate(Date().addingDays(-1))
    }
    
    /// 是不是同一周
    func isTheSameWeek(_ date: Date) -> Bool {
        let component1 = Date.currentCalendar.dateComponents(flags, from: self)
        let component2 = Date.currentCalendar.dateComponents(flags, from: date)
        if component1.weekOfYear != component2.weekOfYear {
            return false
        }
        // 两个日期相差小于 7
        return fabs(self.timeIntervalSince(date)) < Double(D_WEEK)
    }
   
    
    enum DateCompareResult {
        case equal
        case earlier
        case later
    }
    
    /// 两个日期比较，返回比较结果
    func compare(_ date: Date, ignoreTime: Bool = true) -> DateCompareResult {
        let component1 = Date.currentCalendar.dateComponents(flags, from: self)
        let component2 = Date.currentCalendar.dateComponents(flags, from: date)
        let data1: Array<Int> = [component1.year!, component1.month!, component1.day!, component1.hour!, component1.minute!, component1.second!]
        let data2: Array<Int> = [component2.year!, component2.month!, component2.day!, component2.hour!, component2.minute!, component2.second!]
        let count = ignoreTime ? 3 : data1.count  // 忽略时间时，比较 year， month， day
        var result: DateCompareResult = .equal
        for i in 0..<count {
            if data1[i] > data2[i] {
                result = .later; break
            } else if data1[i] < data2[i] {
                result = .earlier; break
            }
        }
        return result
    }
    
    
    /// 两个日期是否相等，可忽略时间
    func isEqualToDate(_ date: Date, ignoreTime: Bool = true) -> Bool {
        return self.compare(date, ignoreTime: ignoreTime) == .equal
    }

    /// self 比 date 更早一些
    func isEarlierToDate(_ date: Date, ignoreTime: Bool = true) -> Bool {
        return self.compare(date, ignoreTime: ignoreTime) == .earlier
    }
    
    /// self 比 date 更晚一些
    func isLaterToDate(_ date: Date, ignoreTime: Bool = true) -> Bool {
        return self.compare(date, ignoreTime: ignoreTime) == .later
    }
}

// MARK: - 运算符重载
extension Date {
    static func ==(left: Date, right: Date) -> Bool {
        return left.isEqualToDate(right)
    }
    
    static func ===(left: Date, right: Date) -> Bool {
        return left.isEqualToDate(right, ignoreTime: false)
    }
    
    static func >(left: Date, right: Date) -> Bool {
        return left.isEarlierToDate(right)
    }
    
    static func >>(left: Date, right: Date) -> Bool {
        return left.isEarlierToDate(right, ignoreTime: false)
    }
    
    static func <(left: Date, right: Date) -> Bool {
        return left.isLaterToDate(right)
    }
    
    static func <<(left: Date, right: Date) -> Bool {
        return left.isLaterToDate(right, ignoreTime: false)
    }
}
