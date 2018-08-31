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
        
        let label = cv_label(font: UIFont.font_10, text: "asdfasdfadsf", super: self.view)
        label.frame = CGRectMake(0, 100, 80, 30)
        label.backgroundColor = UIColor.red
        
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
        driveScreen(to: .landscapeRight)
//        let settingVC = CVSettingViewController()
//        self.navigationController!.pushViewController(settingVC, animated: true)
    }
    
    
    private func driveScreen(to direction: UIInterfaceOrientation) {
        UIDevice.current.setValue(direction.rawValue, forKey: "orientation")
    }

}
