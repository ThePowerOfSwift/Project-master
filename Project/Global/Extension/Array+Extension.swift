//
//  Array+Extension.swift
//  Project
//
//  Created by caven on 2018/5/7.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import Foundation
extension Array where Element: Equatable {  
    
    // Remove first collection element that is equal to the given `object`:  
    mutating func remove(_ object: Element) {  
        if let index = index(of: object) {  
            remove(at: index)  
        }  
    }
    
    mutating func remove(_ objects: [Element]) {

        for obj in objects {
            self.remove(obj)
        }
    }
}  
