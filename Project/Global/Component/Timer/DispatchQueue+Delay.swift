//
//  TimeDelay.swift
//  HEKeyboardTextField
//
//  Created by weixhe on 2018/2/28.
//  Copyright © 2018年 com.weixhe. All rights reserved.
//

import Foundation

public typealias HETask = (_ cancel : Bool) -> Void
extension DispatchQueue {
    @discardableResult
    public func delay(_ time: TimeInterval, task: @escaping ()->()) -> HETask? {
        
        func dispatch_later(block: @escaping ()->()) {
            let t = DispatchTime.now() + time
            DispatchQueue.main.asyncAfter(deadline: t, execute: block)
        }
        var closure: (()->Void)? = task
        var result: HETask?
        
        let delayedClosure: HETask = {
            cancel in
            if let internalClosure = closure {
                if (cancel == false) {
                    DispatchQueue.main.async(execute: internalClosure)
                }
            }
            closure = nil
            result = nil
        }
        
        result = delayedClosure
        
        dispatch_later {
            if let delayedClosure = result {
                delayedClosure(false)
            }
        }
        return result
    }
    
    func cancel(_ task: HETask?) {
        task?(true)
    }
}




