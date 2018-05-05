//
//  HENormalCalendarCell.swift
//  Project
//
//  Created by weixhe on 2018/5/4.
//  Copyright © 2018年 com.weixhe. All rights reserved.
//

import UIKit

class HENormalCalendarCell: UICollectionViewCell {
    
    // 数据源
    var model: HECalendarModel! {
        didSet {
            if model.dayType == .empty {
                self.solar.text = ""
                self.lunar.text = ""
                self.selectView.isHidden = true
            } else {
                self.solar.text = "\(model.day)"
                if model.isDisplayChineseCalendar {
                    self.lunar.text = model.lunar_day!
                }
                if model.isDisplayHoliday {
                    let solar_holiday = model.holiday![0]
                    let lunar_holiday = model.holiday![1]
                    let twentyFourSolarTerm = model.holiday![2]
                    if twentyFourSolarTerm.count > 0 { self.lunar.text = twentyFourSolarTerm } // 优先级：低
                    if lunar_holiday.count > 0 { self.lunar.text = lunar_holiday }  // 优先级：中
                    if solar_holiday.count > 0 { self.lunar.text = solar_holiday }  // 优先级：高
                }
                self.selectView.isHidden = true
                self.updateTextColor()                
            }
        }
    }
    
    var solar: UILabel!     // 公历
    var lunar: UILabel!     // 农历
    var selectView: UIView! // 选中时出现的view
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        // 公历
        self.solar = clabel(font: UIFont.systemFont(ofSize: 14), text: nil, super: self.contentView)
        self.solar.textAlignment = .center
        self.solar.textColor = UIColor.black
        
        // 农历
        self.lunar = clabel(font: UIFont.systemFont(ofSize: 9), text: nil, super: self.contentView)
        self.lunar.textAlignment = .center
        self.lunar.textColor = UIColor.black
        
        // 选中时出现的view
        self.selectView = cview(super: self.contentView)
        self.selectView.backgroundColor = UIColor.clear
        self.selectView.corner(radius: 3, maskToBoudse: true)
        self.selectView.border(width: 1, color: UIColor.red)
    }
    
    func updateTextColor() {
        if model.dayType == .past {          // 过去的日期
            self.solar.textColor = UIColor.grayColor_99
            self.lunar.textColor = UIColor.grayColor_99
            self.selectView.isHidden = true
        } else {        // 将来的日期
            if model.dayType == .workday {       // 工作日
                self.solar.textColor = UIColor.black
                self.lunar.textColor = UIColor.black
            } else if model.dayType == .weekend || model.dayType == .holiday {    // 周末或节假日
                self.solar.textColor = UIColor.red
                self.lunar.textColor = UIColor.red
            }
            
            if model.isSelected {     // 选中
                self.selectView.isHidden = false
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectView.frame = CGRect(x: 0, y: 0, width: self.width, height: self.height)
        self.solar.frame = CGRect(x: 0, y: 0, width: self.width, height: self.height / 2)
        self.lunar.frame = CGRect(x: 0, y: self.height / 2, width: self.width, height: self.height / 2)
    }
    
}
