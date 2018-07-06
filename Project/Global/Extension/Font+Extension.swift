//
//  Font+Extension.swift
//  Project
//
//  Created by caven on 2018/4/14.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {

    /// 根据 设计图 进行文字大小的适配
    static func systemFont_375(ofSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: cv_format_375(x: ofSize))
    }
    
    /// 根据 设计图 进行文字大小的适配
    static func boldSystemFont_375(ofSize: CGFloat) -> UIFont {
        return UIFont.boldSystemFont(ofSize: cv_format_375(x: ofSize))
    }
}

// MARK: - 常用的font
extension UIFont {
    static var font_7: UIFont { return UIFont.systemFont(ofSize: 7) }
    static var font_8: UIFont { return UIFont.systemFont(ofSize: 8) }
    static var font_9: UIFont { return UIFont.systemFont(ofSize: 9) }
    static var font_10: UIFont { return UIFont.systemFont(ofSize: 10) }
    static var font_11: UIFont { return UIFont.systemFont(ofSize: 11) }
    static var font_12: UIFont { return UIFont.systemFont(ofSize: 12) }
    static var font_13: UIFont { return UIFont.systemFont(ofSize: 13) }
    static var font_14: UIFont { return UIFont.systemFont(ofSize: 14) }
    static var font_15: UIFont { return UIFont.systemFont(ofSize: 15) }
    static var font_16: UIFont { return UIFont.systemFont(ofSize: 16) }
    static var font_17: UIFont { return UIFont.systemFont(ofSize: 17) }
    static var font_18: UIFont { return UIFont.systemFont(ofSize: 18) }
    static var font_19: UIFont { return UIFont.systemFont(ofSize: 19) }
    static var font_20: UIFont { return UIFont.systemFont(ofSize: 20) }
    static var font_21: UIFont { return UIFont.systemFont(ofSize: 21) }
    static var font_22: UIFont { return UIFont.systemFont(ofSize: 22) }
    static var font_23: UIFont { return UIFont.systemFont(ofSize: 23) }
    static var font_24: UIFont { return UIFont.systemFont(ofSize: 24) }
    static var font_25: UIFont { return UIFont.systemFont(ofSize: 25) }

    /// 以下是根据屏幕宽度适配的
    static var font_7_375: UIFont { return UIFont.systemFont_375(ofSize: 7) }
    static var font_8_375: UIFont { return UIFont.systemFont_375(ofSize: 8) }
    static var font_9_375: UIFont { return UIFont.systemFont_375(ofSize: 9) }
    static var font_10_375: UIFont { return UIFont.systemFont_375(ofSize: 10) }
    static var font_11_375: UIFont { return UIFont.systemFont_375(ofSize: 11) }
    static var font_12_375: UIFont { return UIFont.systemFont_375(ofSize: 12) }
    static var font_13_375: UIFont { return UIFont.systemFont_375(ofSize: 13) }
    static var font_14_375: UIFont { return UIFont.systemFont_375(ofSize: 14) }
    static var font_15_375: UIFont { return UIFont.systemFont_375(ofSize: 15) }
    static var font_16_375: UIFont { return UIFont.systemFont_375(ofSize: 16) }
    static var font_17_375: UIFont { return UIFont.systemFont_375(ofSize: 17) }
    static var font_18_375: UIFont { return UIFont.systemFont_375(ofSize: 18) }
    static var font_19_375: UIFont { return UIFont.systemFont_375(ofSize: 19) }
    static var font_20_375: UIFont { return UIFont.systemFont_375(ofSize: 20) }
    static var font_21_375: UIFont { return UIFont.systemFont_375(ofSize: 21) }
    static var font_22_375: UIFont { return UIFont.systemFont_375(ofSize: 22) }
    static var font_23_375: UIFont { return UIFont.systemFont_375(ofSize: 23) }
    static var font_24_375: UIFont { return UIFont.systemFont_375(ofSize: 24) }
    static var font_25_375: UIFont { return UIFont.systemFont_375(ofSize: 25) }
}
