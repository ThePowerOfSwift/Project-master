//
//  HERefreshHeaderAnimator.swift
//  Project
//
//  Created by fumubang on 2018/4/15.
//  Copyright © 2018年 com.weixhe. All rights reserved.
//

import Foundation
import UIKit
import GTMRefresh

//import ESPullToRefresh

//// MARK: - 下拉刷新
//class HERefreshHeaderAnimator: ESRefreshHeaderAnimator {
//    public override init(frame: CGRect) {
//        super.init(frame: frame)
//        pullToRefreshDescription = LS(key: "PullToRefresh", comment: "下拉刷新")
//        releaseToRefreshDescription = LS(key: "ReleaseToRefresh", comment: "松开刷新")
//        loadingDescription = LS(key: "LoadingRefresh", comment: "正在刷新")
//    }
//
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//// MARK: - 上拉加载
//class HERefreshFooterAnimator: ESRefreshFooterAnimator {
//
//    public override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        loadingMoreDescription = LS(key: "PullToLoadingMore", comment: "上拉加载更多")
//        noMoreDataDescription = LS(key: "NoMoreData", comment: "没有更多数据")
//        loadingDescription = LS(key: "LoadingMore", comment: "正在加载")
//    }
//
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}

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

//// MARK: - 扩展CollectionView
//extension UICollectionView {
//    func pullToRefresh(handler: @escaping ESRefreshHandler) {
//        self.es.addPullToRefresh(animator: HERefreshHeaderAnimator(), handler: handler)
//    }
//
//    func infiniteScrolling(handler: @escaping ESRefreshHandler) {
//        self.es.addInfiniteScrolling(animator: HERefreshFooterAnimator(), handler: handler)
//    }
//}

