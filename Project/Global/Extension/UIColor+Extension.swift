//
//  UIColor+Extension.swift
//  CVKeyboardTextField
//
//  Created by caven on 2018/3/5.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor {
    
    public class func colorWithRGB(_ red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }
    
    // 16进制的颜色值 - Int
    public class func colorWithHex(_ hex: Int, alpha: Float = 1.0) -> UIColor {
        let blue = hex & 0xFF
        let green = (hex >> 8) & 0xFF
        let red = (hex >> 16) & 0xFF
        return self.colorWithRGB(CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }
    
    // 16进制的颜色值 - 字符串
    public class func colorWithHexString(_ hexString: String, alpha: Float = 1.0) -> UIColor {
        var hexStr = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        if hexStr.hasPrefix("#") {
            hexStr = String.init(hexStr.suffix(from: hexStr.index(after: hexStr.startIndex)))
        }
        var hex: CUnsignedInt = 0
        Scanner.init(string: hexStr).scanHexInt32(&hex)
        
        let blue = hex & 0xFF
        let green = (hex >> 8) & 0xFF
        let red = (hex >> 16) & 0xFF
        return self.colorWithRGB(CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }
    
    class var randomColor: UIColor {
        get {
            let red = CGFloat(cv_arc4random(max: 255)) / 255.0
            let green = CGFloat(cv_arc4random(max: 255)) / 255.0
            let blue = CGFloat(cv_arc4random(max: 255)) / 255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
}

// MARK: - 常用的color
extension UIColor {
    static var grayColor_22: UIColor { return UIColor.colorWithHex(0x222222) }
    static var grayColor_33: UIColor { return UIColor.colorWithHex(0x333333) }
    static var grayColor_44: UIColor { return UIColor.colorWithHex(0x333333) }
    static var grayColor_55: UIColor { return UIColor.colorWithHex(0x555555) }
    static var grayColor_66: UIColor { return UIColor.colorWithHex(0x666666) }
    static var grayColor_77: UIColor { return UIColor.colorWithHex(0x777777) }
    static var grayColor_88: UIColor { return UIColor.colorWithHex(0x888888) }
    static var grayColor_99: UIColor { return UIColor.colorWithHex(0x999999) }
    static var grayColor_aa: UIColor { return UIColor.colorWithHex(0xaaaaaa) }
    static var grayColor_bb: UIColor { return UIColor.colorWithHex(0xbbbbbb) }
    static var grayColor_cc: UIColor { return UIColor.colorWithHex(0xcccccc) }
    static var grayColor_dd: UIColor { return UIColor.colorWithHex(0xdddddd) }
    static var grayColor_ee: UIColor { return UIColor.colorWithHex(0xeeeeee) }
    
}

