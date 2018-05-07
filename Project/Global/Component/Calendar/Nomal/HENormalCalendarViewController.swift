//
//  HENormalCalendarViewController.swift
//  Project
//
//  Created by weixhe on 2018/5/4.
//  Copyright © 2018年 com.weixhe. All rights reserved.
//

import UIKit

private let cellIdentify = "HENormalCalendarCell"
private let headerIdentify = "HENormalCalendarHeaderView"
class HENormalCalendarViewController: HEBaseViewController {

    var gregorian: Calendar = Calendar(identifier: .gregorian)   // 公历
    
    var logic: HECalendarLogic = HECalendarLogic()
    var collectionView: UICollectionView!
    var monthModels: [HECalendarMonthModel]!     // 所有的月份
    var today: Date = Date()    // 今天，日历默认显示today所在的月份
    var currentPage: Date!  // 日历当前页显示的月份
    var selectedDate: Date?
    var isPagingEnabled: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.currentPage = today.startOfThisMonth()
        
        self.logic.gregorian = self.gregorian
        self.logic.minimumDate = Date.distantPast
        self.logic.maximumDate = Date.distantFuture
        
        // layout
        let layout = HENomalCalendarFlowLayout()
        layout.calendar = self
        
        self.collectionView = ccollectionViwe(delegate: self, dataSource: self, layout: layout, super: self.view)
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.isPagingEnabled = self.isPagingEnabled
        self.collectionView.register(HENormalCalendarCell.self, forCellWithReuseIdentifier: cellIdentify)
        self.collectionView.register(HENormalCalendarHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentify)
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
        if self.selectedDate != nil {
            self.currentPage = self.selectedDate?.startOfThisMonth()
        }
        targetDate = self.currentPage
        self.scrollToSelectedMonthForDate(targetDate, animation: false)
    }
    
}

extension HENormalCalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentify, for: indexPath) as! HENormalCalendarHeaderView
            let thisMonth = self.logic.months[indexPath.section]!    // 本月的date
            headerView.gregorian = self.gregorian
            headerView.titleLabel.text = Date.stringFormDate(thisMonth)
            return headerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentify, for: indexPath) as! HENormalCalendarCell
        
        let date = self.logic.dateForIndexPath(indexPath)
        let model: HECalendarModel = self.logic.generalCalendarModel(year: date.year, month: date.month, day: date.day)
        let thisMonth = self.logic.months[indexPath.section]!    // 本月的date
        if !(date.year == thisMonth.year && date.month == thisMonth.month) {
            model.dayType = .past
        }
        cell.model = model
        return cell
    }
}
