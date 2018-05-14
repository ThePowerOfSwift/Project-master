//
//  CVTimerButton.swift
//  Project
//
//  Created by caven on 2018/3/12.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit

private let kCounting: String = "<counting>"

@objc protocol CVTimerButtonDelegate: class {
    @objc optional func buttonStateDidChanged(button: CVTimerButton, noraml: Bool) -> Void
}

class CVTimerButton: UIView {

    var max: Int = 10
    var delegate: CVTimerButtonDelegate?
    var stateDidChanged: ((_ button: CVTimerButton, _ noraml: Bool) -> ())?
    
    var title: String? {
        didSet {
            self.button!.setTitle(self.title?.replacingOccurrences(of: kCounting, with: String(max)), for: .normal)
        }
    }
    var disableTitle: String? {
        didSet {
            if let string = self.disableTitle {
                self.button!.setTitle(string.replacingOccurrences(of: kCounting, with: String(self.max)), for: .disabled)
            }
        }
    }
    var titleColor: UIColor = UIColor.black {
        didSet {
            self.button!.setTitleColor(self.titleColor, for: .normal)
        }
    }
    var disableColor: UIColor = UIColor.lightGray {
        didSet {
            self.button!.setTitleColor(self.disableColor, for: .disabled)
        }
    }
    var font: UIFont = UIFont.systemFont(ofSize: 13) {
        didSet {
            self.button!.titleLabel?.font = self.font
        }
    }
    private var button: UIButton?
    lazy private var timer: CVTimer? = {
        let t = CVTimer(delegate: self, begin: max, finish: 0)
        return t
    }()
    private var target: AnyObject?
    private var action: Selector?
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        self.button = UIButton(type: .custom)
        self.button!.frame = self.bounds
        self.button!.backgroundColor = UIColor.clear
        self.button!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.button!.addTarget(self, action: #selector(onClickButton), for: .touchUpInside)
        self.button!.titleLabel?.font = self.font
        self.addSubview(self.button!)
        
    }

    // MARK: Method
    func addTarget(_ target: AnyObject?, action: Selector) {
        self.target = target
        self.action = action
    }
    
    @objc func onClickButton() {
        if let target = self.target as? NSObject, let action = self.action {
            target.perform(action)
        }
        self.button!.isEnabled = false
        if self.delegate != nil {
            self.delegate!.buttonStateDidChanged?(button: self, noraml: false)
        }
        if let changed = self.stateDidChanged {
            changed(self, false)
        }
        self.timer?.start()
    }
}

extension CVTimerButton : CVTimerDelegate {
    func timer(timer: CVTimer, counting: Int, finish: Int) {
        if let string = self.disableTitle {
            self.button!.setTitle(string.replacingOccurrences(of: kCounting, with: String(counting)), for: .disabled)
        }
        
        if counting == finish {
            self.button!.isEnabled = true
            if self.delegate != nil {
                self.delegate!.buttonStateDidChanged?(button: self, noraml: true)
            }
            if let changed = self.stateDidChanged {
                changed(self, false)
            }

        }
    }
}
