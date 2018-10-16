//
//  CVViewHelper.swift
//  CVViewHelper
//
//  Created by caven on 2018/3/5.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

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
