//
//  CVDelay.swift
//  CVKeyboardTextField
//
//  Created by caven on 2018/2/28.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import Foundation

public typealias CVTaskClosure = (_ cancel : Bool) -> Void


@discardableResult
public func cv_delay(_ time: TimeInterval, task: @escaping ()->()) -> CVTaskClosure? {
    
    func dispatch_later(block: @escaping ()->()) {
        let t = DispatchTime.now() + time
        DispatchQueue.main.asyncAfter(deadline: t, execute: block)
    }
    var closure: (()->Void)? = task
    var result: CVTaskClosure?
    
    let delayedClosure: CVTaskClosure = {
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

func cv_cancel_delay_task(_ task: CVTaskClosure?) {
    task?(true)
}





