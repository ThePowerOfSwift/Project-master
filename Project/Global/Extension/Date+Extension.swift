//
//  Date+Extension.swift
//  Project
//
//  Created by weixhe on 2018/4/3.
//  Copyright © 2018年 com.weixhe. All rights reserved.
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
    static let currentCalendar = Calendar.current
    
    /// 某个日期的起始时间（）
    func dateForStart() -> Date {
        let date: Date = "\(self.year)-\(self.month)-\(self.day) 00:00:00".formatToDate("yyyy-MM-dd HH:mm:ss")!
        return date.formatTimeZone()
    }
    /// 某个日期的结束时间（）
    func dateForEnd() -> Date {
        let date: Date = "\(self.year)-\(self.month)-\(self.day) 23:59:59".formatToDate("yyyy-MM-dd HH:mm:ss")!
        return date.formatTimeZone()
    }
    
    /// date所在的月有几天
    static func daysInThisMonth(_ date: Date) -> Int {
        return date.daysInThisMonth()
    }
    func daysInThisMonth() -> Int {
        let totaldaysInMonth: Range = Date.currentCalendar.range(of: .day, in: .month, for: self)!
        return totaldaysInMonth.count
    }
    
    /// date在当月的是周几（0-周日， 1-周一 ...）
    static func weekInThisMonth(_ date: Date) -> Int {
        return date.weekInThisMonth()
    }
    func weekInThisMonth() -> Int {
        let week: Int = Date.currentCalendar.ordinality(of: .day, in: .weekOfMonth, for: self)!
        return week - 1
    }
    
    /// date所在的月份的第一天是周几（0-周日， 1-周一 ...）
    static func firstWeekInThisMonth(_ date: Date) -> Int {
        return date.firstWeekInThisMonth()
    }
    
    func firstWeekInThisMonth() -> Int {
        let firstDayInMonth: Date = "\(self.year)-\(self.month)-01".formatToDate("yyyy-MM-dd")!
        return firstDayInMonth.weekInThisMonth()
    }
}

// MARK: - 常用日期
extension Date {
    /// 返回当前日期 年份
    var year: Int {
        return formatToString("yyyy").toInt()!
    }
    /// 返回当前日期 月份
    var month: Int {
        return formatToString("MM").toInt()!
    }
    /// 返回当前日期 天
    var day: Int {
        return formatToString("dd").toInt()!
    }
    /// 返回当前日期 小时
    var hour: Int {
        return formatToString("HH").toInt()!
    }
    /// 返回当前日期 分钟
    var minute: Int {
        return formatToString("mm").toInt()!
    }
    /// 返回当前日期 秒数
    var second: Int {
        return formatToString("ss").toInt()!
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
    /// 获取yyyy  MM  dd  HH mm ss
    func formatToString(_ format: String) -> String {
        let formatter: DateFormatter = DateFormatter();
        formatter.dateFormat = format;
        return formatter.string(from: self)
    }
    
    /// 使用系统的转换方式
    func formatToString(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        return formatter.string(from: self)
    }
    
    /// String转换成Date
    static func formatFromString(_ string: String, format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format;
        formatter.timeZone = TimeZone(secondsFromGMT: 0)        // 0时区
        return formatter.date(from: string)
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
