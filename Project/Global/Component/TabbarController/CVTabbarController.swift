//
//  CVTabbarController.swift
//  Project
//
//  Created by caven on 2018/3/15.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit

class CVTabbarController: UITabBarController, UITabBarControllerDelegate {
    
    public var cv_tabbar: CVTabBar!
    public var cv_tabbarItems: [CVTabBarItem] = []
    public var cv_showItems: [Int] = []   // 控制在tabbar上面显示的item
    
    private var cv_hidenTabBar: Bool = false
    
    override var viewControllers: [UIViewController]? {
        didSet {
            // 遍历所有的控制器，生成对应的cv_tabBarItem
            if viewControllers != nil {
                for (index, con) in viewControllers!.enumerated() {
                    if con.isKind(of: UINavigationController.self) {
                        let controller = (con as! UINavigationController).viewControllers.first
                        if controller != nil {
                            self.initialTabBarItem(controller!.cv_tabbarItem, index: index)
                        }
                    } else if con.isKind(of: UIViewController.self) {
                        self.initialTabBarItem(con.cv_tabbarItem, index: index)
                    }
                }
            }
            
            self.updateTabBar()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cv_tabbar = CVTabBar()
        self.tabBar.addSubview(self.cv_tabbar)
        self.cv_tabbar.frame = self.tabBar.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARKL: - Public Method
//    /// 显示tabBar
//    public func showTabBar(animation: Bool = true) {
//        if self.cv_hidenTabBar {
//            UIView.animate(withDuration: animation ? 0.2 : 0.0, animations: {
//
//                self.cv_tabbar.isHidden = false
//                self.cv_tabbar.frame = CGRectMake(0, SCREEN_HEIGHT - self.cv_tabbar.cv_height, SCREEN_WIDTH, self.cv_tabbar.cv_height)
//
//            }) { (finish) in
//                self.cv_hidenTabBar = false
//            }
//        }
//    }
//
//    /// 隐藏tabBar
//    public func hiddenTabBar(animation: Bool = true) {
//        if self.cv_hidenTabBar == false {
//            UIView.animate(withDuration: animation ? 0.2 : 0.0, animations: {
//
//                self.cv_tabbar.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.cv_tabbar.cv_height)
//
//            }) { (finish) in
//                self.cv_tabbar.isHidden = true
//                self.cv_hidenTabBar = true
//            }
//        }
//    }
    
    // MARKL: - Private Method
//    /// 隐藏真正的tabBar
//    private func hidenRealTabBar()  {
//        for view in self.view.subviews {
//            if view.isKind(of: UITabBar.self) {
//                view.isHidden = true
//                view.frame.origin.y = SCREEN_HEIGHT + 100
//            }
//        }
//    }
    
    
}

// MARK: 私有方法
extension CVTabbarController {
    /// 初始化tabbarItem
    private func initialTabBarItem(_ item: CVTabBarItem, index: Int) {
        item.index = index
        item.clickItem = { [weak self] (tabBarItem: CVTabBarItem) in
            
            guard let strongSelf = self else { return }
            
            for (_, key) in strongSelf.cv_showItems.enumerated() {
                let item = strongSelf.cv_tabbarItems[key]
                item.isSelected = false
            }
            tabBarItem.isSelected = true
            strongSelf.selectedIndex = tabBarItem.index
        }
        self.cv_tabbarItems.append(item)
    }
    
    /// 更新cv_tabBar上面的item
    private func updateTabBar() {
        for item in self.cv_tabbarItems {
            item.removeFromSuperview()
        }
        if self.cv_showItems.count == 0 {  // 如果没有手动控制tabbar上显示的item，则直接从头布局
            for i in 0..<self.cv_tabbarItems.count {
                self.cv_showItems.append(i)
            }
        }
        
        if self.cv_showItems.count == 0 { return }
        let width = SCREEN_WIDTH / CGFloat(self.cv_showItems.count)
        for (index, key) in self.cv_showItems.enumerated() {
            let item = self.cv_tabbarItems[key]
            self.cv_tabbar.addSubview(item)
            item.frame = CGRectMake(width * CGFloat(index), 0, width, 49)
            item.isSelected = index == self.selectedIndex ? true : false
        }
    }
}
