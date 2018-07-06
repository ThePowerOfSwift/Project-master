//
//  CVTabBar.swift
//  Project
//
//  Created by caven on 2018/4/14.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import Foundation
import UIKit

private let height_bar: CGFloat = 49

class CVTabBar: UIView {
    var backgroundImage: UIImage? {   // 设置背景图片
        willSet {
            self.backgroundImageView.image = newValue
            self.backgroundImageView.isHidden = false
        }
    }
    
    var hidenLine: Bool = false {    // 是否隐藏line
        willSet {
            self.line.isHidden = newValue
        }
    }
    
    var hidenShadow: Bool = true {  // 是否隐藏阴影
        willSet {
            if newValue {
                self.hiddenShadow()
            } else {
                self.shadow(radius: 3, offset: CGSizeMake(0, -1))
            }
        }
    }
    
    
    private var line: UIView!
    private var backgroundImageView: UIImageView!
    
    override init(frame: CGRect) {
        let height = height_bar + cv_safeAreaInsets.bottom
        super.init(frame: CGRectMake(0, SCREEN_HEIGHT - height, SCREEN_WIDTH, height))
        self.backgroundColor = UIColor.white
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    // MARK: - Private Method
    private func setup() {
        // 背景图片
        self.backgroundImageView = cv_imageView(image: nil, super: self)
        self.backgroundImageView.frame = self.bounds
        self.backgroundImageView.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleRightMargin]
        
        // 上线的分割线
        self.line = cv_view(frame: CGRectMake(0, 0, SCREEN_WIDTH, 1), color: UIColor.colorWithRGB(218, green: 218, blue: 218), super: self)
    }
}


