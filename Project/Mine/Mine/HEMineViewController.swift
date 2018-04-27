//
//  HEMineViewController.swift
//  Project
//
//  Created by weixhe on 2018/3/15.
//  Copyright © 2018年 com.weixhe. All rights reserved.
//

import UIKit

class HEMineViewController: HEBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = LS(self, key: "Title", comment: "我的")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: Navigation
    override func layoutNavigationItem() {
        self.navigationBar!.rightBarButtonItem = HEBarButtonItem.item(title: LS(self, key: "Setting", comment: "设置"), target: self, action: #selector(settingAction))
    }
    
    @objc func settingAction() {
        
        let settingVC = HESettingViewController()
        self.navigationController!.pushViewController(settingVC, animated: true)
    }

}
