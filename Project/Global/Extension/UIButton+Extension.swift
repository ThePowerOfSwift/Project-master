//
//  UIButton+Extension.swift
//  Project
//
//  Created by caven on 2018/3/9.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import Foundation
import UIKit

/// 列举按钮中 image 相对于 title 的位置
public enum UIButtonImagePosition {
    case imageTop
    case imageLeft
    case imageBottom
    case imageRight
}
// MARK: - 调解image和title的位置
public extension UIButton {
    
    /// 设置按钮的 image 和 title 的相对位置，以及间距
    func cv_updateImagePosition(position: UIButtonImagePosition, space: CGFloat) {
        /**
         *  知识点：titleEdgeInsets 是 title 相对于其上下左右的inset，跟 tableView 的 contentInset 是类似的，
         *  如果只有 title，那它上下左右都是相对于 button 的，image 也是一样；
         *  如果同时有 image 和 label，那这时候 image 的上左下是相对于 button，右边是相对于 label 的；title 的上右下是相对于 button，左边是相对于image 的。
         */
        
        if position == .imageLeft, space == 0 {
            return
        }
        
        // 1. 得到 imageView 和 titleLabel 的宽、高
        var imageWidth: CGFloat? = self.imageView?.image?.size.width
        var imageHeight: CGFloat? = self.imageView?.image?.size.height
        var titleWidth: CGFloat? = 0
        var titleHeight: CGFloat? = 0
        if let version = Float(UIDevice.current.systemVersion), version > Float(8.0) {
            titleWidth = self.titleLabel?.intrinsicContentSize.width
            titleHeight = self.titleLabel?.intrinsicContentSize.height
        } else {
            titleWidth = self.titleLabel?.frame.width
            titleHeight = self.titleLabel?.frame.height
        }
        
        // 2. 处理 imageEdgeInsets 和 titleEdgeInsets, 以及 space
        var imageEdgeInsets: UIEdgeInsets = UIEdgeInsets.zero
        var titleEdgeInsets: UIEdgeInsets = UIEdgeInsets.zero
        
        if imageWidth == nil    { imageWidth = 0 }
        if imageHeight == nil   { imageHeight = 0 }
        if titleWidth == nil    { titleWidth = 0 }
        if titleHeight == nil   { titleHeight = 0 }
        
        switch position {
        case .imageTop:
            imageEdgeInsets = UIEdgeInsets(top: -titleHeight!-space/2.0, left: 0, bottom: 0, right: -titleWidth!)
            titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth!, -imageHeight!-space/2.0, 0)
        case .imageLeft:
            imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0)
            titleEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0)
        case .imageBottom:
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -titleHeight!-space/2.0, -titleWidth!)
            titleEdgeInsets = UIEdgeInsetsMake(-imageHeight!-space/2.0, -imageWidth!, 0, 0)
        case .imageRight:
            imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth!+space/2.0, 0, -titleWidth!-space/2.0)
            titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth!-space/2.0, 0, imageWidth!+space/2.0)
//        default:
//            imageEdgeInsets = UIEdgeInsets.zero
//            titleEdgeInsets = UIEdgeInsets.zero
        }
        // 3. 赋值
        self.titleEdgeInsets = titleEdgeInsets;
        self.imageEdgeInsets = imageEdgeInsets;
    }
}

public extension UIButton {
    
    var cv_titleFont: UIFont? {
        set {
            self.titleLabel?.font = newValue
        }
        get {
            return self.titleLabel?.font
        }
    }
    
    var cv_normalTitle: String? {
        set {
            self.setTitle(newValue, for: .normal)
        }
        get {
            return self.titleLabel?.text
        }
    }
    
    var cv_normalTitleColor: UIColor? {
        set {
            self.setTitleColor(newValue, for: .normal)
        }
        get {
            return self.titleLabel?.textColor
        }
    }
    
    var cv_selectedTitle: String? {
        set {
            self.setTitle(newValue, for: .selected)
        }
        get {
            return self.titleLabel?.text
        }
    }
    
    var cv_selectedTitleColor: UIColor? {
        set {
            self.setTitleColor(newValue, for: .selected)
        }
        get {
            return self.titleLabel?.textColor
        }
    }
 
    
    func cv_setTitle(_ title: String?, color: UIColor?, state: UIControlState) {
        self.setTitle(title, for: state)
        self.setTitleColor(color, for: state)
    }
}
