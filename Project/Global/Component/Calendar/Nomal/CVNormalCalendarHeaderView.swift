//
//  CVNormalCalendarHeaderView.swift
//  Project
//
//  Created by caven on 2018/5/5.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit
let CVNormalCalendarWeekendColor = UIColor.red
class CVNormalCalendarHeaderView: UICollectionReusableView {
    var gregorian: Calendar! {
        didSet {
            self.weekdayView.gregorian = gregorian
        }
    }
    var titleLabel: UILabel!
    var weekdayView: CVCalendarWeekdayView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.titleLabel = clabel(font: UIFont.font_16, text: nil, super: self)
        self.titleLabel.frame = CGRect(x: 0, y: 10, width: self.width, height: 40)
        self.titleLabel.textAlignment = .center
        
        self.weekdayView = CVCalendarWeekdayView(frame: CGRect(x: 0, y: self.height - 20, width: self.width, height: 20))
        self.addSubview(self.weekdayView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
