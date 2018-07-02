//
//  CVPageTabBarView.swift
//  Project
//
//  Created by caven on 2018/5/24.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit

private let width_tabs: CGFloat  = 40
private let offset_left: CGFloat  = 5
private let tab_tag = 1000

class CVPageTabBarView: UIView {
    
    var delegate: CVPageTabBarDelegate?
    var dataSource: CVPageTabBarDataSource?
    var currentIndex: Int = 0
    var resumeWhenDuplicate = false      // 当重复点击时恢复原状态
    
    private var offSet: CGFloat = 0
    private var numOfTabs: Int = 0
    private var items: [CVPageTabItem] = [CVPageTabItem]()
    private var itemWidths: [CGFloat] = [CGFloat]()
    private var scrollView: UIScrollView!
    private var tabMask: CVPageTabMaskView?
    
    convenience init(frame: CGRect, delegate: CVPageTabBarDelegate, dataSource: CVPageTabBarDataSource) {
        self.init(frame: frame)
        self.delegate = delegate;
        self.dataSource = dataSource;
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.scrollView = cv_scrollView(delegate: self, super: self)
        self.scrollView.frame = self.bounds
        
        self.scrollView.isDirectionalLockEnabled = true
        self.scrollView.scrollsToTop = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        // 偏移量
        if self.dataSource == nil {
            return
        }
        
        self.offSet = self.dataSource!.cv_preferTabLeftOffset?(tabBar: self) ?? offset_left
        self.numOfTabs = self.dataSource!.cv_numberOfTabs(tabBar: self)
        self.setupLabels()
    }
    
    /// 刷新数据
    func reloadData() {
        self.setup()
    }
    
    /// 刷新单个tab标签数据
    func reloadData(index: Int, state: CVPageTabState, animation: Bool) {
        guard index >= 0 && index < self.items.count else {
            assertionFailure("index must be between 0 and \(self.items.count - 1);")
            return
        }
        
        let view = self.items[index]
        view.removeFromSuperview()
        
        self.addOneTab(at: index, state: state, animation: animation)
        
        // 更新布局
        self.layoutTabFrame()
    }
    
    /// 创建tab标签
    private func setupLabels() {
        self.scrollView.removeAllSubViews()
        self.items.removeAll()
        self.itemWidths.removeAll()
        self.scrollView.contentSize = CGSize.zero
        if self.numOfTabs <= 0 || self.dataSource == nil {
            return
        }
        
        for i in 0..<self.numOfTabs {
            self.addOneTab(at: i, state: .normal, animation: false)
        }
        
        // 更新布局
        self.layoutTabFrame()
        
        // maskView
        self.tabMask = self.dataSource?.cv_tabMask?(tabBar: self)
        if self.tabMask != nil {
            self.scrollView.addSubview(self.tabMask!)
            self.scrollView.sendSubview(toBack: self.tabMask!)
        }
        
        // 默认选中
        self.InitSelect()
    }
    
    /// 添加一个tab标签
    private func addOneTab(at index: Int, state: CVPageTabState, animation: Bool) {
        
        let width = self.dataSource!.cv_tabWidth?(tabBar: self, index: index) ?? width_tabs
        let oneTab = self.dataSource!.cv_tabBar(self, index: index)
        oneTab.tag = tab_tag + index
        oneTab.addTarget(self, action: #selector(onClickTabAction(tabItem:)), for: .touchUpInside)
        self.scrollView.addSubview(oneTab)
        
        if state == .normal {
            oneTab.cv_setNormalState(animation: animation)
        } else if state == .highlighted {
            oneTab.cv_setHighlightState(animation: animation)
        } else if state == .disabled {
            oneTab.cv_setDisabledState(animation: animation)
        }
        if self.items.count <= index { // 最后一个直接添加
            self.items.append(oneTab)
            self.itemWidths.append(width)
        } else {  // index 是中间位置，则replace
            self.items[index] = oneTab
            self.itemWidths[index] = width
        }
    }
    
    /// 更新tab标签的布局
    private func layoutTabFrame() {
        var x: CGFloat = self.offSet
        var width: CGFloat = 0
        for i in 0..<self.numOfTabs {
            width = self.itemWidths[i]
            let oneTab = self.items[i]
            oneTab.frame = CGRectMake(x, 0, width, self.cv_height)
            x += width
        }
        self.scrollView.contentSize = CGSizeMake(x + self.offSet, self.cv_height)
    }
    
    // MARK: - Actions
    @objc private func onClickTabAction(tabItem: CVPageTabItem) {
        
        let canSelect = self.delegate?.cv_tabBar?(self, canSelected: tabItem.tag - tab_tag) ?? true
        if canSelect { // 能点击
            
            // 点击自身
            if tabItem.tabState == .highlighted {
                if self.resumeWhenDuplicate {
                    tabItem.cv_setNormalState(animation: true)
                    return
                }
            }
            
            // 点击其他的item
            for one in self.items {
                if one.tabState != .normal {
                    one.cv_setNormalState(animation: true)
                }
            }
            tabItem.cv_setHighlightState(animation: true)
            self.currentIndex = tabItem.tag - tab_tag
            self.delegate?.cv_tabBar?(self, didSelected: tabItem.tag - tab_tag)
            self.setCurrentIndex(tabItem.tag - tab_tag)
        }
    }
    
    // MARK: - Private Method
    private func InitSelect() {
        if self.currentIndex < 0 {
            self.currentIndex = 0
        } else if self.currentIndex >= self.items.count {
            self.currentIndex = self.items.count - 1
        }
        
//        for one in self.items {
//            one.cv_setNormalState(animation: false)
//        }
        let tab = self.items[self.currentIndex]
        tab.cv_setHighlightState(animation: false)
        self.setCurrentIndex(tab.tag - tab_tag)
    }
    
    private func setCurrentIndex(_ index: Int) {
        self.scrollTab(to: index)
        self.scrollTabMask(to: index, animation: true)
    }
    
    /// 滑动tab标签
    private func scrollTab(to index: Int) {
        if self.items.count <= index || self.scrollView.contentSize.width < self.frame.size.width {
            return
        }
        
        if index == self.items.count - 1 && index != 0 {
            self.scrollView.setContentOffset(CGPointMake(self.scrollView.contentSize.width - self.frame.size.width + self.scrollView.contentInset.right, 0), animated: true)
        } else {
            let nextTitleView = self.items[index]
            
            let tabExceptInScreen = UIScreen.main.bounds.size.width - nextTitleView.frame.size.width
            let tabPaddingInScreen = tabExceptInScreen / 2.0
            let offsetX = max(0, min(nextTitleView.frame.origin.x - tabPaddingInScreen, (self.items.last?.frame.origin.x)! - tabExceptInScreen))
            
            let nextPoint = CGPoint.init(x: offsetX, y: 0)
            self.scrollView.setContentOffset(nextPoint, animated: true)
            
        }
    }
    
    /// 滑动maskView
    private func scrollTabMask(to index: Int, animation: Bool) {
        if self.items.count <= index || index < 0 {
            return
        }
        
        if let tabMask = self.tabMask {
            let currentTab = self.items[index]
            if animation {
                UIView.animate(withDuration: 0.3) {
                    tabMask.frame = currentTab.bounds
                    tabMask.center.x = currentTab.center.x
                }
            } else {
                tabMask.frame = currentTab.bounds
                tabMask.center.x = currentTab.center.x
            }
        }
    }
}
