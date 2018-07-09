//
//  CVBaseViewController.swift
//  Project
//
//  Created by caven on 2018/3/6.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit

class CVBaseViewController: UIViewController {
    
    private var _interactiveTransition: UIPercentDrivenInteractiveTransition?
    
    var thisViewHeight: CGFloat {
        get {
            var navBarHeight: CGFloat = 0.0, tabBarHeight: CGFloat = 0.0
            if self.cv_navigationBar.isHidden == false {
                navBarHeight = 44
            }
            if self.tabBarController != nil {
                let baseTabBarController = (self.tabBarController! as! CVBaseTabbarController)
                if baseTabBarController.cv_tabbar.isHidden == false {
                    tabBarHeight = 49
                }
            }
            return cv_safeScreenHeight - navBarHeight - tabBarHeight
        }
    }
    
    /// nav
    var cv_navigationBar: CVNavigationBar!
    var leftBarButtonItem: CVBarButtonItem? {
        didSet {
            if self.leftBarButtonItem != nil {
                self.cv_navigationBar.margin = -5
                self.cv_navigationBar.leftBarButtonItem = self.leftBarButtonItem
                
            }
        }
    }
    

    override var title: String? {
        didSet {
            self.cv_navigationBar?.title = self.title
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
        
        if let nav = self.navigationController {
            if nav as? CVNavigationController != nil {
                self.cv_navigationController = nav as? CVNavigationController
            }
            
            if nav.viewControllers.count == 2 { // push
                if let tabVC = cv_AppDelegate.cv_tabBarController {
                    tabVC.hiddenTabBar(animation: true)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.bringNavBarFront()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    /*
        push时，先掉 willMove， 再调 didMove， 此时 parent 都不为空
        pop时， 先掉 willMove， 再调 didMove， 此时 parent 都为空
        手势侧滑时，先掉 willMove，parent为空，--如果最后返回了，则掉didMove，此时parent为空；--如果没有返回，还在此页面，则didMove不调用
        总结：当确实返回了上一页，才走didMove方法，否则不走此方法，当此方法中parent为空时对应pop，不为空时对应push
     */
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)

    }

    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        if parent != nil {  // push

        } else { // pop
            
            if let navCon = self.cv_navigationController {
                if navCon.viewControllers.count == 1 {
                    if let tabVC = cv_AppDelegate.cv_tabBarController {
                        tabVC.showTabBar(animation: true)
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: 导航栏 Nav
    private func setNavigationBar() {
        self.cv_navigationBar = CVNavigationBar(frame: CGRect(x: 0.0, y: 0.0, width: SCREEN_WIDTH, height: cv_safeNavBarHeight))
        self.view.addSubview(self.cv_navigationBar!)
        // self.navigationBar.isShadowHidden = false
        self.cv_navigationBar.isBottomLineHidden = false
        self.cv_navigationBar.margin = 5
        
        if self.navigationController?.viewControllers.count == 1 {
            self.leftBarButtonItem = nil
        } else {
            self.leftBarButtonItem = CVBarButtonItem.item(image: UIImageNamed("back_black"), target: self, action: #selector(backToPrevious))
        }
    }
    
    public func bringNavBarFront() {
        self.view.bringSubview(toFront: self.cv_navigationBar)
    }
    
    public func layoutNavigationItem() {
        
    }
    
    @objc func backToPrevious() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - deInit
    deinit {
        self.cv_navigationController = nil
    }
    
}


