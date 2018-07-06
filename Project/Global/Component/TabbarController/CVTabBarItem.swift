//
//  CVTabBarItem.swift
//  Project
//
//  Created by caven on 2018/7/4.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit

typealias ClosureOnClickItem = ((_ tabBarItem: CVTabBarItem) -> Void)?

class CVTabBarItem: UIView {
    
    public var isSelected: Bool = false {
        didSet {
            self.updateSelectedState()
        }
    }
    
    public var maxBadge: Int = 99 {  // 设置最大的角标数，如果大于该数字，则显示xx+
        willSet {
            self.badgeView.maxBadge = newValue
        }
    }
    public var badge: Int = 0 {
        willSet {
            self.badgeView.isHidden = false
            if newValue > 0 {
                self.badgeView.badge = newValue
                self.badgeView.center = CGPointMake(self.cv_width / 2 + 15, self.cv_height / 2 - 10)

            } else if newValue == 0 {
                self.badgeView.frame = CGRectMake(0, 0, 6, 6)
                self.badgeView.center = CGPointMake(self.cv_width / 2 + 15, self.cv_height / 2 - 10)
            } else {
                self.badgeView.isHidden = true
            }
        }
    }
    
    public var index: Int = 0   // 对应的controller所在的位置
    public var activity: Bool = false  // 使的item变成活跃的，即和普通的item不同，不直接显示tabBarController中的控制器
    public var activityIdentify: String = ""
    
    public var imageHump: Bool = false {        // image 凸起、上边超出tabbar范围
        didSet {
            if self.imageHump {
                self.imageView.contentMode = .bottom
                self.imageView.clipsToBounds = false
            } else {
                self.imageView.contentMode = .center
                self.imageView.clipsToBounds = true
            }
        }
    }
    
    public var clickActivity: ClosureOnClickItem
    public var clickItem: ClosureOnClickItem
    
    override var frame: CGRect {
        didSet {
            self.updateFrame()
        }
    }
    
    private var titleN: String?
    private var titleH: String?
    private var titleColorN: UIColor?
    private var titleColorH: UIColor?
    private var titleFontN: UIFont = UIFont.font_11
    private var titleFontH: UIFont = UIFont.font_11
    private var imageN: UIImage?
    private var imageH: UIImage?
    
    private var button: UIButton!
    private var imageView: UIImageView!
    private var titleLabel: UILabel!
    private var badgeView: CVBadgeView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.setup()
        self.updateSelectedState()     // 默认未选中
        self.badgeView.isHidden = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
        self.isSelected = false     // 默认未选中
        self.badgeView.isHidden = true
    }
    
    // MARK: - Public Method
    public func setImage(_ image: UIImage?, title: String?, titleColor: UIColor?, titleFont: UIFont = UIFont.font_11) {
        self.imageN = image
        self.imageH = self.imageH ?? image
        self.titleN = title
        self.titleH = self.titleH ?? title
        self.titleColorN = titleColor
        self.titleColorH = self.titleColorH ?? titleColor
        self.titleFontN = titleFont
    }
    
    public func setImageH(_ imageH: UIImage?, titleH: String?, titleColorH: UIColor?, titleFontH: UIFont = UIFont.font_11) {
        self.imageH = imageH
        self.imageN = self.imageN ?? imageH
        self.titleH = titleH
        self.titleN = self.titleN ?? titleH
        self.titleColorH = titleColorH
        self.titleColorN = self.titleColorN ?? titleColorH
        self.titleFontH = titleFontH
    }
    
    
    // MARK: - Private Method
    private func setup() {
        self.button = cv_button(bg: UIColor.clear, image: nil, super: self)
        self.button.frame = self.bounds
        self.button.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleRightMargin]
        self.button.addTarget(self, action: #selector(onClickAction(_:)), for: .touchUpInside)
        
        self.imageView = cv_imageView(image: nil, super: self)
        imageView.contentMode = .center

        self.titleLabel = cv_label(font: self.titleFontN, text: nil, super: self)
        self.titleLabel.textAlignment = .center

        self.badgeView = CVBadgeView(frame: CGRectMake(0, 0, 15, 15))
        self.badgeView.maxBadge = self.maxBadge
        self.addSubview(self.badgeView)
    }
    
    private func handleData() {
        if self.imageN != nil && self.imageH == nil {
            self.imageH = self.imageN
        }
    }
    
    /// 更新frame
    private func updateFrame() {
        if self.button != nil {
            if self.imageN != nil && self.titleN != nil {
                self.imageView.frame = CGRectMake(0, 5, self.cv_width, self.cv_height * 0.5)
                self.titleLabel.frame = CGRectMake(0, self.imageView.cv_bottom, self.cv_width, self.cv_height * 0.4)
            } else if self.imageN != nil {
                self.imageView.frame = self.bounds
            } else if self.titleN != nil {
                self.titleLabel.frame = self.bounds
            }
            
            self.button.frame = self.bounds
            self.badgeView.cv_right(15).cv_top(5)
        }
    }
    
    /// 更新选中状态
    private func updateSelectedState() {
        self.button.isSelected = self.isSelected
        if self.isSelected {   // 选中状态
            self.titleLabel.text = self.titleH
            self.titleLabel.textColor = self.titleColorH
            self.titleLabel.font = self.titleFontH
            if self.imageH != nil && self.imageH!.size.width > self.cv_width {
                let image = self.imageH!.scaleImage(scale: self.cv_width / self.imageH!.size.width)
                self.imageView.image = image
            } else {
                self.imageView.image = self.imageH
            }
            
        } else {  // 未选中
            self.titleLabel.text = self.titleN
            self.titleLabel.textColor = self.titleColorN
            self.titleLabel.font = self.titleFontN
            if self.imageN != nil && self.imageN!.size.width > self.cv_width {
                let image = self.imageN!.scaleImage(scale: self.cv_width / self.imageH!.size.width)
                self.imageView.image = image
            } else {
                self.imageView.image = self.imageN
            }
        }
    }
    
    // MARK: - Actions
    @objc private func onClickAction(_ button: UIButton) {
        if self.activity {
            if self.clickActivity != nil {
                self.clickActivity!(self)
            }
        } else {
            if self.clickItem != nil {
                self.clickItem!(self)
            }
        }
    }
}
