//
//  CVHUD.swift
//  Project
//
//  Created by caven on 2018/7/12.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit

class CVHUD: NSObject {
    
    // MARK: - 全屏的HUD
    class func showFullScreenHUD(message: String) {
        
        guard let view = UIApplication.shared.windows.last else { return }
        // 创建 HUD
        let hud: CVProgressHUD = CVProgressHUD.showMessageHUD(addTo: view)
        
        // 设置 HUD 的属性
        hud.detailText = message
        hud.mainViewColor = UIColor.clear
        hud.backgroundViewColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
    }
    
    // MARK: - 等待的HUD
    class func showWaittingHUD(message: String, superClickable: Bool = false) {
        
        self.showWaittingHUD(message: message, onView: nil)
    }
    
    class func showWaittingHUD(message: String, onView: UIView?, superClickable: Bool = false) {
        
        // 获取需要添加 HUD 的 View
        var tempView = onView
        if tempView == nil {
            tempView = UIApplication.shared.windows.last
        }
        guard let view = tempView else { return }
        // 创建 HUD
        let hud: CVProgressHUD = CVProgressHUD.showMessageHUD(addTo: view)
        // 设置 HUD 的属性
        hud.detailText = message
        hud.superViewClickable = superClickable
    }
    
    // MARK: - MessageHUD
    
    class func showMessageHUD(message: String, delay: TimeInterval = 2) {
        self.showMessageHUD(title: "", message: message, onView: nil, delay: delay)
    }
    
    class func showMessageHUD(title: String = "", message: String, onView: UIView?, delay: TimeInterval = 2) {
        
        // 获取需要添加 HUD 的 View
        var tempView = onView
        if tempView == nil {
            tempView = UIApplication.shared.windows.last
        }
        guard let view = tempView else { return }
        // 创建 HUD
        let hud: CVProgressHUD = CVProgressHUD.showMessageHUD(addTo: view)
        // 设置 HUD 的属性
        hud.titleText = title
        hud.detailText = message
        hud.indicatorContainerVisible = false
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: delay)
            DispatchQueue.main.async {
                if onView == nil {
                    CVHUD.hideHUD()
                } else {
                    CVHUD.hideHUD(fromView: onView!)                    
                }
            }
        }
    }
    
    // MARK: - TipsHUD
    /// 警告
    class func showWarningHUD(message: String, delay: TimeInterval = 2) {
        self.showImageHUD(message: message, image: getImage("Warning"), onView: nil, delay: delay)
    }
    
    class func showWarningHUD(message: String, onView: UIView?, delay: TimeInterval = 2) {
        self.showImageHUD(message: message, image: getImage("Warning"), onView: onView, delay: delay)
    }
    
    /// 错误
    class func showErrorHUD(message: String, delay: TimeInterval = 2) {
        self.showImageHUD(message: message, image: getImage("Error"), onView: nil, delay: delay)
    }
    
    class func showErrorHUD(message: String, onView: UIView?, delay: TimeInterval = 2) {
        self.showImageHUD(message: message, image: getImage("Error"), onView: onView, delay: delay)
    }
    
    /// 正确
    class func showSucceedHUD(message: String, delay: TimeInterval = 2) {
        self.showImageHUD(message: message, image: getImage("Checkmark"), onView: nil, delay: delay)
    }
    
    class func showSucceedHUD(message: String ,onView: UIView?, delay: TimeInterval = 2) {
        self.showImageHUD(message: message, image: getImage("Checkmark"), onView: onView, delay: delay)
    }
    
    class func showImageHUD(message: String, image: UIImage, onView: UIView?, delay: TimeInterval = 2) {
        
        // 获取需要添加 HUD 的 View
        var tempView = onView
        if tempView == nil {
            tempView = UIApplication.shared.windows.last
        }
        guard let view = tempView else { return }
        // 创建 HUD
        let hud = CVProgressHUD.showMessageHUD(addTo: view)
        let img = image.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: img)
        hud.customIndicatorView = imageView
        hud.detailText = message
        
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: delay)
            DispatchQueue.main.async {
                
                if onView == nil{
                    CVHUD.hideHUD()
                } else {
                    CVHUD.hideHUD(fromView: onView!)
                }
            }
        }
    }
    
    // MARK: - HUD 的隐藏方法
    class func hideHUD() {
        hideHUD(fromView: nil)
    }
    
    class func hideHUD(fromView view: UIView?) {
        var tempView = view
        if tempView == nil {
            tempView = UIApplication.shared.windows.last
        }
        guard let view = tempView else { return }
        CVProgressHUD.hideHUD(forView: view, animated: true)
    }
}

fileprivate func getImage(_ imageName: String) -> UIImage {
    let selfBundle = Bundle(path: Bundle.main.path(forResource: "CVHUD", ofType: "bundle")!)
    let imagePath = selfBundle!.path(forResource: imageName, ofType: "png")!
    return UIImage(contentsOfFile: imagePath)!
}
