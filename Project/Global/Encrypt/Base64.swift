//
//  Base64.swift
//  Project
//
//  Created by weixhe on 2018/3/27.
//  Copyright © 2018年 com.weixhe. All rights reserved.
//

import Foundation

extension String {
    var base64Encoding: String {
        let plainData = self.data(using: String.Encoding.utf8)!
        let base64String = plainData.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        return base64String
    }
    
    var base64Decoding: String {
        let decodedData = NSData(base64Encoded: self, options: NSData.Base64DecodingOptions.init(rawValue: 0))
        let decodedString = NSString(data: decodedData! as Data, encoding: String.Encoding.utf8.rawValue)! as String
        return decodedString
    }
}
