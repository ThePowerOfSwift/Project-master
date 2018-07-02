//
//  CVPageTabItem.swift
//  Project
//
//  Created by caven on 2018/5/24.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit

enum CVPageTabItemStyle {
    case `default`  // 默认只有一个title
    case custom // 用户自定义
}

enum CVPageTabState {
    case normal
    case highlighted
    case disabled
}

class CVPageTabItem: UIControl, CVPageTabProtocol {
    
    var tabState: CVPageTabState = .normal
    
    
    var text: String?
    var font: UIFont?
    var textColor: UIColor?

    var highlightText: String?
    var highlightFont: UIFont?
    var highlightColor: UIColor?
    
    var disabledText: String?
    var disabledFont: UIFont?
    var disabledTColor: UIColor?
    
    var style: CVPageTabItemStyle
    
    
    private var titleLabel: UILabel?
    private var defaultFont = UIFont.font_13
    private var defaultTextColor = UIColor.grayColor_33
    private var defaultHighlightTextColor = UIColor.colorWithHex(0xFF2945)

    required init(style: CVPageTabItemStyle) {
        self.style = style
        super.init(frame: CGRect.zero)
        self.setDefault()
    }
    
    
    override init(frame: CGRect) {
        self.style = .default
        super.init(frame: frame)
        self.setDefault()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel?.frame = self.bounds
    }
    
    private func setDefault() {
        self.backgroundColor = UIColor.clear
        if self.style == .default {
            self.titleLabel = cv_label(font: UIFont.font_13, text: "", super: self)
            self.titleLabel!.backgroundColor = UIColor.clear
            self.titleLabel!.textAlignment = NSTextAlignment.center
            self.titleLabel!.textColor = self.textColor
        }
    }
    
    func cv_setNormalState(animation: Bool) {
        self.isEnabled = true
        self.titleLabel?.text = self.text
        self.titleLabel?.font = self.font ?? self.defaultFont
        self.titleLabel?.textColor = self.textColor ?? self.defaultTextColor
        self.tabState = .normal
    }
    
    func cv_setHighlightState(animation: Bool) {
        self.isEnabled = true
        self.titleLabel?.text = self.highlightText ?? self.text
        self.titleLabel?.font = self.highlightFont ?? self.defaultFont
        self.titleLabel?.textColor = self.highlightColor ?? self.defaultHighlightTextColor
        self.tabState = .highlighted
    }
    
    func cv_setDisabledState(animation: Bool) {
        self.isEnabled = false
        self.titleLabel?.text = self.disabledText ?? self.text
        self.titleLabel?.font = self.disabledFont ?? self.defaultFont
        self.titleLabel?.textColor = self.disabledTColor ?? self.defaultTextColor
        self.tabState = .disabled
    }

}


