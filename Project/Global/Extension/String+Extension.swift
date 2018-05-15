//
//  String+Extension.swift
//  CVKeyboardTextField
//
//  Created by caven on 2018/3/2.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import Foundation
import UIKit

public extension String {
    
    // MARM: 字符串 计算宽高
    func autoHeight(fixedWidth: CGFloat, attributes: [NSAttributedStringKey : Any]) -> CGFloat {
        guard self.count > 0 && fixedWidth > 0 else { return 0 }
        let text = self as NSString
        let size = CGSize(width:fixedWidth, height:9999)
        let rect = text.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attributes, context: nil)
        return rect.size.height
    }

    func autoHeight(font: UIFont, fixedWidth: CGFloat) -> CGFloat {
        guard self.count > 0 && fixedWidth > 0 else { return 0 }
        let size = CGSize(width:fixedWidth, height:9999)
        let text = self as NSString
        let rect = text.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedStringKey.font : font], context: nil)
        return rect.size.height
    }
    
    func autoWidth(fixedHeight: CGFloat, attributes: [NSAttributedStringKey : Any]) -> CGFloat {
        guard self.count > 0 && fixedHeight > 0 else { return 0 }
        let text = self as NSString
        let size = CGSize(width:9999, height:fixedHeight)
        let rect = text.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attributes, context: nil)
        return rect.size.width
    }
    
    func autoWidth(font: UIFont, fixedHeight: CGFloat) -> CGFloat {
        guard self.count > 0 && fixedHeight > 0 else { return 0 }
        let size = CGSize(width:9999, height:fixedHeight)
        let text = self as NSString
        let rect = text.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedStringKey.font : font], context: nil)
        return rect.size.width
    }
    
    // MARM: 字符串包含
    func contains(find: String) -> Bool {
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool {
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    
    // MARK: 字符串转换
    func toInt() -> Int? {
        return Int(self)
    }
    
    func formatToDate(_ format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter: DateFormatter = DateFormatter();
        dateFormatter.dateFormat = format;
        return dateFormatter.date(from: self)
    }
}

extension String {
    
    /// 字符串时间转换（返回 x分钟前/x小时前/昨天/x天前/x个月前/x年前
    /// 注意，格式必须正确 只接受 yyyy-MM-dd HH:mm:ss 类型字符 否则转换出错
    func convertToShaft() -> String {
        // 把字符串转为NSdate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date: Date = dateFormatter.date(from: self)!
        
        let currentDate = Date()
        let time: TimeInterval = -(date.timeIntervalSince(currentDate))
        
        let year: Int = (Int)(currentDate.year - date.year);
        let month: Int = (Int)(currentDate.month - date.month);
        let day: Int = (Int)(currentDate.day - date.day);
        
        var retTime: TimeInterval = 1.0;
        
        // 小于一小时
        if (time < 3600) {
            retTime = time / 60
            retTime = retTime <= 0.0 ? 1.0 : retTime
            if (retTime.format(".0") == "0") { return "刚刚" } else { return retTime.format(".0") + "分钟前" }
        } else if (time < 3600 * 24) {    // 小于一天，也就是今天
            retTime = time / 3600
            retTime = retTime <= 0.0 ? 1.0 : retTime
            return retTime.format(".0") + "小时前"
        } else if (time < 3600 * 24 * 2) {    // 昨天
            return "昨天"
        }
        // 第一个条件是同年，且相隔时间在一个月内
        // 第二个条件是隔年，对于隔年，只能是去年12月与今年1月这种情况
        else if ((abs(year) == 0 && abs(month) <= 1) || (abs(year) == 1 &&  currentDate.month == 1 && date.month == 12)) {
            var   retDay:Int = 0;
            // 同年
            if (year == 0) {
                // 同月
                if (month == 0) {
                    retDay = day;
                }
            }
            
            if (retDay <= 0) {
                // 这里按月最大值来计算
                // 获取发布日期中，该月总共有多少天
                let totalDays: Int = date.daysInThisMonth()
                
                // 当前天数 + （发布日期月中的总天数-发布日期月中发布日，即等于距离今天的天数）
                retDay = currentDate.day + (totalDays - date.day)
                
                if (retDay >= totalDays) {
                    let value = abs(max(retDay / date.daysInThisMonth(), 1))
                    return  value.description + "个月前"
                }
            }
            return abs(retDay).description + "天前"
        } else  {
            if (abs(year) <= 1) {
                if (year == 0) { // 同年
                    return abs(month).description + "个月前"
                }
                // 相差一年
                let month: Int = currentDate.month
                let preMonth: Int = date.month
                
                // 隔年，但同月，就作为满一年来计算
                if (month == 12 && preMonth == 12) {
                    return "1年前"
                }
                // 也不看，但非同月
                return abs(12 - preMonth + month).description + "个月前"
            }
            return abs(year).description + "年前"
        }
    }
}

// MARK: - 字符串的截取
extension String {
    public func subString(from index: Int) -> String {
        if self.count > index {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let subString = self[startIndex..<self.endIndex]
            return String(subString)
        } else {
            return self
        }
    }
    
    public func subString(to index: Int) -> String {
        if self.count > index {
            let endIndex = self.index(self.startIndex, offsetBy: index)
            let subString = self[self.startIndex..<endIndex]
            return String(subString)
        } else {
            return self
        }
    }
    
    public func subString(from: Int, to: Int) -> String {
        if to > from && self.count >= to {
            let startIndex = self.index(self.startIndex, offsetBy: from)
            let endIndex = self.index(self.startIndex, offsetBy: to)
            let subString = self[startIndex..<endIndex]
            return String(subString)
        } else {
            return self
        }
    }
    
    public func subString(range: NSRange) -> String {
        let from: Int = range.location;
        let to: Int = range.length + from
        return subString(from: from, to: to)
    }
}
