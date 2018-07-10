//
//  CVDatePickerView.swift
//  Project
//
//  Created by caven on 2018/5/22.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit

class CVDatePickerView: UIView {

    var minimumDate: Date = Date.dateFromString("1900-01-01")!
    var maximumDate: Date = Date.dateFromString("2900-12-31")!
    var currentDate: Date {
        
        set {
            var newValue = newValue
            
            if newValue.isEqualToDate(self.minimumDate) || newValue.isLaterToDate(self.maximumDate) {
                newValue = self.minimumDate
            }
            self.yearIndex = newValue.year - self.minimumDate.year
            self.monthIndex = newValue.year == self.minimumDate.year ? newValue.month - self.minimumDate.month : newValue.month - 1
            self.dayIndex = (newValue.year == self.minimumDate.year && newValue.month == self.minimumDate.month) ? newValue.day - self.minimumDate.day : newValue.day - 1
            self.pickerView.selectRow(self.yearIndex, inComponent: 0, animated: true)
            self.pickerView.selectRow(self.monthIndex, inComponent: 1, animated: true)
            self.pickerView.selectRow(self.dayIndex, inComponent: 2, animated: true)
        }
        get {
            let year = yearIndex + self.minimumDate.year
            let month = monthIndex + self.minimumDate.month
            let day = dayIndex + self.minimumDate.day
            return Date.dateFromString("\(year)-\(month)-\(day)")!
        }
    }
    
    /// 最终选择日期的结果
    var ClosureOnCheckSelectedDate: ((Date)->())?
    
    
    private var pickerView: CVPickerView!
    
    /// 这些是年月日对应的索引值
    private var yearIndex: Int = 0
    private var monthIndex: Int = 0
    private var dayIndex: Int = 0

    private var year_count: Int = 0     // 总年数
    private var month_count: Int = 0    // 某年的总月数
    private var day_count: Int = 0      // 某月的总天数
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.pickerView = cv_cpickerView(delegate: self, dataSource: self, super: self)
        // Swift中,在初始化时didSet不被调用或无效的解决方法, 可以采用KVC方式给对象初始化,通过KVC方法赋值后,必须添加setValueforUndefinedKey方法做特殊处理,否则运行到KVC方法时程序会报错
        self.setValue(Date.locatonDate, forKey: "currentDate")
        
    }
    
    convenience init(frame: CGRect, result: @escaping ((Date)->())) {
        self.init(frame: frame)
        self.ClosureOnCheckSelectedDate = result

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 调用KVC的方法key值错误后调用
    override func setValue(_ value: Any?, forKey key: String) {
        // 重新使用value赋值给str属性就可以成功调用didSet方法
        if key == "currentDate" {
            guard let newStr = value as? Date else {
                return
            }
            currentDate = newStr
        }
        
    }
}

extension CVDatePickerView : CVPickerViewDelegate, CVPickerViewDataSource {
    func cv_numberOfComponents(in pickerView: CVPickerView) -> Int {
        return 3
    }
    
    func cv_pickerView(_ pickerView: CVPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            self.year_count = self.maximumDate.year - self.minimumDate.year
            return self.year_count
        } else if component == 1 {
            let year = self.minimumDate.year + self.yearIndex
            if year == self.minimumDate.year {
                self.month_count = 12 - self.minimumDate.month + 1
            } else if year == self.maximumDate.year {
                self.month_count = self.maximumDate.month
            } else {
                self.month_count = 12
            }
            return self.month_count
        } else {
            switch self.monthIndex + 1 {
            case 1, 3, 5, 7, 8, 10, 12:
                self.day_count = 31
                return self.day_count
            case 4, 6, 9, 11:
                self.day_count = 30
                return self.day_count
            default:
                let year = self.minimumDate.year + self.yearIndex
                if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
                    self.day_count = 29
                    return self.day_count       // 闰年
                }
                self.day_count = 28
                return self.day_count
            }
        }
    }
    
    
    func cv_pickerView(_ pickerView: CVPickerView, viewForRow row: Int, forComponent component: Int, reusing view: CVPickerViewReusingView?) -> CVPickerViewReusingView {
        var cell = view
        if cell == nil {
            cell = CVPickerViewReusingView()
        }
        if component == 0 {
            cell!.textLabel.text = "\(self.minimumDate.year + row)" + "年"
        } else if component == 1 {
            cell!.textLabel.text = "\(1 + row)" + "月"
        } else {
            cell!.textLabel.text = "\(1 + row)" + "日"
        }
        return cell!
    }
    
    func cv_pickerView(_ pickerView: CVPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            self.yearIndex = row
            pickerView.reloadComponent(1)
            pickerView.reloadComponent(2)
        } else if component == 1 {
            self.monthIndex = row
            pickerView.reloadComponent(2)
            // 因为月份改变时，day的个数也会改变，所以需要单独处理几个临界值
            if self.monthIndex + 1 == 4 || self.monthIndex + 1 == 6 || self.monthIndex + 1 == 9 || self.monthIndex + 1 == 11 {
                if self.dayIndex + 1 == self.day_count {
                    self.dayIndex = self.day_count - 1;
                }
            } else if self.monthIndex + 1 == 2 {
                if self.dayIndex + 1 > self.day_count {
                    self.dayIndex = self.day_count - 1;
                }
            }
            
        } else {
            self.dayIndex = row
        }
    }
    
    func cv_cancel(_ pickerView: CVPickerView) {
        CVLog("Cancel Date PickerView")
    }
    
    func cv_done(_ pickerView: CVPickerView) {
        CVLog("Done Date PickerView")
        if let closure = self.ClosureOnCheckSelectedDate {
            let year = yearIndex + self.minimumDate.year
            let month = monthIndex + self.minimumDate.month
            let day = dayIndex + self.minimumDate.day
            closure(Date.dateFromString("\(year)-\(month)-\(day)")!)
        }
    }
    
    func cv_dismiss(_ pickerView: CVPickerView) {
        self.isHidden = true
    }
}

