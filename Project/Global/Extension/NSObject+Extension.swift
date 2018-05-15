//
//  NSObject+Extension.swift
//  Project
//
//  Created by caven on 2018/5/15.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import Foundation
extension NSObject {
    
    /// 交换实例方法
    public class func swizzledInstanceMethod(_ originalSelector:Selector, swizzledSelector:Selector) {
        let originalMethod = class_getInstanceMethod(self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
        
        let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
        
        if didAddMethod {
            class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
        } else {
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
        }
    }
    
    /// 交换类方法
    public class func swizzledClsssMethod(_ originalSelector:Selector, swizzledSelector:Selector) {
        let originalMethod = class_getClassMethod(self, originalSelector)
        let swizzledMethod = class_getClassMethod(self, swizzledSelector)
        
        let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
        
        if didAddMethod {
            class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
        } else {
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
        }
    }
}
