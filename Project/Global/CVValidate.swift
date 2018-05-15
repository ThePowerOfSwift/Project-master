//
//  CVValidate.swift
//  Project
//
//  Created by caven on 2018/4/27.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import Foundation

class CVCheck {
    /// 检查手机号
    class func phone(_ text: String) -> Bool {
        return CVValidate.phone(text).isValid()
    }
    
    /// 检查手机号：中国移动
    class func ChinaMobile(_ text: String) -> Bool {
        return CVValidate.ChinaMobile(text).isValid()
    }
    
    /// 检查手机号：中国联通
    class func ChinaUnicom(_ text: String) -> Bool {
        return CVValidate.ChinaUnicom(text).isValid()
    }
    
    /// 检查手机号：中国电信
    class func ChinaTelecom(_ text: String) -> Bool {
        return CVValidate.ChinaTelecom(text).isValid()
    }
    
    /// 检查邮箱
    class func Email(_ text: String) -> Bool {
        return CVValidate.Email(text).isValid()
    }
    
    /// 检查QQ
    class func QQ(_ text: String) -> Bool {
        return CVValidate.QQ(text).isValid()
    }
    
    /// 检查密码（字母开头，长度在6-18之间，只能包含字符、数字和下划线）
    class func password(_ text: String) -> Bool {
        return CVValidate.password(text).isValid()
    }
    
    /// 检查身份证： 严格的
    class func IdCardStrict(_ text: String) -> Bool {
        return CVValidate.IdCardStrict(text).isValid()
    }
    
    /// 检查身份证： 模糊的
    class func IdCardCareless(_ text: String) -> Bool {
        return CVValidate.IdCardCareless(text).isValid()
    }
    
    /// 检查纯数字
    class func number(_ text: String) -> Bool {
        return CVValidate.number(text).isValid()
    }
    
    /// 检查纯字母
    class func alphabet(_ text: String) -> Bool {
        return CVValidate.alphabet(text).isValid()
    }
    
    /// 检查纯汉字
    class func chinese(_ text: String) -> Bool {
        return CVValidate.chinese(text).isValid()
    }
    
    /// 检查数字+字母
    class func numberAndAlphabet(_ text: String) -> Bool {
        return CVValidate.numberAndAlphabet(text).isValid()
    }
    
}

private enum CVValidate {
    case phone(_: String)
    case ChinaMobile(_: String)
    case ChinaUnicom(_: String)
    case ChinaTelecom(_: String)
    case Email(_: String)
    case QQ(_: String)
    case password(_: String)
    case IdCardStrict(_: String)        // 严格的检查身份证
    case IdCardCareless(_: String)      // 松懈的检查身份证
    case number(_: String)
    case alphabet(_: String)
    case chinese(_: String)
    case numberAndAlphabet(_: String)
    
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
        case let .Email(str):
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
        case let .number(str):
            regex = "^[0-9]*$"
            text = str
        case let .alphabet(str):
            regex = "^[A-Za-z]+$"
            text = str
        case let .chinese(str):
            regex = "[\\u4e00-\\u9fa5]+"
            text = str
        case let .numberAndAlphabet(str):
            regex = "^[A-Za-z0-9]+$"
            text = str
        }
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: text)
    }
    
    private func checkIdCard(_ text: String, strict: Bool) -> Bool {
        
        let idCard = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if idCard.count != 15 && idCard.count != 18 {
            return false
        }
        // 省份代码（自治区、直辖市、特别行政区）
        let areasArray = ["11","12", "13","14", "15","21", "22","23", "31","32", "33","34", "35","36", "37","41", "42","43", "44","45", "46","50", "51","52", "53","54", "61","62", "63","64", "65","71", "81","82", "91"]
        // 1. 检测省份身份行政区代码
        var areaFlag = false
        let areaSub = idCard.subString(to: 2)
        for areaCode in areasArray {
            if areaSub == areaCode {
                areaFlag = true
                break;
            }
        }
        if !areaFlag {  // 省份区域代码错误
            return false
        }
        
        /*  暂时不做验证
         第三、四位表示市（地区、自治州、盟及国家直辖市所属市辖区和县的汇总码）。其中，01-20，51-70表示省直辖市；21-50表示地区（自治州、盟）。
         第五、六位表示县（市辖区、县级市、旗）。01-18表示市辖区或地区（自治州、盟）辖县级市；21-80表示县（旗）；81-99表示省直辖县级市。
         */
        
        // 2. 检测出生年月日
        switch idCard.count {
        case 15:
            // 获取年份对应的数字
            var regular: NSRegularExpression!
            let year = Int(idCard.subString(range: NSMakeRange(6, 2)))! + 1900
            if year % 4 == 0 || (year % 100 == 0 && year % 4 == 0) {
                regular = try! NSRegularExpression(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$", options: .caseInsensitive)
            } else {
                regular = try! NSRegularExpression(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$", options: .caseInsensitive)
            }
            let numberOfMatch = regular.numberOfMatches(in: idCard, options: .reportProgress, range: NSMakeRange(0, idCard.count))
            if numberOfMatch > 0 {
                return true
            }
            
        case 18:
            // 获取年份对应的数字
            var regular: NSRegularExpression!
            let year = Int(idCard.subString(range: NSMakeRange(6, 4)))!
            if year % 4 == 0 || (year % 100 == 0 && year % 4 == 0) {
                regular = try! NSRegularExpression(pattern: "^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}(((19|20)\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|((19|20)\\d{2}(0[13578]|1[02])31)|((19|20)\\d{2}02(0[1-9]|1\\d|2[0-8]))|((19|20)([13579][26]|[2468][048]|0[048])0229))\\d{3}(\\d|X|x)?$", options: .caseInsensitive)
            } else {
                regular = try! NSRegularExpression(pattern: "^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}(((19|20)\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|((19|20)\\d{2}(0[13578]|1[02])31)|((19|20)\\d{2}02(0[1-9]|1\\d|2[0-8]))|((19|20)([13579][26]|[2468][048]|0[048])0229))\\d{3}(\\d|X|x)?$", options: .caseInsensitive)
            }
            let numberOfMatch = regular.numberOfMatches(in: idCard, options: .reportProgress, range: NSMakeRange(0, idCard.count))
            if numberOfMatch > 0 {  // 年月日正确，仍然需要判断校验位
                if !strict {        // 模糊校验只验证到年月日
                    return true
                }
                
                // 将前17位加权因子保存在数组里
                let factors: Array = ["7", "9", "10", "5", "8", "4", "2", "1", "6", "3", "7", "9", "10", "5", "8", "4", "2"]
                // 这是除以11后，可能产生的11位余数、验证码，也保存成数组
                let checkDigits: Array = ["1", "0", "10", "9", "8", "7", "6", "5", "4", "3", "2"]
                // 用来保存前17位各自乖以加权因子后的总和
                var sum = 0
                for i in 0..<17 {
                    sum += Int(idCard.subString(range: NSMakeRange(i, 1)))! * Int(factors[i])!
                }
                // 计算出校验码所在数组的位置
                let mod = sum % 11
                // 得到最后一位身份证号码
                let last_num = text.subString(range: NSMakeRange(17, 1))
                // 如果等于2，则说明校验码是10，身份证号码最后一位应该是X
                if mod == 2 {
                    if last_num == "X" || last_num == "x" { return true }
                } else {
                    // 用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
                    if last_num == checkDigits[mod] { return true }
                }
            } else {
                return false
            }
        default:
            return false
        }
        return false
    }
}
