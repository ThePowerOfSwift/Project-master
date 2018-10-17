//
//  StringhHelper.swift
//  StringhHelper
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
        guard self.isInt() else {
            return nil
        }
        return Int(self)
    }
    
    func formatToDate(_ format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter: DateFormatter = DateFormatter();
        dateFormatter.dateFormat = format;
        return dateFormatter.date(from: self)
    }
    
    // MARK: - 字符串 range <-> nsRange
    /// Range转换为NSRange
    func nsRange(from range: Range<String.Index>) -> NSRange {
        
        guard let from = range.lowerBound.samePosition(in: utf16), let to = range.upperBound.samePosition(in: utf16) else {
            return NSMakeRange(0, 0)
        }
        return NSMakeRange(utf16.distance(from: utf16.startIndex, to: from), utf16.distance(from: from, to: to))
    }
    
    /// Range转换为NSRange
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex) else { return nil }
        guard let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex) else { return nil }
        guard let from = String.Index(from16, within: self) else { return nil }
        guard let to = String.Index(to16, within: self) else { return nil }
        return from ..< to
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
    
    /// 过滤掉首尾空格, 根据参数判断是否过滤换行符
    /// trimNewline 是否过滤略行符，默认为false
    public func trim(trimNewline: Bool = false) -> String {
        if trimNewline {  //  忽略掉换行符
            return self.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    /// 过滤掉换行符
    public func trimNewlines() -> String {
        return self.trimmingCharacters(in: .newlines)
    }
}

// MARK: - 字符串的判断
extension String {
    
    /// 判断字符串是 数字
    func isInt() -> Bool {
        let scan: Scanner = Scanner(string: self)
        var val: Int = 0
        return scan.scanInt(&val) && scan.isAtEnd
    }
    
    /// 判断字符串是 空， trimWhiteSpace: 是否过滤首尾空格，默认为true
    func isBlank(trimWhiteSpace: Bool = true) -> Bool {
        var newString = self
        
        if trimWhiteSpace { // 过滤空格
            newString = self.trim()
        }
        if newString.isEmpty {
            return true
        }
        return false
    }
}

// MARK: - 字符串富文本
extension String {

    /// 通用的设置富文本方法，返回attribute，可以再次设置富文本
    public func setAttribute(_ name: NSAttributedStringKey, value: Any, range: NSRange) -> NSMutableAttributedString? {
        guard self.count > 0 else { return nil }
        let attributeStr = NSMutableAttributedString(string: self)
        attributeStr.addAttribute(name, value: value, range: range)
        return attributeStr
    }
    
    /// 通用的设置富文本方法，返回attribute，可以再次设置富文本
    public func setAttribute(_ name: NSAttributedStringKey, value: Any, string: String) -> NSMutableAttributedString? {
        guard self.count > 0 else { return nil }
        let attributeStr = NSMutableAttributedString(string: self)
        attributeStr.addAttribute(name, value: value, range: self.nsRange(from: self.range(of: string)!))
        return attributeStr
    }
    
    /// 将数字转换成某一颜色, 字体
    public func setNumberColor(_ color: UIColor) -> NSMutableAttributedString? {
        return self.setNumberColor(color, font: nil)
    }
    
    public func setNumberFont(_ font: UIFont) -> NSMutableAttributedString? {
        return self.setNumberColor(nil, font: font)
    }
    public func setNumberColor(_ color: UIColor?, font: UIFont?) -> NSMutableAttributedString? {
        if self.isBlank() {
            return nil
        }
        let attributeStr = NSMutableAttributedString(string: self)
        let numbers = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        for (index, c) in self.enumerated() {
            if numbers.contains(String(c)) {
                if let color = color {
                    attributeStr.addAttribute(.foregroundColor, value: color, range: NSMakeRange(index, 1))
                }
                if let font = font {
                    attributeStr.addAttribute(.font, value: font, range: NSMakeRange(index, 1))
                }
            }
        }
        return attributeStr
    }
    
    /// 设置文字的行距
    public func setLineSpace(_ lineSpace: CGFloat) -> NSMutableAttributedString? {
        if self.isBlank() {
            return nil
        }
        let attributeStr = NSMutableAttributedString(string: self)
        return attributeStr.addLineSpace(lineSpace)
    }
    
    /// 设置文字的段间距
    public func setParagraphSpace(_ paragraphSpacing: CGFloat) -> NSMutableAttributedString? {
        if self.isBlank() {
            return nil
        }
        let attributeStr = NSMutableAttributedString(string: self)
        return attributeStr.addParagraphSpace(paragraphSpacing)
    }
    
    /// 设置文字的段间距、行间距
    public func addLineSpace(_ lineSpace: CGFloat?, paragraphSpacing: CGFloat?) -> NSMutableAttributedString? {
        if self.isBlank() {
            return nil
        }
        let attributeStr = NSMutableAttributedString(string: self)
        return attributeStr.addLineSpace(lineSpace, paragraphSpacing: paragraphSpacing)
    }
    
    /// 设置文字的间距
    public func addKern(_ kern: CGFloat) -> NSMutableAttributedString? {
        if self.isBlank() {
            return nil
        }
        let attributeStr = NSMutableAttributedString(string: self)
        return attributeStr.addKern(kern)
    }
}

// MARK: - 富文本
extension NSMutableAttributedString {
    /// 通用的设置富文本方法，返回attribute，可以再次设置富文本
    public func addAttribute(_ name: NSAttributedStringKey, value: Any, string: String) -> NSMutableAttributedString? {
        guard self.string.count > 0 else { return nil }
        self.addAttribute(name, value: value, range: self.string.nsRange(from: self.string.range(of: string)!))
        return self
    }
    
    /// 设置文字的行间距
    public func addLineSpace(_ lineSpace: CGFloat) -> NSMutableAttributedString? {
        if self.string.isBlank() {
            return nil
        }
        return self.addLineSpace(lineSpace, paragraphSpacing: nil)
    }
    
    /// 设置文字的段间距
    public func addParagraphSpace(_ paragraphSpacing: CGFloat) -> NSMutableAttributedString? {
        if self.string.isBlank() {
            return nil
        }
        
        return self.addLineSpace(nil, paragraphSpacing: paragraphSpacing)
    }
    
    /// 设置文字的段间距、行间距
    public func addLineSpace(_ lineSpace: CGFloat?, paragraphSpacing: CGFloat?) -> NSMutableAttributedString? {
        if self.string.isBlank() {
            return nil
        }
        let paragraph = NSMutableParagraphStyle()
        if let space = lineSpace { paragraph.lineSpacing = space }
        if let space = paragraphSpacing { paragraph.paragraphSpacing = space }
        self.addAttribute(.paragraphStyle, value: paragraph, range: NSMakeRange(0, self.string.count))
        return self
    }
    
    /// 设置文字的间距
    public func addKern(_ kern: CGFloat) -> NSMutableAttributedString? {
        if self.string.isBlank() {
            return nil
        }
        return self.addAttribute(NSAttributedStringKey.kern, value: kern, string: self.string)
    }
}
