//
//  CVRefreshHeaderAnimator.swift
//  Project
//
//  Created by caven on 2018/4/15.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import Foundation
import UIKit
import GTMRefresh


// MARK: - 扩展TableView
extension UIScrollView {
    
    static func awake() {
        
    }
    
    func startRefreshing() {
        self.triggerRefreshing()
        self.endLoadMore(isNoMoreData: false)
    }
    
    func refreshing(refreshBlock: @escaping () -> Void) {
        self.gtm_addRefreshHeaderView(refreshBlock: refreshBlock)
        self.pullDownToRefreshText(LS(key: "PullToRefresh", comment: "下拉刷新"))
            .releaseToRefreshText(LS(key: "ReleaseToRefresh", comment: "松开刷新"))
            .refreshSuccessText("亲，成功了")
            .refreshFailureText("亲，无果")
            .refreshingText(LS(key: "LoadingRefresh", comment: "正在刷新"))
        // color
        self.headerTextColor(.black)

    }
    
    func loadingMore(refreshBlock: @escaping () -> Void) {
        self.gtm_addLoadMoreFooterView(loadMoreBlock: refreshBlock)
        self.pullUpToRefreshText(LS(key: "PullToLoadingMore", comment: "上拉加载更多"))
            .releaseLoadMoreText(LS(key: "ReleaseToLoadingMore", comment: "松开加载"))
            .noMoreDataText(LS(key: "NoMoreData", comment: "没有更多数据"))
            .loaddingText(LS(key: "LoadingMore", comment: "正在加载"))
        // color
        self.headerTextColor(.black)
    }
}

