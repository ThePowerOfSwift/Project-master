//
//  UIView+Layout.swift
//  Project
//
//  Created by caven on 2018/8/17.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import Foundation
/**
 *   @brief UIView 简易的布局方法
 */
extension UIView {
    var cv_x: CGFloat {
        set { self.frame = CGRect(x: newValue, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height) }
        get { return self.frame.origin.x }
    }
    
    var cv_y: CGFloat {
        set { self.frame = CGRect(x: self.frame.origin.x, y: newValue, width: self.frame.size.width, height: self.frame.size.height) }
        get { return self.frame.origin.y }
    }
    
    var cv_width: CGFloat {
        set { self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: newValue, height: self.frame.size.height) }
        get { return self.frame.size.width }
    }
    
    var cv_height: CGFloat {
        set { self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: newValue) }
        get { return self.frame.size.height }
    }
    
    var cv_origin: CGPoint {
        set { self.frame = CGRect(x: newValue.x, y: newValue.y, width: self.frame.size.width, height: self.frame.size.height) }
        get { return self.frame.origin }
    }
    
    var cv_size: CGSize {
        set { self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: newValue.width, height: newValue.height) }
        get { return self.frame.size }
    }
    
    var cv_centerX: CGFloat {
        set { self.center = CGPoint(x: newValue, y: self.center.y) }
        get { return self.center.x }
    }
    
    var cv_centerY: CGFloat {
        set { self.center = CGPoint(x: self.center.x, y: newValue) }
        get { return self.center.y }
    }
    
    var cv_left: CGFloat {
        return self.frame.origin.x
    }
    
    var cv_top: CGFloat {
        return self.frame.origin.y
    }
    
    var cv_right: CGFloat {
        return self.frame.size.width + self.frame.origin.x
    }
    
    var cv_bottom: CGFloat {
        return self.frame.size.height + self.frame.origin.y
    }
    
    
    // MARK: - Equals
    
    func cv_widthEqualTo(_ width: CGFloat) {
        
        let firstItem = CVConstraint.init(self, attribute: .width)
        firstItem.constraint = width
        let relationship = CVRelationship(firstItem: firstItem, secondItem: nil)
        self.addRelationship(relationship)
    }
    
    func cv_heightEqualTo(_ height: CGFloat) {
        let firstItem = CVConstraint.init(self, attribute: .height)
        firstItem.constraint = height
        let relationship = CVRelationship(firstItem: firstItem, secondItem: nil)
        self.addRelationship(relationship)
    }
    
    
    func cv_leftEqualTo(_ offset: CGFloat) {
        assert(self.superview != nil, "请先添加到父类")
        self.cv_leftEqualTo(self.superview!).offset(offset)
    }
    
    func cv_rightEqualTo(_ offset: CGFloat) {
        assert(self.superview != nil, "请先添加到父类")
        self.cv_rightEqualTo(self.superview!).offset(offset)
    }
    
    func cv_topEqualTo(_ offset: CGFloat) {
        assert(self.superview != nil, "请先添加到父类")
        self.cv_topEqualTo(self.superview!).offset(offset)
    }
    
    func cv_bottomEqualTo(_ offset: CGFloat) {
        assert(self.superview != nil, "请先添加到父类")
        self.cv_bottomEqualTo(self.superview!).offset(offset)
    }

    func cv_centerXEqualTo(_ offset: CGFloat) {
        assert(self.superview != nil, "请先添加到父类")
        self.cv_centerXEqualTo(self.superview!).offset(offset)
    }
    
    func cv_centerYEqualTo(_ offset: CGFloat) {
        assert(self.superview != nil, "请先添加到父类")
        self.cv_centerYEqualTo(self.superview!).offset(offset)
    }
    
    func cv_centerEqualTo(_ offset: CGFloat) {
        assert(self.superview != nil, "请先添加到父类")
        self.cv_centerEqualTo(self.superview!).offset(offset)
    }
    
    
    @discardableResult
    func cv_widthEqualTo(_ view: UIView) -> CVRelationship {
        let firstItem = CVConstraint.init(self, attribute: .width)
        firstItem.constraint = view.cv_width
        let relationship = CVRelationship(firstItem: firstItem, secondItem: nil)
        self.addRelationship(relationship)
        return relationship
    }
    
    @discardableResult
    func cv_heightEqualTo(_ view: UIView) -> CVRelationship {
        let firstItem = CVConstraint.init(self, attribute: .height)
        firstItem.constraint = view.cv_height
        let relationship = CVRelationship(firstItem: firstItem, secondItem: nil)
        self.addRelationship(relationship)
        return relationship
    }
    
    @discardableResult
    func cv_leftEqualTo(_ view: UIView, attribute: CVAttributeItem = .left) -> CVRelationship {
        let firstItem = CVConstraint.init(self, attribute: .left)
        let secondItem = CVConstraint.init(view, attribute: attribute)
        let relationship = CVRelationship(firstItem: firstItem, secondItem: secondItem)
        self.addRelationship(relationship)
        return relationship
    }
    
    @discardableResult
    func cv_rightEqualTo(_ view: UIView, attribute: CVAttributeItem = .right) -> CVRelationship {
        let firstItem = CVConstraint.init(self, attribute: .right)
        let secondItem = CVConstraint.init(view, attribute: attribute)
        let relationship = CVRelationship(firstItem: firstItem, secondItem: secondItem)
        self.addRelationship(relationship)
        return relationship
    }
    
    @discardableResult
    func cv_topEqualTo(_ view: UIView, attribute: CVAttributeItem = .top) -> CVRelationship {
        let firstItem = CVConstraint.init(self, attribute: .top)
        let secondItem = CVConstraint.init(view, attribute: attribute)
        let relationship = CVRelationship(firstItem: firstItem, secondItem: secondItem)
        self.addRelationship(relationship)
        return relationship
    }
    
    @discardableResult
    func cv_bottomEqualTo(_ view: UIView, attribute: CVAttributeItem = .bottom) -> CVRelationship {
        let firstItem = CVConstraint.init(self, attribute: .bottom)
        let secondItem = CVConstraint.init(view, attribute: attribute)
        let relationship = CVRelationship(firstItem: firstItem, secondItem: secondItem)
        self.addRelationship(relationship)
        return relationship
    }
    
    @discardableResult
    func cv_centerXEqualTo(_ view: UIView) -> CVRelationship {
        let firstItem = CVConstraint.init(self, attribute: .centerX)
        let secondItem = CVConstraint.init(view, attribute: .centerX)
        let relationship = CVRelationship(firstItem: firstItem, secondItem: secondItem)
        self.addRelationship(relationship)
        return relationship
    }
    
    @discardableResult
    func cv_centerYEqualTo(_ view: UIView) -> CVRelationship {
        let firstItem = CVConstraint.init(self, attribute: .centerY)
        let secondItem = CVConstraint.init(view, attribute: .centerY)
        let relationship = CVRelationship(firstItem: firstItem, secondItem: secondItem)
        self.addRelationship(relationship)
        return relationship
    }

    @discardableResult
    func cv_centerEqualTo(_ view: UIView) -> CVRelationship {
        let firstItem = CVConstraint.init(self, attribute: .center)
        let secondItem = CVConstraint.init(view, attribute: .center)
        let relationship = CVRelationship(firstItem: firstItem, secondItem: secondItem)
        self.addRelationship(relationship)
        return relationship
    }
   
}

@objc extension UIView {
    /// 更新约束
    func cv_updateLayout() {
        self.constraint_x = nil
        self.constraint_y = nil
        self.constraint_width = nil
        self.constraint_height = nil
        
        var waitConstrainArray: [CVRelationship] = []       // 这个数组存储需要等待其他其他约束完成后再进行约束的ships，例如，right，bottom, centerX, centerY, center
        
        for ship in self.relationships! {
            switch ship.firstItem.attribute {
            case .right, .bottom, .centerX, .centerY, .center:
                waitConstrainArray.append(ship)
            default:
                ship.cv_updateConstraint()
            }
        }
        
        // 其他的约束都结束了，在进行等待中 的约束
        for ship in waitConstrainArray {
            ship.cv_updateConstraint()
        }
        
        if self.constraint_x == nil || self.constraint_y == nil || self.constraint_width == nil || self.constraint_height == nil {
            return
        }
        self.frame = CGRect(x: self.constraint_x!, y: self.constraint_y!, width: self.constraint_width!, height: self.constraint_height!)
    }
    
    /// 移除约束
    func cv_removeAllLayout() {
        self.constraint_x = nil
        self.constraint_y = nil
        self.constraint_width = nil
 
        self.relationships?.removeAll()
        self.relationships = nil
        
        self.frame = CGRect.zero
    }
}

// MARK: - 内部方法
internal extension UIView {
    
    struct CVObjcKeys {
        static var relationships: String?
        static var constraint_x: String?
        static var constraint_y: String?
        static var constraint_width: String?
        static var constraint_height: String?
    }
    
    var relationships: [CVRelationship]? {
        set {
            objc_setAssociatedObject(self, &CVObjcKeys.relationships, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, &CVObjcKeys.relationships) as? [CVRelationship]
        }
    }
    
    var constraint_x: CGFloat? {
        set {
            objc_setAssociatedObject(self, &CVObjcKeys.constraint_x, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, &CVObjcKeys.constraint_x) as? CGFloat
        }
    }
    
    var constraint_y: CGFloat? {
        set {
            objc_setAssociatedObject(self, &CVObjcKeys.constraint_y, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, &CVObjcKeys.constraint_y) as? CGFloat
        }
    }
    
    var constraint_width: CGFloat? {
        set {
            objc_setAssociatedObject(self, &CVObjcKeys.constraint_width, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, &CVObjcKeys.constraint_width) as? CGFloat
        }
    }
    
    var constraint_height: CGFloat? {
        set {
            objc_setAssociatedObject(self, &CVObjcKeys.constraint_height, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, &CVObjcKeys.constraint_height) as? CGFloat
        }
    }
    
    // MARK: 方法
    func addRelationship(_ relationship: CVRelationship) {
        if self.relationships == nil {
            self.relationships = []
        }
        let (result, index) = self.isExist(relationship: relationship)
        if result {
            self.relationships![index] = relationship
        } else {
            self.relationships!.append(relationship)
        }
        self.cv_updateLayout()
    }
    
    func isExist(relationship: CVRelationship) -> (Bool, Int) {
        guard self.relationships != nil else { return (false, -1) }
        for (index, ship) in self.relationships!.enumerated() {
            if ship == relationship {
                return (true, index)
            }
        }
        return (false, -1)
    }
    
    func convertPoint(_ point: CGPoint, toView: UIView) -> CGPoint {
        let superView = self.superview != nil ? self.superview! : self
        let topSuperPoint = superView.convert(point, to: toView.topSuperView())
        let point = toView.topSuperView().convert(topSuperPoint, to: toView.superview)
        return point
    }
    
    func topSuperView() -> UIView {
        var topSuperView = self.superview
        if topSuperView == nil {
            topSuperView = self
        } else {
            while topSuperView!.superview != nil {
                topSuperView = topSuperView!.superview!
            }
        }
        return topSuperView!
    }
}

// MARK: - 私有方法
fileprivate extension UIView {
    
}
