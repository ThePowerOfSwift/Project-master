//
//  CVTestViewController.swift
//  Project
//
//  Created by caven on 2018/5/24.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit

class CVTestViewController: CVBaseViewController {
    
    var index:Int?
    var title_1 = ["热点", "新闻", "关注", "视频", "小火山视频", "soho", "北京", "推荐", "问题", "有奖竞答", "发钱了", "asdf"];
    let title_2: Array<String> = ["热点", "新闻", "视频"];
    var title_3: Array<String> = ["分类", "时间", "地点"];

    var tabbar: CVPageTabBarView!
    var tabbar1: CVPageTabBarView!
    var tabbar3: CVPageTabBarView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.index != nil && self.index! == 1 { // tabbar
            self.tabbar = CVPageTabBarView(frame: CGRectMake(0, 80, SCREEN_WIDTH, 50), delegate: self, dataSource: self)
            self.view.addSubview(self.tabbar)
            self.tabbar.backgroundColor = UIColor.brown
            self.tabbar.reloadData()
            
            self.tabbar1 = CVPageTabBarView(frame: CGRectMake(0, tabbar.cv_bottom + 10, SCREEN_WIDTH, 40), delegate: self, dataSource: self)
            self.view.addSubview(self.tabbar1)
            self.tabbar1.backgroundColor = UIColor.grayColor_cc
            self.tabbar1.reloadData()
            
            cv_delay(1) { [unowned self] in
                self.title_1 = ["北京", "推荐", "问题", "有奖竞答", "发钱了", "热点", "新闻", "关注", "视频", "小火山视频", "soho"];
                self.tabbar.reloadData()
            }
            
            self.tabbar3 = CVPageTabBarView(frame: CGRectMake(0, tabbar1.cv_bottom + 10, SCREEN_WIDTH, 40), delegate: self, dataSource: self)
            self.view.addSubview(self.tabbar3)
            self.tabbar3.backgroundColor = UIColor.grayColor_cc
            self.tabbar3.resumeWhenDuplicate = true
            self.tabbar3.reloadData()
            
        } else if self.index != nil && self.index! == 2 { // pageview

            
        } else if self.index != nil && self.index! == 3 { // tabbar + pageview
            
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension CVTestViewController: CVPageTabBarDelegate, CVPageTabBarDataSource {
    /// 返回有多少个tab标签
    func cv_numberOfTabs(tabBar: CVPageTabBarView) -> Int {
        if tabBar == self.tabbar {
            return title_1.count
        } else if tabBar == self.tabbar1 {
            return title_2.count
        } else if tabBar == self.tabbar3 {
            return title_3.count
        }
        return 0
    }
    /// 返回tabBar上的每一个tab标签，标签必须继承自CVPageTabControl
    func cv_tabBar(_ tabBar: CVPageTabBarView, index: Int) -> CVPageTabItem {
        var view = CVPageTabItem.init(style: .default)
        if tabBar == self.tabbar {
            view.highlightColor = UIColor.colorWithHex(0x33ECDD)
            view.highlightFont = UIFont.font_16
            
            view.text = title_1[index]
            view.font = UIFont.font_13
        } else if tabBar == self.tabbar1 {
            view = CVSortTabView()
            view.highlightColor = UIColor.colorWithHex(0x33ECDD)
            view.highlightFont = UIFont.font_16
            
            view.text = title_2[index]
            view.font = UIFont.font_13
        } else if tabBar == self.tabbar3 {
            let view1 = CVCateTabItem.init(style: .custom)
            view1.titleLabel.text = title_3[index]
            view1.highlightColor = UIColor.colorWithHex(0x33ECDD)
            return view1
        }
        return view
    }
    
    /// 返回tabBar上的mask，mask必须继承自CVPageTabMaskView
    func cv_tabMask(tabBar: CVPageTabBarView) -> CVPageTabMaskView? {
        if tabBar == self.tabbar {
            let mask = CVPageTabMaskView(lineRatio: 1)
            return mask
        }

        if tabBar == self.tabbar1 {
            let mask = CVPageTabMaskView(lineRatio: 0.5)
            return mask
        }
        if tabBar == self.tabbar3 {
            return nil
        }
        return CVPageTabMaskView()
    }
    
    /// 返回tab标签距离两侧的偏移量
    func cv_preferTabLeftOffset(tabBar: CVPageTabBarView) -> CGFloat {
        if tabBar == self.tabbar {
            return 15
        } else if tabBar == self.tabbar1 {
            return 0
        } else if tabBar == self.tabbar3 {
            return 0
        }
        return 15
    }
    /// 返回每一个tab标签的宽度
    func cv_tabWidth(tabBar: CVPageTabBarView, index: Int) -> CGFloat {
        if tabBar == self.tabbar {
            let text = title_1[index]
            return text.autoWidth(font: UIFont.font_13, fixedHeight: 14) + 20
        } else if tabBar == self.tabbar1 {
            return CGFloat(self.tabbar.cv_width / CGFloat(title_2.count))
        }  else if tabBar == self.tabbar3 {
            return CGFloat(self.tabbar.cv_width / CGFloat(title_3.count))
        }
        return 0
    }
    
    /// 点击某一个tab标签的回调
    func cv_tabBar(_ tabBar: CVPageTabBarView, didSelected index: Int) {
        CVLog(index)
        
        if tabBar == self.tabbar3 {
            cv_delay(2) { [unowned self] in
                self.title_3 = ["分类", "3132132", "地点"]
//                    weakSelf.tabbar3.reloadData()
                self.tabbar3.reloadData(index: index, state: .normal, animation: true)
            }
        }
    }
}
