//
//  NSRange+Extension.swift
//  Project
//
//  Created by weixhe on 2018/4/27.
//  Copyright © 2018年 com.weixhe. All rights reserved.
//

import Foundation

extension NSRange {
    /// 将 NSRange 转换成 Range
    func toRange(string: String) -> Range<String.Index> {
        let startIndex = string.index(string.startIndex, offsetBy: self.location)
        let endIndex = string.index(startIndex, offsetBy: self.length)
        return startIndex..<endIndex
    }
}