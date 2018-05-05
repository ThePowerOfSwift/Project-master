//
//  HENormalCalendarViewController.swift
//  Project
//
//  Created by weixhe on 2018/5/4.
//  Copyright © 2018年 com.weixhe. All rights reserved.
//

import UIKit

private let cellIdentify = "HENormalCalendarCell"

class HENormalCalendarViewController: HEBaseViewController {

    var logic = HECalendarLogic()
    var collectionView: UICollectionView!
    var monthModels: [HECalendarMonthModel]!     // 所有的月份
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.logic.minimumDate = Date.distantPast
        self.logic.maximumDate = Date.distantFuture
        
        
        self.collectionView = ccollectionViwe(delegate: self, dataSource: self, layout: HENomalCalendarFlowLayout(), super: self.view)
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.register(HENormalCalendarCell.self, forCellWithReuseIdentifier: cellIdentify)
        self.collectionView.frame = CGRect(x: 0, y: navigation_height(), width: SCREEN_WIDTH, height: self.thisViewHeight)
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
