//
//  TimeDelay.swift
//  CVKeyboardTextField
//
//  Created by caven on 2018/2/28.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import Foundation

public typealias CVTask = (_ cancel : Bool) -> Void
extension DispatchQueue {
    @discardableResult
    public func delay(_ time: TimeInterval, task: @escaping ()->()) -> CVTask? {
        
        func dispatch_later(block: @escaping ()->()) {
            let t = DispatchTime.now() + time
            DispatchQueue.main.asyncAfter(deadline: t, execute: block)
        }
        var closure: (()->Void)? = task
        var result: CVTask?
        
        let delayedClosure: CVTask = {
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
    
    func cancel(_ task: CVTask?) {
        task?(true)
    }
}




