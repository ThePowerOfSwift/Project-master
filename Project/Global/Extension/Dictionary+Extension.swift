//
//  Dictionary+Extension.swift
//  Project
//
//  Created by caven on 2018/4/3.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import Foundation

extension Dictionary {
   
    func toString() -> String {
        
        var strJson: String = ""
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
            strJson = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        } catch {
            
        }
        return strJson
    }
}
