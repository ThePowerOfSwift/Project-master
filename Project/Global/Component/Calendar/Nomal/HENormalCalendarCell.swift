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
    
    private func setup() {
        // 选中时出现的view
        self.selectView = cview(super: self.contentView)
        self.selectView.frame = CGRect(x: 0, y: 0, width: self.width - 10, height: self.width - 10)
        self.selectView.corner(radius: self.selectView.width / 2, maskToBoudse: true)
        self.selectView.backgroundColor = UIColor(hex: 0xff9562)

        // 公历
        self.solar = clabel(font: UIFont.font_14, text: nil, super: self.contentView)
        self.solar.textAlignment = .center
        self.solar.textColor = UIColor.black
        
        // 农历
        self.lunar = clabel(font: UIFont.font_9, text: nil, super: self.contentView)
        self.lunar.textAlignment = .center
        self.lunar.textColor = UIColor.black
    }
    
    private func updateTextColor() {
        if model.dayType == .past || model.isEnable == false {        // 过去的日期 或 不能点击的cell
            self.solar.textColor = UIColor.grayColor_99
            self.lunar.textColor = UIColor.grayColor_99
            self.selectView.isHidden = true
        } else {        // 将来的日期
            self.selectView.isHidden = true
            if model.dayType == .workday {       // 工作日
                self.solar.textColor = UIColor.black
                self.lunar.textColor = UIColor.black
            } else if model.dayType == .weekend || model.dayType == .holiday {    // 周末或节假日
                self.solar.textColor = HENormalCalendarWeekendColor
                self.lunar.textColor = HENormalCalendarWeekendColor
            }
            
            if model.isSelected {     // 选中
                self.selectView.isHidden = false
                self.solar.textColor = UIColor.white
                self.lunar.textColor = UIColor.white
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectView.center = self.contentView.center;
        let y = CGFloat(10)
        let height = (self.height - CGFloat(y * 2)) / 2
        self.solar.frame = CGRect(x: CGFloat(0), y: y, width: self.width, height: height)
        self.lunar.frame = CGRect(x: CGFloat(0), y: self.solar.bottom, width: self.width, height: height)
    }
    
    func configureAppearance() {
        self.updateTextColor()
    }
    
}
