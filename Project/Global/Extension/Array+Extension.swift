//
//  Array+Extension.swift
//  Project
//
//  Created by weixhe on 2018/5/7.
//  Copyright © 2018年 com.weixhe. All rights reserved.
//

import Foundation
extension Array where Element: Equatable {  
    
    // Remove first collection element that is equal to the given `object`:  
    mutating func remove(_ object: Element) {  
        if let index = index(of: object) {  
            remove(at: index)  
        }  
    }  
}  
