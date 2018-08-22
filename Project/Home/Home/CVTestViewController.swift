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
        
        
        let view = cv_view(super: self.view)
        view.backgroundColor = UIColor.brown
        view.cv_leftEqualTo(self.view).offset(10)
        view.cv_rightEqualTo(self.view).offset(10)
        view.cv_topEqualTo(self.view).offset(100)
        view.cv_bottomEqualTo(self.view).offset(10)


        let v1 = cv_view(super: view)
        v1.backgroundColor = UIColor.randomColor
        
        v1.cv_leftEqualTo(10)
        v1.cv_topEqualTo(10)
        v1.cv_widthEqualTo(100)
        v1.cv_heightEqualTo(100)

        let v2 = cv_view(super: view)
        v2.backgroundColor = UIColor.randomColor
        
        v2.cv_leftEqualTo(v1, attribute: .right).offset(10)
        v2.cv_topEqualTo(v1)
        v2.cv_widthEqualTo(v1)
        v2.cv_heightEqualTo(v1)
        
        let v3 = cv_view(super: view)
        v3.backgroundColor = UIColor.randomColor
        
        v3.cv_leftEqualTo(v2, attribute: .right).offset(10)
        v3.cv_topEqualTo(v1)
        v3.cv_rightEqualTo(10)
        v3.cv_heightEqualTo(v1).multiply(0.45)
        
        let v4 = cv_view(super: view)
        v4.backgroundColor = UIColor.randomColor
        
        v4.cv_leftEqualTo(v3)
        v4.cv_rightEqualTo(v3)
        v4.cv_bottomEqualTo(v1, attribute: .bottom)
        v4.cv_heightEqualTo(v1).multiply(0.45)
        
        let v5 = cv_view(super: view)
        v5.backgroundColor = UIColor.randomColor
        v5.cv_topEqualTo(v1, attribute: .bottom).offset(10)
        v5.cv_centerXEqualTo(v1).offset(55)
        v5.cv_heightEqualTo(30)
        v5.cv_leftEqualTo(10)
        
        let v11 = cv_view(super: v1)
        v11.backgroundColor = UIColor.randomColor
        v11.cv_topEqualTo(10)
        v11.cv_centerXEqualTo(v1)
        v11.cv_heightEqualTo(30)
        v11.cv_leftEqualTo(10)
        
        let v12 = cv_view(super: v1)
        v12.backgroundColor = UIColor.randomColor
        v12.cv_topEqualTo(v11, attribute: .bottom).offset(5)
        v12.cv_centerYEqualTo(v1).offset(-25)
        v12.cv_centerXEqualTo(v1)
        v12.cv_widthEqualTo(20)
        
        let v6 = cv_view(super: view)
        v6.backgroundColor = UIColor.randomColor
        v6.cv_centerYEqualTo(v5)
        v6.cv_heightEqualTo(30)
        v6.cv_rightEqualTo(10)
        v6.cv_leftEqualTo(v5, attribute: .right).offset(10)

        let la1 = cv_label_mul(font: UIFont.font_12, text: "fasdfasfffasfasfasfasdfadsff   afasfd f asfas df发斯蒂芬阿发阿发按时发顺丰发阿斯蒂芬。艾绒 阿发阿发按时发生发顺丰按时发生发  阿斯蒂芬阿斯蒂芬阿发  啊水电费 ", super: view)
        la1.backgroundColor = UIColor.randomColor
        la1.cv_leftEqualTo(10)
        la1.cv_rightEqualTo(10)
        la1.cv_topEqualTo(v6, attribute: .bottom).offset(10)
        la1.autoHeight()
        
        
        return
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
