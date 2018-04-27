//
//  AppStoreReview.swift
//  Project
//
//  Created by weixhe on 2018/3/7.
//  Copyright © 2018年 com.weixhe. All rights reserved.
//

import Foundation
import StoreKit



let runIncrementerSetting = "numberOfRuns"  // 用于存储运行次数的 UserDefauls 字典键
let minimumRunCount = 15 // 询问评分的最少运行次数

func showAppStoreReview() -> Void {
    let runs = getRunCounts()
    if (runs % minimumRunCount == 0) {
        if #available(iOS 10.3, *) {
            HELog(message: "已请求评分")
            SKStoreReviewController.requestReview()
        } else {
            let open_review = "itms-apps://itunes.apple.com/app/id\(HEConstans.app_id)?action=write-review";
            if let url = URL(string: open_review) {
                UIApplication.shared.openURL(url)
            }
        }
    }
}

/// app 运行次数计数器。可以在 App Delegate 中调用此方法
func incrementAppRuns() {
    let runs = getRunCounts() + 1
    UserDefaults.standard.setValue(runs, forKey: runIncrementerSetting)
    UserDefaults.standard.synchronize()
}

/// 从 UserDefaults 里读取运行次数并返回。
private func getRunCounts() -> Int {
    let savedRuns = UserDefaults.standard.value(forKey: runIncrementerSetting)
    var runs = 0
    if savedRuns != nil {
        runs = savedRuns as! Int
    }
    return runs
}
