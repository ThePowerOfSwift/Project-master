//
//  UIButtonHelper.swift
//  Project
//
//  Created by caven on 2018/3/9.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import Foundation
import UIKit

public extension UIButton {

    var cv_normalImage: UIImage? {
        set {
            self.setImage(newValue, for: .normal)
        }
        get {
            return self.image(for: .normal)
        }
    }
    
    var cv_selectedImage: UIImage? {
        set {
            self.setImage(newValue, for: .selected)
        }
        get {
            return self.image(for: .selected)
        }
    }
    
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
