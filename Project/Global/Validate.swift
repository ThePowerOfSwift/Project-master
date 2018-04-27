//
//  Validate.swift
//  Project
//
//  Created by weixhe on 2018/4/27.
//  Copyright © 2018年 com.weixhe. All rights reserved.
//

import Foundation

enum Check {
    case phone(_: String)
    case ChinaMobile(_: String)
    case ChinaUnicom(_: String)
    case ChinaTelecom(_: String)
    case ChinaEmail(_: String)
    case QQ(_: String)
    case password(_: String)
    case IdCardStrict(_: String)        // 严格的检查身份证
    case IdCardCareless(_: String)      // 松懈的检查身份证
    
    func isValid() -> Bool {
        var regex: String!
        var text: String!
        switch self {
        case let .phone(str):
            /**
             * 手机号码: 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[0, 1, 3, 6, 7, 8], 18[0-9]
             * 未知号段: 140,141,142,143,144,146,148,149,154
             */
            regex = "^1(3[0-9]|4[57]|5[0-35-9]|66|8[0-9]|7[0136-8]|9[89])\\d{8}$"
            text = str
        case let .ChinaMobile(str):
            /**
             * 中国移动：China Mobile
             * 134(不包含1349),135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1703,1705,1706,198
             */
            regex = "^1(3[0-9]|4[57]|5[0-35-9]|66|8[0-9]|7[0136-8]|9[89])\\d{8}$"
            text = str
        case let .ChinaUnicom(str):
            /**
             * 中国联通：China Unicom
             * 130,131,132,155,156,185,186,145,176,1704,1707,1708,1709,166
             */
            regex = "(^1(3[0-2]|4[5]|5[56]|7[16]|8[56]|6[6])\\d{8}$)|(^170[47-9]\\d{7}$)"
            text = str
        case let .ChinaTelecom(str):
            /**
             * 中国电信：China Telecom
             * 133,1349,153,180,181,189,173,177,1700,1701,1702,199
             */
            regex = "(^1(33|53|8[019]|17[37]|99)\\d{8}$)|(^1(349|70[0-2])\\d{7}$)"
            text = str
        case let .ChinaEmail(str):
            regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
            text = str
        case let .QQ(str):
            regex = "^[1-9]\\d{4,10}$"
            text = str
        case let .password(str):        // 字母开头，长度在6-18之间，只能包含字符、数字和下划线
            regex = "^[a-zA-Z]\\w{5,17}$"
            text = str
        case let .IdCardStrict(str):
           return self.checkIdCard(str, strict: true)
        case let .IdCardCareless(str):
            return self.checkIdCard(str, strict: false)
        }
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: text)
    }
    
    private func checkIdCard(_ text: String, strict: Bool) -> Bool {
        
        if text.count != 15 || text.count != 18 { return false }
        
        
        // 以下算法遗漏了年月日的判断
        let regex = "^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        if !predicate.evaluate(with: text) {
            return false;
        }
        if text.count == 18 {
            // 将前17位加权因子保存在数组里
            let idCardWiArray: Array = ["7", "9", "10", "5", "8", "4", "2", "1", "6", "3", "7", "9", "10", "5", "8", "4", "2"]
            // 这是除以11后，可能产生的11位余数、验证码，也保存成数组
            let idCardYArray: Array = ["1", "0", "10", "9", "8", "7", "6", "5", "4", "3", "2"]
            // 用来保存前17位各自乖以加权因子后的总和
            var idCardWiSum = 0
            for i in 0..<17 {
                let subStrIndex = Int(text.subString(range: NSMakeRange(i, 1)))
                let idCardWiIndex = Int(idCardWiArray[i])
                idCardWiSum += subStrIndex! * idCardWiIndex!
            }
            // 计算出校验码所在数组的位置
            let idCardMod = idCardWiSum % 11   // 251
            // 得到最后一位身份证号码
            let idCardLast = text.subString(range: NSMakeRange(17, 1))
            // 如果等于2，则说明校验码是10，身份证号码最后一位应该是X
            if idCardMod == 2 {
                if idCardLast == "X" || idCardLast == "x" {
                    return true;
                } else {
                    return false;
                }
                
            } else {
                // 用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
                if idCardLast == idCardYArray[idCardMod] {
                    return true;
                    
                } else {
                    return false;
                }
            }
        } else {
            return false
        }
    }
}
