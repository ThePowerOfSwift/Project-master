//
//  CVKeyboardTextView.swift
//  CVKeyboardTextView
//
//  Created by caven on 2018/2/28.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit

open class CVKeyboardTextView: UIView {

    struct RoundMargin {
        var left: CGFloat = 10.0
        var right: CGFloat = 10.0
        var top: CGFloat = 4.0
        var bottom: CGFloat = 4.0
        
        init(top: CGFloat = 4.0, left: CGFloat = 10.0, bottom: CGFloat = 4.0, right: CGFloat = 10.0) {
            self.top = top
            self.left = left
            self.bottom = bottom
            self.right = right
        }
        
        func calculateTextViewFrame(leftMargin: CGFloat, rightMargin: CGFloat, superview: UIView) -> CGRect {
            let x = self.left + leftMargin
            let y = self.top
            let width = superview.frame.width - x - self.right - rightMargin
            let height = superview.frame.height - y - self.bottom
            return CGRect(x: x, y: y, width: width, height: height)
        }
    }
    
    // MARK: Property
    lazy var textView: CVExpandTextView = CVExpandTextView(frame: self.tools.calculateTextViewFrame(leftMargin: 0, rightMargin: 0, superview: self))
    var isEditing: Bool = false
    var placeholder: String = "" {
        didSet {
            self.textView.placeholder = placeholder
        }
    }
    
    var leftView: UIView? {
        didSet {
            if let view = leftView {
                self.addSubview(view)
                view.autoresizingMask = [.flexibleRightMargin]
                self.leftViewBottom = self.frame.height - view.frame.minY - view.frame.height
                let rightMargin = self.rightView != nil ? self.frame.width - self.rightView!.frame.origin.x : 0;
                let leftMargin = view.frame.maxX
                self.textView.frame = self.tools.calculateTextViewFrame(leftMargin: leftMargin, rightMargin: rightMargin, superview: self)
            }
        }
    }
    fileprivate var leftViewBottom: CGFloat?    // 记录leftView的底部距离
    
    var rightView: UIView? {
        didSet {
            if let view = rightView {
                self.addSubview(view)
                view.autoresizingMask = [.flexibleLeftMargin]
                self.rightViewBottom = self.frame.height - view.frame.minY - view.frame.height
                let rightMargin = self.frame.width - view.frame.origin.x;
                let leftMargin = self.leftView != nil ? self.leftView!.frame.maxX : 0
                self.textView.frame = self.tools.calculateTextViewFrame(leftMargin: leftMargin, rightMargin: rightMargin, superview: self)
            }
        }
    }
    fileprivate var rightViewBottom: CGFloat?    // 记录rightView的底部距离

    fileprivate var lastKeyboardFrame : CGRect = CGRect.zero
    fileprivate var tools = RoundMargin()

    // MARK: Init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }
    
    // MARK:DeInit
    deinit {
        self.textView.removeObserver(self, forKeyPath: "frame")
        self.removeKeyBoardNotification()
    }
    
    
    // MARK: Method
    func setupUI() -> Void {
        self.backgroundColor = UIColor.colorWithRGB(238, green: 238, blue: 238)
        self.shadow(radius: 1, offset: CGSize(width: -0.5, height: -0.5))
        self.textView.corner(radius: 6, maskToBoudse: true)
        self.textView.textView.delegate = self
        self.textView.backgroundColor = UIColor.white
        self.textView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(self.textView)
        
        self.textView.addObserver(self, forKeyPath: "frame", options: .new, context: nil)
        
        self.regiterKeyBoardNotification()
    }
    
    public func show() -> Void {
        self.textView.textView.becomeFirstResponder()
    }
    
    public func hiden() -> Void {
        self.textView.textView.resignFirstResponder()
    }
}

// MARK: - CVKeyboardTextView 键盘
extension CVKeyboardTextView {
    func regiterKeyBoardNotification() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChangeFrame(_:)), name: .UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidChangeFrame(_:)), name: .UIKeyboardDidChangeFrame, object: nil)
    }
    
    func removeKeyBoardNotification() -> Void {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
    }
    
    /// 键盘的Frame即将改变
    @objc func keyBoardWillChangeFrame(_ notify: Notification) -> Void {
        if self.window == nil || !self.window!.isKeyWindow { return }
        guard let userInfo = notify.userInfo else { return }
        
        let keyBoardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let animationDuring = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        self.lastKeyboardFrame = self.superview!.convert(keyBoardFrame, to: UIApplication.shared.keyWindow)
        UIView.animate(withDuration: TimeInterval(animationDuring), animations: {
            if self.isEditing {
                self.frame.origin.y = self.lastKeyboardFrame.origin.y - self.bounds.height
            } else {
                let safeArea = safeAreaInsetsIn(view: self.window!)
                self.frame.origin.y = SCREEN_HEIGHT - safeArea.bottom - self.bounds.size.height
            }
        }) { (_) in
            
        }
    }
    
    /// 键盘的Frame已经改变
    @objc func keyBoardDidChangeFrame(_ notify: Notification) -> Void {
        
    }
}

extension CVKeyboardTextView: UITextViewDelegate {
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.translatesAutoresizingMaskIntoConstraints = true
        self.isEditing = true
        return true
    }

    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isEditing = false
        return true
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        self.textView.textViewDidChange(textView)
    }
}

// MARK: - CVKeyboardTextView 监听者
extension CVKeyboardTextView {
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let _ = object as? UIView , let _ = change {
            if keyPath == "frame" {
                let bottom = self.frame.maxY
                self.frame.size.height = self.textView.frame.height + self.tools.top + self.tools.bottom
                self.frame.origin.y = bottom - self.frame.size.height
                
                self.textView.center.y = self.frame.height / 2.0
                
                func fixView(view: UIView?, bottom: CGFloat?) -> Void {
                    if let view = view, let bottom = bottom {
                        view.frame = CGRect(origin:CGPoint(x: view.frame.minX, y: self.frame.height - bottom - view.frame.height) , size: view.frame.size)
                    }
                }
                fixView(view: self.leftView, bottom: self.leftViewBottom)
                fixView(view: self.rightView, bottom: self.rightViewBottom)
            }
        }
    }
}


