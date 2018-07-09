//
//  AppStoreReview.swift
//  Project
//
//  Created by caven on 2018/3/7.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import Foundation
import StoreKit



let runIncrementerSetting = "numberOfRuns"  // 用于存储运行次数的 UserDefauls 字典键
let minimumRunCount = 15 // 询问评分的最少运行次数

func showAppStoreReview() -> Void {
    let runs = getRunCounts()
    if (runs % minimumRunCount == 0) {
        if #available(iOS 10.3, *) {
            CVLog("已请求评分")
            SKStoreReviewController.requestReview()
        } else {
            let open_review = "itms-apps://itunes.apple.com/app/id\(CVConstans.app_id)?action=write-review";
            if let url = URL(string: open_review) {
                UIApplication.shared.openURL(url)
            }
        }
    }
}

/// app 运行次数计数器。可以在 App Delegate 中调用此方法
func statisticsAppRuns(showReview: Bool) {
    let runs = getRunCounts() + 1
    COM.setValue(runs, forKey: runIncrementerSetting)
    
    if showReview {
        showAppStoreReview()
    }
}

/// 从 UserDefaults 里读取运行次数并返回。
private func getRunCounts() -> Int {
    let savedRuns = COM.value(forKey: runIncrementerSetting)
    var runs = 0
    if savedRuns != nil {
        runs = savedRuns as! Int
    }
    if runs > minimumRunCount * 9999 {
        runs = 0
    }
    return runs
}
