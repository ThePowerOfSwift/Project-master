//
//  CVUtil.swift
//  Project
//
//  Created by caven on 2018/4/27.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import Foundation

struct CVUtil {
    // MARK: - 字符串加密
    /// 手机号加密, 隐藏部分字符串
    static func encryptBy(secret: String = "****", phone: String) -> String {
        let newPhone: String = phone.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
        let result: String = (newPhone as NSString).replacingCharacters(in: NSMakeRange(3, 4), with: secret)
        return result
    }
    /// 银行卡加密, 隐藏部分字符串
    static func encryptBy(secret: String = "********", cardNum: String) -> String {
        let newCardNum: String = cardNum.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
        let result: String = (newCardNum as NSString).replacingCharacters(in: NSMakeRange(4, newCardNum.count - 8), with: secret)
        return result
    }
    // MARK: -
    // MARK: URL 编码
    /// url 编码
    static func urlEncode(_ url: String) -> String {
        guard url.count != 0 else { return url }
        let toUrl = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, url as CFString, "!$&'()*+,-./:;=?@_~%#[]" as CFString, nil, CFStringBuiltInEncodings.UTF8.rawValue)
//        let toUrl = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, url as CFString, nil, "!$&'()*+,-./:;=?@_~%#[]" as CFString, CFStringBuiltInEncodings.UTF8.rawValue)
        return toUrl! as String
    }
}
