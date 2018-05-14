//
//  Double+Extension.swift
//  Project
//
//  Created by caven on 2018/4/3.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import Foundation

extension Double {
    /// 用法 let myDouble = 1.234567  println(myDouble.format(".2") .2代表留2位小数点
    func format(_ f: String) -> String {
        return NSString(format: "%\(f)f" as NSString, self) as String
    }
}
