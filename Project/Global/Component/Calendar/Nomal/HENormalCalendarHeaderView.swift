//
//  HENormalCalendarHeaderView.swift
//  Project
//
//  Created by weixhe on 2018/5/5.
//  Copyright © 2018年 com.weixhe. All rights reserved.
//

import UIKit
let HENormalCalendarWeekendColor = UIColor.red
class HENormalCalendarHeaderView: UICollectionReusableView {
    var gregorian: Calendar! {
        didSet {
            self.weekdayView.gregorian = gregorian
        }
    }
    var titleLabel: UILabel!
    var weekdayView: HECalendarWeekdayView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.titleLabel = clabel(font: UIFont.font_16, text: nil, super: self)
        self.titleLabel.frame = CGRect(x: 0, y: 10, width: self.width, height: 40)
        self.titleLabel.textAlignment = .center
        
        self.weekdayView = HECalendarWeekdayView(frame: CGRect(x: 0, y: self.height - 20, width: self.width, height: 20))
        self.addSubview(self.weekdayView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
