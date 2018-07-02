//
//  CVPageTabBarProtocol.swift
//  Project
//
//  Created by caven on 2018/5/24.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import Foundation
import UIKit

@objc protocol CVPageTabBarDataSource: class {
    /// 返回有多少个tab标签
    func cv_numberOfTabs(tabBar: CVPageTabBarView) -> Int
    /// 返回tabBar上的每一个tab标签，标签必须继承自CVPageTabControl
    func cv_tabBar(_ tabBar: CVPageTabBarView, index: Int) -> CVPageTabItem
    
    /// 返回tab标签距离两侧的偏移量
    @objc optional func cv_preferTabLeftOffset(tabBar: CVPageTabBarView) -> CGFloat
    /// 返回每一个tab标签的宽度
    @objc optional func cv_tabWidth(tabBar: CVPageTabBarView, index: Int) -> CGFloat
    
    /// 返回tabBar上的mask，mask必须继承自CVPageTabMaskView
    @objc optional func cv_tabMask(tabBar: CVPageTabBarView) -> CVPageTabMaskView?
}

@objc protocol CVPageTabBarDelegate: class {
    
    /// 某一个tab标签是否能点击
    @objc optional func cv_tabBar(_ tabBar: CVPageTabBarView, canSelected index: Int) -> Bool
    
    /// 点击某一个tab标签的回调
    @objc optional func cv_tabBar(_ tabBar: CVPageTabBarView, didSelected index: Int)
    
}



/// tab标签需要实现的协议
@objc protocol CVPageTabProtocol: class {
    
    func cv_setNormalState(animation: Bool)
    func cv_setHighlightState(animation: Bool)
    func cv_setDisabledState(animation: Bool)
}
