//
//  CVNormalCalendarViewController.swift
//  Project
//
//  Created by caven on 2018/5/4.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit

private let cellIdentify = "CVNormalCalendarCell"
private let headerIdentify = "CVNormalCalendarHeaderView"

/// 日历控件选择类型：单选、多选
enum CanlendarSelectedType {
    case single     // 单选
    case multiple   // 多选
}

class CVNormalCalendarViewController: CVBaseViewController {

    var gregorian: Calendar = Calendar(identifier: .gregorian)   // 公历
    
    var logic: CVCalendarLogic = CVCalendarLogic()
    var collectionView: UICollectionView!
    var monthModels: [CVCalendarMonthModel]!     // 所有的月份
    var today: Date = Date.locatonDate    // 今天，日历默认显示today所在的月份
    var currentPage: Date!  // 日历当前页显示的月份
    var selectedDate: [String] = [String]()
    var selectedType: CanlendarSelectedType = .multiple
    var isPagingEnabled: Bool = false
    
    deinit {
        CVLog(message: "release normal calendar")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.currentPage = self.today.startOfThisMonth()
        self.selectedDate = [Date.stringFormDate(self.today)]
        
        self.logic.gregorian = self.gregorian
        self.logic.minimumDate = Date().addingMonths(-1000)
        self.logic.maximumDate = Date()
//        self.logic.isDisplayChineseCalender = false
        
        // layout
        let layout = CVNomalCalendarFlowLayout()
        layout.calendar = self
        
        self.collectionView = ccollectionView(delegate: self, dataSource: self, layout: layout, super: self.view)
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.isPagingEnabled = self.isPagingEnabled
        self.collectionView.register(CVNormalCalendarCell.self, forCellWithReuseIdentifier: cellIdentify)
        self.collectionView.register(CVNormalCalendarHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentify)
        self.collectionView.frame = CGRect(x: 0, y: navigation_height(), width: SCREEN_WIDTH, height: self.thisViewHeight)
        
        self.adjustMonthPosition()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// 绑定数据
    func requestBoundingDatesIfNecessary() {
        // ... 这里是刷新数据之前，可以做一些自己的东西
        self.logic.requestBoundingDatesIfNecessary()
    }
    
    /// 滚动当前选中月份
    func scrollToSelectedMonthForDate(_ date: Date, animation: Bool) {
        let indexPath = self.logic.indexPathForDate(date)
        self.collectionView.scrollToItem(at: indexPath, at: .top, animated: animation)
    }
    
    /// 初始化时显示日历的位置
    func adjustMonthPosition() {
        self.requestBoundingDatesIfNecessary()
        var targetDate = self.today
        if self.selectedDate.count > 0 {
            self.currentPage = Date.dateFromString(self.selectedDate[0])!.startOfThisMonth()  // 如果selectedDate存在，则默认滑动到选中的第一个日期所在的月份
        }
        targetDate = self.currentPage
        self.scrollToSelectedMonthForDate(targetDate, animation: false)
    }
     var n: Int = 0
}

extension CVNormalCalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.requestBoundingDatesIfNecessary()  // 先绑定数据
        return self.logic.numberOfMonths
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 返回 行数*7
        return self.logic.numberOfRowsInSection(section: section) * 7
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentify, for: indexPath) as! CVNormalCalendarHeaderView
            let thisMonth = self.logic.monthForSection(indexPath.section)    // 本月的date
            headerView.gregorian = self.gregorian
            headerView.titleLabel.text = Date.stringFormDate(thisMonth, format: yyyy_MM)
            return headerView
        }
        return UICollectionReusableView()
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentify, for: indexPath) as! CVNormalCalendarCell
        n = n + 1
        print(n)
        let thisMonth = self.logic.monthForSection(indexPath.section)    // 本月的date
        let date = self.logic.dateForIndexPath(indexPath)
        let model: CVCalendarModel = self.logic.generalCalendarModel(date: date, key: Date.stringFormDate(thisMonth, format: yyyy_MM))
        // 处理选中的日期
        model.isSelected = false
        if self.selectedDate.count > 0 {
            for sele in self.selectedDate {
                if Date.stringFormDate(model.date) == sele {
                    model.isSelected = true
                    break
                }
            }
        }
        cell.model = model
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let date = self.logic.dateForIndexPath(indexPath)
        let thisCell = collectionView.cellForItem(at: indexPath) as! CVNormalCalendarCell
        if thisCell.model.isEnable == false {
            return
        }
        if self.selectedType == .single {
            self.selectedDate[0] = Date.stringFormDate(date)
        } else if self.selectedType == .multiple {
            if self.selectedDate.contains(Date.stringFormDate(date)) {
                self.selectedDate.remove(Date.stringFormDate(date))
            } else {
                self.selectedDate.append(Date.stringFormDate(date))
            }
        }
        
        for cell in collectionView.visibleCells {
            let cell =  cell as! CVNormalCalendarCell
            cell.model.isSelected = false
            if self.selectedDate.contains(Date.stringFormDate(cell.model.date)) {
                cell.model.isSelected = true
            }
            cell.configureAppearance()
        }
    }
}
