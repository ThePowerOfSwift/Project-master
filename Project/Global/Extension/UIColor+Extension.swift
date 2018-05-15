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
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1)
    }
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    // 16进制的颜色值
    convenience init(hex: Int) {
        self.init(r: ((CGFloat)((hex & 0xFF0000) >> 16)), g: ((CGFloat)((hex & 0xFF00) >> 8)), b: ((CGFloat)(hex & 0xFF)))
    }
    
    class var randomColor: UIColor {
        get {
            let red = CGFloat(arc4random() % 256) / 255.0
            let green = CGFloat(arc4random() % 256) / 255.0
            let blue = CGFloat(arc4random() % 256) / 255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
}

// MARK: - 常用的color
extension UIColor {
    static var grayColor_22: UIColor { return UIColor(hex: 0x222222) }
    static var grayColor_33: UIColor { return UIColor(hex: 0x333333) }
    static var grayColor_44: UIColor { return UIColor(hex: 0x333333) }
    static var grayColor_55: UIColor { return UIColor(hex: 0x555555) }
    static var grayColor_66: UIColor { return UIColor(hex: 0x666666) }
    static var grayColor_77: UIColor { return UIColor(hex: 0x777777) }
    static var grayColor_88: UIColor { return UIColor(hex: 0x888888) }
    static var grayColor_99: UIColor { return UIColor(hex: 0x999999) }
    static var grayColor_aa: UIColor { return UIColor(hex: 0xaaaaaa) }
    static var grayColor_bb: UIColor { return UIColor(hex: 0xbbbbbb) }
    static var grayColor_cc: UIColor { return UIColor(hex: 0xcccccc) }
    static var grayColor_dd: UIColor { return UIColor(hex: 0xdddddd) }
    static var grayColor_ee: UIColor { return UIColor(hex: 0xeeeeee) }

}
