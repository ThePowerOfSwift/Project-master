//
//  UIViewExtension.swift
//  CVKeyboardTextField
//
//  Created by caven on 2018/3/5.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

extension UIView {
    var x: CGFloat {
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
        
        get {
            return self.frame.origin.x
        }
    }
    
    var y: CGFloat {
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
        
        get {
            return self.frame.origin.y
        }
    }
    
    var centerX: CGFloat {
        set {
            var center = self.center
            center.x = newValue
            self.center = center
        }
        
        get {
            return self.center.x
        }
    }
    
    var centerY: CGFloat {
        set {
            var center = self.center
            center.y = newValue
            self.center = center
        }
        
        get {
            return self.center.y
        }
    }
    
    var width: CGFloat {
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
        
        get {
            return self.frame.size.width
        }
    }
    
    var height: CGFloat {
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
        
        get {
            return self.frame.size.height
        }
    }
    
    var size: CGSize {
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
        
        get {
            return self.frame.size
        }
    }
    
    var origin: CGPoint {
        set {
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
        
        get {
            return self.frame.origin
        }
    }
    
    /// 设置top，固定height
    @discardableResult
    func top(_ top: CGFloat, fixHeight: Bool = false) -> UIView {
        assert(superview != nil, "view must be added to a superview first.")
        if self.frame == CGRect.zero { self.frame = superview!.bounds }
        let newH = fixHeight ? self.height : self.superview!.height - top - self.bottom
        var frame = self.frame
        frame.origin.y = top
        frame.size.height = newH
        self.frame = frame
        return self
    }
    
    /// 返回top
    var top: CGFloat {
        return superview != nil ? self.frame.origin.y : 0
    }
    
    /// 设置left， 固定width
    @discardableResult
    func left(_ left: CGFloat, fixWidth: Bool = false) -> UIView {
        assert(superview != nil, "view must be added to a superview first.")
        if self.frame == CGRect.zero { self.frame = superview!.bounds }
        let newW = fixWidth ? self.width : self.superview!.width - left - self.right
        var frame = self.frame
        frame.origin.x = left
        frame.size.width = newW
        self.frame = frame
        return self
    }
    
    /// 返回left
    var left: CGFloat {
        return superview != nil ? self.frame.origin.x : 0
    }
    
    /// 设置bottom, 固定Height
    @discardableResult
    func bottom(_ bottom: CGFloat, fixHeight: Bool = false) -> UIView {
        assert(superview != nil, "view must be added to a superview first.")
        
        if self.frame == CGRect.zero { self.frame = superview!.bounds }
        let newT = fixHeight ? self.superview!.height - bottom - self.height : self.top
        let newH = fixHeight ? self.height : self.superview!.height - bottom - newT
        var frame = self.frame
        frame.origin.y = newT
        frame.size.height = newH
        self.frame = frame
        return self
    }
    
    /// 设置bottom
    var bottom: CGFloat {
        return superview != nil ? superview!.frame.height - (self.frame.origin.y + self.frame.size.height) : 0
    }
    
    /// 设置right, 固定宽度
    @discardableResult
    func right(_ right: CGFloat, fixWidth: Bool = false) -> UIView {
        assert(superview != nil, "view must be added to a superview first.")
        if self.frame == CGRect.zero { self.frame = superview!.bounds }
        let newL = fixWidth ? self.superview!.width - right - self.width : self.left
        let newW = fixWidth ? self.width : self.superview!.width - newL - right
        var frame = self.frame
        frame.origin.x = newL
        frame.size.width = newW
        self.frame = frame
        return self
    }
    
    /// 返回right
    var right: CGFloat {
        return superview != nil ? superview!.frame.width - (self.frame.origin.x + self.frame.size.width) : 0
    }
}

public extension UIView {
    
    func border(width: CGFloat, color: UIColor) -> Void {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    func corner(radius: CGFloat, maskToBoudse: Bool) -> Void {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = maskToBoudse
    }
    
    func shadow(radius: CGFloat, offset: CGSize, color: UIColor = UIColor.black, opacity: Float = 0.3) -> Void {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
    }
    
    func hiddenShadow() -> Void {
        self.shadow(radius: 0, offset: CGSize.zero, color: UIColor.clear, opacity: 0)
    }
    
    /// 查找view所在的controller
    func viewController () -> (UIViewController)? {
        // 1. 通过响应者链关系，取得此视图的下一个响应者
        var next: UIResponder? = self.next
        
        repeat {
            // 2. 判断响应者对象是否是视图控制器类型
            if ((next as? UIViewController) != nil) {
                return (next as! UIViewController)
            } else {
                next = next?.next
            }
            
        } while next != nil
        
        return nil
    }
}

// MARK: - 子视图操作
extension UIView {
    /// 移除所有的subView
    func removeAllSubViews() {
        while self.subviews.count > 0 {
            self.subviews.first!.removeFromSuperview()
        }
    }
    
    /// 根据tag移除subView
    func removeSubViewWithTag(_ tag: Int) {
        guard tag != 0 else { return }
        let view = self.viewWithTag(tag)
        if let sub = view {
            sub.removeFromSuperview()
        }
    }
    
    /// 获取子视图
    func subViewWithTag(_ tag: Int) -> UIView? {
        guard tag != 0 else { return nil }
        for view in self.subviews {
            if view.tag == tag {
                return view
            }
        }
        return nil
    }
}

// MARK: - SnapKit
extension UIView {
    public func makeConstraints(_ closure: (_ make: ConstraintMaker) -> Void) {
        self.snp.makeConstraints(closure)
    }
    
    public func remakeConstraints(_ closure: (_ make: ConstraintMaker) -> Void) {
        self.snp.remakeConstraints(closure)
    }
    
    public func updateConstraints(_ closure: (_ make: ConstraintMaker) -> Void) {
        self.snp.updateConstraints(closure)
    }
    
    public func removeConstraints() {
        self.snp.removeConstraints()
    }
}
