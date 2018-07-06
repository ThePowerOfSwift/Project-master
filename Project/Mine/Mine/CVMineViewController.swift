//
//  CVMineViewController.swift
//  Project
//
//  Created by caven on 2018/3/15.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit

class CVMineViewController: CVBaseViewController {

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
        self.cv_navigationBar!.rightBarButtonItem = CVBarButtonItem.item(title: LS(self, key: "Setting", comment: "设置"), target: self, action: #selector(settingAction))
    }
    
    @objc func settingAction() {
        
        let settingVC = CVSettingViewController()
        self.navigationController!.pushViewController(settingVC, animated: true)
    }

}
