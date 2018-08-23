//
//  CVBaseViewController.swift
//  Project
//
//  Created by caven on 2018/3/6.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit

class CVBaseViewController: UIViewController {
    
    override var cv_leftBarButtonItem: CVBarButtonItem? {
        didSet {
            if self.cv_leftBarButtonItem != nil {
                self.cv_navigationBar?.leftBarButtonItem = self.cv_leftBarButtonItem
            }
        }
    }

    override var title: String? {
        set {
            self.cv_navigationBar?.title = newValue
        }
        get {
            return self.cv_navigationBar?.title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.setNavigationBar()
        self.layoutNavigationItem()
        
        if #available(iOS 11.0, *) {
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.bringNavBarFront()
    }
    
    /* 开启屏幕旋转 */
    override var shouldAutorotate: Bool {
        return false
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .landscapeLeft, .landscapeRight]
    }
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: 导航栏 Nav
    private func setNavigationBar() {
        self.cv_navigationBar = CVNavigationBar(frame: CGRect(x: 0.0, y: 0.0, width: SCREEN_WIDTH, height: cv_safeNavBarHeight))
        self.view.addSubview(self.cv_navigationBar!)
        // self.navigationBar.isShadowHidden = false
        self.cv_navigationBar?.isBottomLineHidden = false
        self.cv_navigationBar?.margin = 0
        
        if self.navigationController?.viewControllers.count == 1 {
            self.cv_leftBarButtonItem = nil
        } else {
            self.cv_leftBarButtonItem = CVBarButtonItem.item(image: UIImageNamed("back_black"), target: self, action: #selector(backToPrevious))
        }
    }
    
    public func bringNavBarFront() {
        if let nav = self.cv_navigationBar {
            self.view.bringSubview(toFront: nav)            
        }
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


