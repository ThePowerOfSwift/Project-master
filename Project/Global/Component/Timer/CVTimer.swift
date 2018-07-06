//
//  CVTimer.swift
//  Project
//
//  Created by caven on 2018/3/9.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit

typealias ClosureOnTimerRunning = (() -> Bool)?

class CVTimer: NSObject {

    public var timerRunning: ClosureOnTimerRunning

    private var timer: Timer?
    private var timeInterval: TimeInterval = TimeInterval(1)
    private var state: TimerState!
    
    /// 时钟的状态
    enum TimerState {
        case ready
        case start
        case pause
        case resume
        case end
    }
    
    // MARK: Init
    override init() {
        
    }
    convenience init(timeInterval: TimeInterval = 1, closure: ClosureOnTimerRunning) {
        self.init()
        self.timeInterval = timeInterval
        self.timerRunning = closure
        self.state = .ready
        self.timer = Timer(fireAt: Date.distantFuture, interval: self.timeInterval, target: self, selector: #selector(onTimerRunning), userInfo: nil, repeats: true)
        RunLoop.current.add(self.timer!, forMode: RunLoopMode.commonModes)
    }

    @discardableResult
    class func timer(timeInterval: TimeInterval = 1, closure: ClosureOnTimerRunning) -> CVTimer {
        let t = CVTimer(timeInterval: timeInterval, closure: closure)
        return t
    }

    // MARK: Private Method
    @objc private func onTimerRunning() {
        guard self.timer != nil else { return }
        if let closure = self.timerRunning, !closure() {
            self.end()
        }
    }
    
    // MARK: Public Method
    /// 马上执行
    func run() {
        
        if self.timer != nil {
            if self.state == .ready {
                self.timer!.fireDate = Date.distantPast
                self.state = .start
                
            } else if self.state == .pause {
                self.resume()
            }
        } else if self.state == .end {  // 当 timer == nil 且 state == .end 时，说明timer经历过了start，所以可以再次生成启动，其他状态下的timer不可以重新生成启动
            self.timer = Timer(fireAt: Date.distantPast, interval: self.timeInterval, target: self, selector: #selector(onTimerRunning), userInfo: nil, repeats: true)
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
