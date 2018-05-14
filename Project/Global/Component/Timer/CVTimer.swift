//
//  CVTimer.swift
//  Project
//
//  Created by caven on 2018/3/9.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit

protocol CVTimerDelegate : class {
    func timer(timer: CVTimer, counting: Int, finish: Int) -> Void
}


class CVTimer: NSObject {

    weak var delegate: CVTimerDelegate?
    
    var step: UInt = 1 {
        didSet { step = step == 0 ? 1 : step }
    }
    
    private var increase: Bool = false      // 增加-true， 减少-false
    private var begin: Int = 0
    private var finish: Int = 0
    private var timer: Timer?
    private var counting: Int? = 0
    private var timeInterval: TimeInterval = TimeInterval(1)
    private var forever: Bool = false
    private var state: TimerState!
    
    
    enum TimerState {
        case ready
        case start
        case pause
        case resume
        case end
    }
    
    // MARK: Init
    convenience init(timeInterval: TimeInterval = 1, delegate: CVTimerDelegate?, increase: Bool = false, begin: Int, finish: Int, step: UInt = 1) {
        self.init()
        self.timeInterval = timeInterval
        self.increase = increase
        self.begin = begin
        self.counting = self.begin
        self.finish = finish
        self.step = step
        self.delegate = delegate
        self.state = .ready
        self.timer = Timer(fireAt: Date.distantFuture, interval: self.timeInterval, target: self, selector: #selector(timerRunning), userInfo: nil, repeats: true)
        RunLoop.current.add(self.timer!, forMode: RunLoopMode.commonModes)
    }
    
    class func timer(timeInterval: TimeInterval = 1, delegete: CVTimerDelegate?) -> CVTimer {
        let t = CVTimer(timeInterval: timeInterval, delegate: delegete, begin: 0, finish: 0)
        t.forever = true
        return t
    }
    
    // MARK: Method
    @objc func timerRunning() {
        guard self.timer != nil else { return }
        
        // 永恒计时器
        if forever {
            if let d = delegate { d.timer(timer: self, counting: counting!, finish: finish) }
            return
        }
        
        if increase {       // 增加
            if counting! < finish {
                counting! += Int(step)
                
            }
            if counting! >= finish {
                counting! = finish
                if let d = delegate { d.timer(timer: self, counting: counting!, finish: finish) }
                self.end()
            } else {
                if let d = delegate { d.timer(timer: self, counting: counting!, finish: finish) }
            }
        } else {        // 减少
            if counting! > finish {
                counting! -= Int(step)
            }
            if counting! <= finish {
                counting! = finish
                if let d = delegate { d.timer(timer: self, counting: counting!, finish: finish) }
                self.end()
            } else {
                if let d = delegate { d.timer(timer: self, counting: counting!, finish: finish) }
            }
        }
    }
    
    /// 马上执行
    func start() {
        
        if self.timer != nil {
            if self.state == .ready {
                self.timer!.fireDate = Date.distantPast
                self.state = .start
                
            } else if self.state == .pause {
                self.resume()
            }
        } else if self.state == .end {  // 当 timer == nil 且 state == .end 时，说明timer经历过了start，所以可以再次生成启动，其他状态下的timer不可以重新生成启动
            self.counting = self.begin
            self.timer = Timer(fireAt: Date.distantPast, interval: self.timeInterval, target: self, selector: #selector(timerRunning), userInfo: nil, repeats: true)
            RunLoop.current.add(self.timer!, forMode: RunLoopMode.commonModes)
            self.state = .start
        }
    }

    func end() {
        if self.timer != nil && (self.state == .start || self.state == .resume) {
            if self.timer!.isValid {
                self.timer!.invalidate()
                self.timer = nil
                self.state = .end
            }
        }
    }
    
    func pause() {
        if self.timer != nil && (self.state == .start || self.state == .resume) {
            self.timer!.fireDate = Date.distantFuture
            self.state = .pause
        }
    }
    
    func resume() {
        if self.timer != nil && self.state == .resume {
            self.timer!.fireDate = Date.distantPast
            self.state = .resume
        }
    }
}
