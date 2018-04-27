//
//  HECustomTitleView.swift
//  Project
//
//  Created by weixhe on 2018/3/7.
//  Copyright © 2018年 com.weixhe. All rights reserved.
//

import Foundation
import UIKit

// MARK: - 1. 类：主标题+副标题
open class HESubTitleView: UIView {
    
    var title: String? {
        didSet {
            if let text = self.title, let label = self.titleLabel {
                label.text = text
                self.updateFrame()
            }
        }
    }
    var subtitle: String? {
        didSet {
            if let text = self.subtitle, let label = self.subtitleLabel {
                label.text = text
                self.updateFrame()
            }
        }
    }
    
    var titleFont: UIFont = UIFont.systemFont(ofSize: 15) {
        didSet {
            if let label = self.titleLabel {
                label.font = self.titleFont
                self.updateFrame()
            }
        }
    }
    var subtitleFont: UIFont = UIFont.systemFont(ofSize: 12) {
        didSet {
            if let label = self.subtitleLabel {
                label.font = self.subtitleFont
                self.updateFrame()
            }
        }
    }
    
    var titleColor: UIColor = UIColor.black {
        didSet {
            if let label = self.titleLabel {
                label.textColor = self.titleColor
            }
        }
    }
    var subtitleColor: UIColor = UIColor.black {
        didSet {
            if let label = self.subtitleLabel {
                label.textColor = self.subtitleColor
            }
        }
    }
    
    var scale: CGFloat = 0.6 {
        didSet {
            scale = max(min(scale, 1), 0)
            self.updateFrame()
        }
    }
    
    var padding: CGFloat = 0.0 {    // 标题距离上下的距离
        didSet {
            self.updateFrame()
        }
    }
    
    var space: CGFloat = 0.0 {   // 主副标题之间的距离
        didSet {
            self.updateFrame()
        }
    }
    
    private var titleLabel: UILabel?
    private var subtitleLabel: UILabel?
    lazy private var button: UIButton = {
        let button = UIButton(type: .custom)
        button.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        button.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.addSubview(button)
        return button
    }()
    
    // MARK: Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    convenience public init(title: String, subTitle: String) {
        self.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: kDefaultBarHeight))
        /*
         注：在初始化的时候赋值，是不调用didSet方法的。
         解决方案: 可以采用KVC方式给对象初始化,通过KVC方法赋值后,必须添加setValueforUndefinedKey方法做特殊处理,否则运行到KVC方法时程序会报错
         */
        self.setValue(title, forKey: "title")
        self.setValue(subTitle, forKey: "subtitle")
        self.updateFrame()
    }
    
    // 调用KVC的方法key值错误后调用
    open override func setValue(_ value: Any?, forKey key: String) {
        // 重新使用value赋值给str属性就可以成功调用didSet方法
        if key == "title", let newValue = value {
            self.title = newValue as? String
        } else if key == "subtitle", let newValue = value {
            self.subtitle = newValue as? String
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.updateFrame()
    }
    
    // MARK: Setup
    private func setup() -> Void {
        self.titleLabel = UILabel()
        self.titleLabel!.textAlignment = .center
        self.titleLabel!.font = self.titleFont
        self.titleLabel!.textColor = UIColor.black
        self.titleLabel!.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
        self.addSubview(self.titleLabel!)
        
        self.subtitleLabel = UILabel()
        self.subtitleLabel!.textAlignment = .center
        self.subtitleLabel!.font = self.subtitleFont
        self.subtitleLabel!.textColor = UIColor.black
        self.subtitleLabel!.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
        self.addSubview(self.subtitleLabel!)
    }
    
    
    private func updateFrame() -> Void {
        if let title: String = self.title, let subtitle = self.subtitle {
            
            let width = max(title.autoWidth(font: self.titleFont, fixedHeight: kDefaultBarHeight * scale),
                            subtitle.autoWidth(font: self.subtitleFont, fixedHeight: kDefaultBarHeight * (1 - scale)))
            
            self.frame = CGRect(x: 0, y: 0, width: width, height: kDefaultBarHeight)
            self.titleLabel!.frame = CGRect(x: 0, y: padding, width: width, height: kDefaultBarHeight * scale);
            self.subtitleLabel!.frame = CGRect(x: 0, y: self.titleLabel!.frame.maxY + self.space, width: width, height: kDefaultBarHeight * (1 - scale));
            if self.superview != nil {
                self.center = CGPoint(x: self.superview!.frame.width / 2, y: kDefaultBarCenterY)
            } else {
                self.center = CGPoint(x: SCREEN_WIDTH / 2, y: kDefaultBarCenterY)
            }
        }
    }
    
    public func add(target: Any?, action: Selector) -> Void {
        self.button.addTarget(target, action: action, for: .touchUpInside)
    }
}

// MARK: - 2. 类：图标+标题
open class HEIconTitleView: UIView {
    
    enum ImageStyle {
        case left       // 图片位于左侧
        case right      // 图片位于右侧
        case full       // 图片充满整个titleView视图
    }
    
    var title: String? {
        didSet {
            if let text = self.title, let label = self.titleLabel {
                label.text = text
                self.updateFrame()
            }
        }
    }
    var icon: UIImage? {
        didSet {
            if let icon = self.icon, let imageV = self.imageView {
                imageV.image = icon
                self.updateFrame()
            }
        }
    }
    
    var titleFont: UIFont = UIFont.systemFont(ofSize: 15) {
        didSet {
            if let label = self.titleLabel {
                label.font = self.titleFont
                self.updateFrame()
            }
        }
    }
    
    var titleColor: UIColor = UIColor.black {
        didSet {
            if let label = self.titleLabel {
                label.textColor = self.titleColor
            }
        }
    }
    
    var iconStyle: ImageStyle = .left {
        didSet {
            if self.iconStyle == .full, let label = self.titleLabel {
                label.isHidden = true
            }
            self.updateFrame()
        }
    }
    
    var iconWidth: CGFloat? {
        didSet {
            self.updateFrame()
        }
    }
    
    var iconHeight: CGFloat? {
        didSet {
            self.updateFrame()
        }
    }
    
    var space: CGFloat = 0.0 {   // icon 和 title 之间的距离，当 iconStyle = [.left, .right] 时有效
        didSet {
            self.updateFrame()
        }
    }
    
    private var titleLabel: UILabel?
    private var imageView: UIImageView?
    lazy private var button: UIButton = {
        let button = UIButton(type: .custom)
        button.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        button.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.addSubview(button)
        return button
    }()
    
    // MARK: Init
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    convenience public init(title: String? = "", icon: UIImage, iconWidth: CGFloat? = 15, iconHeight: CGFloat? = 15) {
        self.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: kDefaultBarHeight))
        /*
         注：在初始化的时候赋值，是不调用didSet方法的。
         解决方案: 可以采用KVC方式给对象初始化,通过KVC方法赋值后,必须添加setValueforUndefinedKey方法做特殊处理,否则运行到KVC方法时程序会报错
         */
        self.setValue(title, forKey: "title")
        self.setValue(icon, forKey: "icon")
        self.setValue(iconWidth, forKey: "iconWidth")
        self.setValue(iconHeight, forKey: "iconHeight")
        self.updateFrame()
    }
    
    // 调用KVC的方法key值错误后调用
    open override func setValue(_ value: Any?, forKey key: String) {
        // 重新使用value赋值给str属性就可以成功调用didSet方法
        if key == "title", let newValue = value {
            self.title = newValue as? String
        } else if key == "icon", let newValue = value {
            self.icon = newValue as? UIImage
        } else if key == "iconWidth", let newValue = value {
            self.iconWidth = newValue as? CGFloat
        } else if key == "iconHeight", let newValue = value {
            self.iconHeight = newValue as? CGFloat
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.updateFrame()
    }
    
    
    // MARK: Setup
    private func setup() -> Void {
        self.titleLabel = UILabel()
        self.titleLabel!.textAlignment = .center
        self.titleLabel!.font = self.titleFont
        self.titleLabel!.textColor = UIColor.black
        self.titleLabel!.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
        self.addSubview(self.titleLabel!)
        
        self.imageView = UIImageView()
        self.imageView!.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
        self.imageView!.contentMode = .scaleToFill //.scaleAspectFill
        self.addSubview(self.imageView!)
    }
    
    private func updateFrame() -> Void {
        if let icon = self.icon {
            switch self.iconStyle {
            case .left:
                self.moveIcon(to: HEIconTitleView.ImageStyle.left)
            case .right:
                self.moveIcon(to: HEIconTitleView.ImageStyle.right)
            default:        // full
                let standard: CGFloat = min(kDefaultBarHeight, icon.size.height)  // 高度的标准对比值
                let wtoh: CGFloat = icon.size.width / icon.size.height  // 宽高比
                self.frame = CGRect(x: 0, y: 0, width: wtoh * standard, height: standard)
                
                var width: CGFloat = icon.size.width, height: CGFloat = icon.size.height
                if icon.size.height > standard {
                    width = icon.size.width / icon.size.height * standard
                    height = standard
                }
                
                self.imageView!.frame = CGRect(x: 0, y: 0, width: width, height: height)
                self.imageView!.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
            }
            if self.superview != nil {
                self.center = CGPoint(x: self.superview!.frame.width / 2, y: kDefaultBarCenterY)
            } else {
                self.center = CGPoint(x: SCREEN_WIDTH / 2, y: kDefaultBarCenterY)
            }
        }
    }
    
    private func moveIcon(to: ImageStyle) -> Void {
        var titleWidth: CGFloat = 0.0
        if let text = self.title {
            titleWidth = text.autoWidth(font: self.titleFont, fixedHeight: kDefaultBarHeight)
        }
        
        var iconW: CGFloat = 15, iconH: CGFloat = 15
        if let w = self.iconWidth { iconW = w }
        if let h = self.iconHeight { iconH = h }
        let iconX = to == .left ? 0 : titleWidth + self.space
        let titleX = to == .left ? iconW + self.space : 0
        self.imageView!.frame = CGRect(x: iconX, y: 0, width: iconW, height: iconH)
        self.imageView!.center = CGPoint(x: self.imageView!.center.x, y: self.frame.height / 2)
        self.titleLabel!.frame = CGRect(x: titleX, y: 0, width: titleWidth, height: kDefaultBarHeight)
        self.frame = CGRect(x: 0, y: 0, width: iconW + self.space + titleWidth, height: kDefaultBarHeight)
    }
    
    public func add(target: Any?, action: Selector) -> Void {
        self.button.addTarget(target, action: action, for: .touchUpInside)
    }
    
    // 动画
    public func animationForRotate() -> Void {
        
        // 方法一：
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = Double.pi
        animation.duration = 0.3
        animation.isRemovedOnCompletion = true
        self.imageView!.layer.add(animation, forKey: nil)
        // 方法二：
//        UIView.animate(withDuration: 0.3) {
//            self.imageView!.transform = self.imageView!.transform.rotated(by: CGFloat(Double.pi))
//        }
    }
}
