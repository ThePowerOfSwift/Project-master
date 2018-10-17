//
//  CGRectHelper.swift
//  Project
//
//  Created by caven on 2018/5/21.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import Foundation
import UIKit

public protocol CVRelatableTarget {
    
    
}

extension CVRelatableTarget {
    func value() -> CGFloat {
        if let value = self as? CGFloat {
            return value
        }
        
        if let value = self as? Float {
            return CGFloat(value)
        }
        
        if let value = self as? Double {
            return CGFloat(value)
        }
        
        if let value = self as? Int {
            return CGFloat(value)
        }
        
        if let value = self as? UInt {
            return CGFloat(value)
        }
        
        return 0.0
    }
}

extension Int: CVRelatableTarget {
    
}

extension UInt: CVRelatableTarget {
}

extension Float: CVRelatableTarget {
}

extension Double: CVRelatableTarget {
}

extension CGFloat: CVRelatableTarget {
}



func CGRectMake(_ x: CVRelatableTarget, _ y: CVRelatableTarget, _ width: CVRelatableTarget, _ height: CVRelatableTarget) -> CGRect {
    return CGRect(x: x.value(), y: y.value(), width: width.value(), height: height.value())
}

func CGSizeMake(_ width: CVRelatableTarget, _ height: CVRelatableTarget) -> CGSize {
    return CGSize(width: width.value(), height: height.value())
}

func CGPointMake(_ x: CVRelatableTarget, _ y: CVRelatableTarget) -> CGPoint {
    return CGPoint(x: x.value(), y: y.value())
}

