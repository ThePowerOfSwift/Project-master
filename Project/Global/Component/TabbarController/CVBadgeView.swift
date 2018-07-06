//
//  CVBadgeView.swift
//  Project
//
//  Created by caven on 2018/7/4.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit

class CVBadgeView: UIView {
    public var font: UIFont = UIFont.font_8 {
        willSet {
            self.textLabel.font = newValue
        }
    }
    public var maxBadge: Int = 9999  // 设置最大的角标数，如果大于该数字，则显示xx+
    public var badge: Int = 0 {  // badge>0时显示数字， badge<=0时显示点
        willSet {
            if newValue > 0 {
                var text: String = String(newValue)
                
                if newValue > self.maxBadge {
                    text = "\(self.maxBadge)+"
                }
                
                self.textLabel.text = text
                self.textLabel.sizeToFit()
                
                var width = self.textLabel.cv_width + 4
                
                if width < self.cv_height {
                    width = self.cv_height
                }
                
                self.frame = CGRectMake(0, 0, width, self.cv_height)
                self.textLabel.center = CGPointMake(width / 2, self.cv_height / 2)
            } else {
                self.textLabel.text = nil
            }
        }
    }
    
    override var frame: CGRect {
        didSet {
            self.corner(radius: self.cv_height / 2, maskToBoudse: true)
        }
    }
    
    private var textLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.red
        self.setup()
        self.corner(radius: self.cv_height / 2, maskToBoudse: true)
    }
    
    init(frame: CGRect, font: UIFont) {
        super.init(frame: frame)
        self.font = font
        self.textLabel.font = font
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    private func setup() {
        self.textLabel = cv_label(font: UIFont.font_8, text: nil, super: self)
        self.textLabel.frame = CGRectMake(2, 2, self.cv_width - 4, self.cv_height - 4)
        self.textLabel.textAlignment = .center
        self.textLabel.textColor = UIColor.white
        self.textLabel.sizeToFit()
        self.textLabel.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleRightMargin]
    }
    
}
