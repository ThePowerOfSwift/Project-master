//
//  CVBaseViewController.swift
//  Project
//
//  Created by caven on 2018/3/6.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit

class CVBaseViewController: UIViewController {

    var thisViewHeight: CGFloat {
        get {
            var top: CGFloat = 0.0, bottom: CGFloat = 0.0
            if self.navigationBar != nil && self.navigationBar!.isHidden == false {
                top = cv_navigation_height()
            } else {
                top = cv_safeAreaInsetsIn(view: self.view).top
            }
            if self.tabBarController != nil && self.tabBarController!.tabBar.isHidden == false {
                bottom = self.tabBarController!.tabBar.frame.height
            }
            bottom += cv_safeAreaInsetsIn(view: self.view).bottom
            
            return SCREEN_HEIGHT - top - bottom
        }
    }
    
    var navigationBar: CVNavigationBar?
    var leftBarButtonItem: CVBarButtonItem? {
        didSet {
            if self.leftBarButtonItem != nil { self.navigationBar?.leftBarButtonItem = self.leftBarButtonItem }
        }
    }

    override var title: String? {
        didSet {
            self.navigationBar?.title = self.title;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.setNavigationBar()
        self.layoutNavigationItem()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.bringNavBarFront()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.bringNavBarFront()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: 导航栏 Nav
    private func setNavigationBar() {
        if self.navigationController != nil {
            self.navigationBar = CVNavigationBar(frame: CGRect(x: 0.0, y: 0.0, width: SCREEN_WIDTH, height: cv_navigation_height()))
            self.view.addSubview(self.navigationBar!)
            // self.navigationBar!.isShadowHidden = false
            self.navigationBar!.isBottomLineHidden = false
            self.navigationBar!.margin = 5
        }
        
        if self.navigationController?.viewControllers.count == 1 {
            self.leftBarButtonItem = nil
        } else {
            self.leftBarButtonItem = CVBarButtonItem.item(image: UIImageNamed("back_black"), target: self, action: #selector(backToPrevious))
        }
    }
    
    public func bringNavBarFront() {
        if let view = self.navigationBar {
            self.view.bringSubview(toFront: view)
        }
    }
    
    public func layoutNavigationItem() {
        
    }
    
    @objc func backToPrevious() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: tabBar
}


