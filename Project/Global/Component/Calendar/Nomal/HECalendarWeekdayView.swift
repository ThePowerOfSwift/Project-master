//
//  HECalendarWeekdayView.swift
//  Project
//
//  Created by weixhe on 2018/5/5.
//  Copyright © 2018年 com.weixhe. All rights reserved.
//

import UIKit

class HECalendarWeekdayView: UIView {

    var calendar: Calendar! {
        didSet {
            self.configureAppearance()
        }
    }
    
    var weekdayLabels: [UILabel] = [UILabel]()
    
    var contentView: UIView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.contentView = cview(super: self)
        
        for _ in 0..<7 {
            let label = clabel(font: UIFont.font_12, text: nil, super: self.contentView)
            label.textAlignment = .center
            self.weekdayLabels.append(label)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = self.bounds
        let width: CGFloat = self.width / 7.0
        var x: CGFloat = 0.0
        
        for label in self.weekdayLabels {
            label.frame = CGRect(x: x, y: CGFloat(0), width: width, height: self.contentView.height)
            x = x + width
        }
    }
    
    func configureAppearance() {
        let weeks = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
        for i in 0..<self.weekdayLabels.count {
            let label = self.weekdayLabels[i]
            label.text = weeks[i]
            label.textColor = i == 0 || i == 6 ? HENormalCalendarWeekendColor : UIColor.black
        }
    }
}
