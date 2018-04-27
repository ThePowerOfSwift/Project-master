//
//  Font+Extension.swift
//  Project
//
//  Created by fumubang on 2018/4/14.
//  Copyright © 2018年 com.weixhe. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {

    /// 根据 设计图 进行文字大小的适配
    static func systemFont_375(ofSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: kFormat_375(x: ofSize))
    }
    
    /// 根据 设计图 进行文字大小的适配
    static func boldSystemFont_375(ofSize: CGFloat) -> UIFont {
        return UIFont.boldSystemFont(ofSize: kFormat_375(x: ofSize))
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
}
