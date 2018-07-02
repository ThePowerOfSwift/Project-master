//
//  CVCycleScrollView.swift
//  Project
//
//  Created by caven on 2018/4/15.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit

protocol CVCycleScrollViewDelegate {
    func didSelectItem(atIndex: Int, model: CVCycleScrollModel) -> Void
}

/// 闭包：点击了某一个item
typealias CycleCallBack = (Int, CVCycleScrollModel) -> ()

class CVCycleScrollView: UIView {
    
    /// 是否自动滚动, 默认 不自动
    var autoScroll: Bool = true
    /// 是否开启无限循环, 默认 开启
    var infiniteLoop: Bool = true {
        didSet {
            maxSections = 1;
            collectionView.reloadData()
            self.initCollectionPosition()
        }
    }
    /// 滚动间隔时间, 默认2s
    var autoScrollTimeInterval: Double = 3.0
    /// PageControl bottom间距
    var pageControlBottom: CGFloat = 11.0
    /// 开启/关闭URL特殊字符处理
    var isAddingPercentEncodingForURLString: Bool = false
    
    /// 点击事件的回调
    var didSelectItemAtIndex: CycleCallBack?
    var delegate: CVCycleScrollViewDelegate?
    
    
    // MARK: 数据源
    var dataSource: Array<CVCycleScrollModel>! {
        didSet {
            if dataSource.count > 1 {
                collectionView.isScrollEnabled = true
                self.pageControl.isHidden = false
            } else {
                collectionView.isScrollEnabled = false
                self.pageControl.isHidden = true
            }
            self.pageControl.numberOfPages = dataSource.count
            collectionView.reloadData()
            self.initCollectionPosition()
        }
    }
    
    // 计时器
    private var timer: CVTimer!
    private var counting: Double = 0       // timer计时
    private var collectionView: UICollectionView!
    // FlowLayout
    lazy fileprivate var flowLayout: UICollectionViewFlowLayout? = {
        let tempFlowLayout = UICollectionViewFlowLayout.init()
        tempFlowLayout.minimumLineSpacing = 0
        tempFlowLayout.minimumInteritemSpacing = 0
        tempFlowLayout.scrollDirection = .horizontal
        return tempFlowLayout
    }()

    /// pageControl
    private var pageControl: UIPageControl!
    
    /// 为了能够循环更流程，多设几组，多少组都可以最少三组
    private var maxSections = 3

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.collectionView = cv_collectionViwe(delegate: self, dataSource: self, super: self)
        self.collectionView.collectionViewLayout = self.flowLayout!
        self.collectionView.register(CVCycleCell.self, forCellWithReuseIdentifier: "Cell")
        self.collectionView.isPagingEnabled = true
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        self.dataSource = [CVCycleScrollModel]()
        
        self.pageControl = self.defaultPageControl()
        
        self.timer = defaultTimer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: layoutSubviews
    override open func layoutSubviews() {
        super.layoutSubviews()
        flowLayout?.itemSize = self.frame.size
    }
    
    func defaultTimer() -> CVTimer {
        let t = CVTimer.timer(timeInterval: 1, delegete: self)
        t.start()
        counting = 0;
        return t
    }
    
    func defaultPageControl() -> UIPageControl {
        let c = UIPageControl(frame: CGRect.zero)
        c.hidesForSinglePage = true
        self.addSubview(c)
        c.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(40)
        }
        return c
    }
    
    /// 初始化collection的位置
    func initCollectionPosition() {
        if maxSections == 3 {       // 可循环滑动
            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 1), at: .left, animated: false)
        }
    }
    
}



extension CVCycleScrollView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataSource.count == 0 ? 0 : self.maxSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CVCycleCell
        let model = self.dataSource[indexPath.item]
        cell.imageView.kf.indicatorType = .activity
        
        if model.imageName.count != 0 {     // 本地图片
            cell.imageView.image = UIImageNamed(model.imageName)
        } else {        // 网络图片
            cell.imageView.kf.setImage(with: URL(string: model.url)!, placeholder: UIImageNamed(model.placeholder))
        }
        
        /// cell上配置title属性
        cell.title = model.title
        cell.titleFont = model.font
        cell.titleColor = model.textColor
        cell.titleBackViewBackgroundColor = model.titleBackgroundColor
        cell.numberOfLines = model.numberOfLines
        cell.titleLabelLeading = model.titleLeading
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.didSelectItemAtIndex != nil {
            let model = self.dataSource[indexPath.item]
            self.didSelectItemAtIndex!(indexPath.item, model)
        }
        
        if let del = self.delegate {
            let model = self.dataSource[indexPath.item]
            del.didSelectItem(atIndex: indexPath.item, model: model)
        }
    }
}

extension CVCycleScrollView: UIScrollViewDelegate {
    /// 在这个方法中算出当前页数
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int((scrollView.contentOffset.x + scrollView.width * 0.5) / scrollView.width)
        let currentPage = page % self.dataSource.count
        self.pageControl.currentPage = currentPage
    }
    
    /// 在开始拖拽的时候移除定时器
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if self.autoScroll {
            self.timer.end()
        }
    }
    
    /// 结束拖拽的时候重新添加定时器
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.autoScroll {
            self.timer.start()
            counting = 0;
        }
    }
    
    /// 手动滑动
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int((scrollView.contentOffset.x) / scrollView.width)
        let currentPage = page % self.dataSource.count
        self.pageControl.currentPage = currentPage
        if autoScroll || infiniteLoop {
            CVLog(message: "\(pageControl.currentPage)");
            self.collectionView.scrollToItem(at: IndexPath(item: pageControl.currentPage, section: 1), at: .left, animated: false)
        }
    }
}

extension CVCycleScrollView: CVTimerDelegate {
    func timer(timer: CVTimer, counting: Int, finish: Int) {
        if autoScroll {
            self.nextImage()
        }
    }
    
    /// timer 开始
    private func nextImage() {
        if self.dataSource.count == 0 || collectionView.indexPathsForVisibleItems.count == 0 {
            return
        }
        
        
        counting = counting > 9999 ? 1 : counting + 1;
        if counting.truncatingRemainder(dividingBy: self.autoScrollTimeInterval) != 0 {
            return
        }
        
        // 获取当前indexPath
        let currentIndexPath = collectionView.indexPathsForVisibleItems.last!
        // 获取中间那一组的indexPath
        let middleIndexPath = IndexPath(item: currentIndexPath.item, section: 1)
        // 滚动到中间那一组
        collectionView.scrollToItem(at: middleIndexPath, at: .left, animated: false)
        
        // 判断是否切换section
        var nextItem = middleIndexPath.item + 1
        var nextSection = middleIndexPath.section
        if nextItem == self.dataSource.count {      // 下一个是溢出了中间组
            nextItem = 0
            nextSection += 1
        }
        
        collectionView.scrollToItem(at: IndexPath(item: nextItem, section: nextSection), at: .left, animated: true)
    }
}
