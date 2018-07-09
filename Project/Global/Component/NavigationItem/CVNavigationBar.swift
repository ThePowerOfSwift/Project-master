//
//  CVNavigationBar.swift
//  Project
//
//  Created by caven on 2018/3/6.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit

private let kDefaultTitleSize: CGFloat = 17.0
private let kDefaultTitleColor: UIColor = UIColor.black
private let kDefaultBackgroundColor: UIColor = UIColor.white
public  let kDefaultBarHeight: CGFloat = 44.0
private let kDefaultBarTop: CGFloat = UIApplication.shared.statusBarFrame.height
public  let kDefaultBarCenterY: CGFloat = kDefaultBarHeight / 2 + kDefaultBarTop

open class CVNavigationBar: UIView {
    // background 相关属性
    open var backgoundImage: UIImage? {
        didSet {
            self.backgoundImageView.image = self.backgoundImage
            self.backgoundImageView.isHidden = false
            self.backgoundView.isHidden = true
        }
    }
    
    open override var backgroundColor: UIColor? {
        didSet {
            self.backgoundView.backgroundColor = self.backgroundColor
            self.backgoundImageView.isHidden = true
            self.backgoundView.isHidden = false
        }
    }
    
    open var backgroundAlpha: CGFloat = 1.0 {
        didSet {
            self.backgroundAlpha = max(0, min(1, self.backgroundAlpha))
            self.backgoundView.alpha = self.backgroundAlpha
            self.backgoundImageView.alpha = self.backgroundAlpha
            self.bottomLine.alpha = self.backgroundAlpha
        }
    }
    
    // barTintColor 代替tintColor
    open var barTintColor: UIColor? {
        didSet {
            self.titleLabel.textColor = textColor()
        }
    }
    
    open var isBottomLineHidden: Bool? {
        didSet {
            self.bottomLine.isHidden = self.isBottomLineHidden!
        }
    }
    
    open var isShadowHidden: Bool? {
        didSet {
            if self.isShadowHidden! {
                self.hiddenShadow()
            } else {
                self.shadow(radius: 3, offset: CGSize(width: 0, height: 1))
            }
        }
    }
    
    /// title相关属性
    open var title: String? {
        didSet {
            self.titleLabel.text = self.title
            if let text = self.title, text.count != 0 {
                self.titleLabel.isHidden = false
                if self.titleLabel.superview == nil {
                    self.addSubview(self.titleLabel)
                }
                self.updateFrame()
            }
        }
    }
    open var titleColor: UIColor? {
        didSet {
            self.titleLabel.textColor = self.textColor()
        }
        
    }
    open var titleFont: UIFont = UIFont.systemFont(ofSize: kDefaultTitleSize) {
        didSet {
            self.titleLabel.font = self.titleFont
            self.updateFrame()
        }
    }
    
    open var titleView: UIView? {
        didSet {
            self.titleLabel.text = nil
            self.clearItemBy(inner_key: "titleView")   // 不管是不是nil，直接都清空
            if let view = self.titleView {
                view.inner_key = "titleView"
                self.addSubview(view)
                self.updateFrame()
            }
        }
    }
    
    var margin: CGFloat = 0 {        // 控制item与屏幕边缘的距离
        didSet {
            for view in self.subviews {
                if let key = view.inner_key, key == "leftItem" {
                    view.frame.origin.x += self.margin - oldValue
                } else if let key = view.inner_key, key == "rightItem" {
                    view.frame.origin.x -= self.margin - oldValue
                }
            }
        }
    }
    
    //******单item设置和布局
    var leftBarButtonItem: CVBarButtonItem? {
        willSet {
            self.clearItemBy(inner_key: "leftItem")
            if self.leftBarButtonItem != nil { self.leftBarButtonItem = nil }
        }
        didSet {
            
            if let item = leftBarButtonItem, let view = item.customView {   // 自定义view
                view.inner_key = "leftItem"
                view.frame.origin.x += self.margin
                view.center.y = kDefaultBarTop + kDefaultBarHeight / 2
                self.addSubview(view)
            } else if let item = leftBarButtonItem, let view = item.button {
                view.inner_key = "leftItem"
                view.frame.origin.x = self.margin
                view.setTitleColor(self.textColor(), for: .normal)
                view.center.y = kDefaultBarTop + kDefaultBarHeight / 2
                self.addSubview(view)
            }
        }
    }
    var rightBarButtonItem: CVBarButtonItem? {
        willSet {
            self.clearItemBy(inner_key: "rightItem")
            if self.rightBarButtonItem != nil { self.rightBarButtonItem = nil }
        }
        didSet {
            
            if let item = rightBarButtonItem, let view = item.customView {   // 自定义view
                view.inner_key = "rightItem"
                view.frame.origin.x -= self.margin
                view.center.y = kDefaultBarTop + kDefaultBarHeight / 2
                self.addSubview(view)
            } else if let item = rightBarButtonItem, let view = item.button {
                view.inner_key = "rightItem"
                view.frame.origin.x = self.frame.width - view.frame.width - self.margin
                view.setTitleColor(self.textColor(), for: .normal)
                view.center.y = kDefaultBarTop + kDefaultBarHeight / 2
                self.addSubview(view)
            }
        }
    }
    //******* 多item设置和布局
    var spaceBetweenItems: CGFloat = 0      // 只针对多item有用, 需要提前设置
    var leftBarButtonItems: [CVBarButtonItem]? {
        willSet {
            self.clearItemBy(inner_key: "leftItem")
            if self.leftBarButtonItems != nil { self.leftBarButtonItems = nil }
        }
        didSet {
            guard self.leftBarButtonItems != nil else { return }
            var x = self.margin
            for i in 0 ..< self.leftBarButtonItems!.count {
                let item = self.leftBarButtonItems![i]
                    if let view = item.button {
                    view.inner_key = "leftItem"
                    view.frame.origin.x = x
                    view.setTitleColor(self.textColor(), for: .normal)
                    view.center.y = kDefaultBarTop + kDefaultBarHeight / 2
                    self.addSubview(view)
                    x = view.frame.maxX + self.spaceBetweenItems
                }
            }
        }
    }
    
    var rightBarButtonItems: [CVBarButtonItem]? {
        willSet {
            self.clearItemBy(inner_key: "rightItem")
            if self.rightBarButtonItems != nil { self.rightBarButtonItems = nil }
        }
        didSet {
            guard self.rightBarButtonItems != nil else { return }
            var x = self.frame.width - self.margin
            for i in 0 ..< self.rightBarButtonItems!.count {
                let item = self.rightBarButtonItems![i]
                if let view = item.button {
                    view.inner_key = "rightItem"
                    view.frame.origin.x = x - view.frame.width
                    view.setTitleColor(self.textColor(), for: .normal)
                    view.center.y = kDefaultBarTop + kDefaultBarHeight / 2
                    self.addSubview(view)
                    x = view.frame.minX - self.spaceBetweenItems
                }
            }
        }
    }

    lazy private var backgoundImageView: UIImageView = {
        let imageView = UIImageView(frame: self.bounds)
        imageView.autoresizingMask = [.flexibleWidth]
        self.addSubview(imageView)
        return imageView
    }()
    lazy private var backgoundView: UIView = {
        let view = UIView(frame: self.bounds)
        view.autoresizingMask = [.flexibleWidth]
        self.addSubview(view)
        return view
    }()
    lazy private var bottomLine: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: self.frame.height - 1, width: self.frame.width, height: 1))
        view.backgroundColor = UIColor.colorWithRGB(218, green: 218, blue: 218)
        view.autoresizingMask = [.flexibleWidth]
        self.addSubview(view)
        return view
    }()
    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = self.textColor()
        label.font = self.titleFont
        label.textAlignment = .center
        label.isHidden = true
        label.inner_key = "titleView"
        self.addSubview(label)
        return label
    }()

    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initial()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initial()
    }
    
    /// 初始化一些数据
    func initial() -> Void {
        self.backgroundColor = kDefaultBackgroundColor
        self.autoresizingMask = [.flexibleWidth]
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.updateFrame()
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
    // MARK: Private Method
    private func textColor() -> UIColor {
        // 优先级：1-titleLabelColor，2-barTintColor，3-kDefaultTitleColor
        if let color = self.titleColor {
            return color;
        } else if let color = self.barTintColor {
            return color;
        }
        return kDefaultTitleColor;
    }
    
    private func updateFrame() -> Void {
        if let text = self.titleLabel.text, text.count > 0 {
            let width = text.autoWidth(font: self.titleLabel.font, fixedHeight: kDefaultBarHeight)
            self.titleLabel.frame = CGRect(x: 0, y: kDefaultBarTop, width: width, height: kDefaultBarHeight)
            self.titleLabel.center = CGPoint(x: self.frame.width / 2, y: kDefaultBarCenterY)
        }
        if let view = self.titleView {
            view.center = CGPoint(x: self.frame.width / 2, y: kDefaultBarCenterY)
        }
    }
    
    private func clearItemBy(inner_key: String) {
        guard inner_key.count > 0 else { return }
        for view in self.subviews {
            if let key = view.inner_key, key == inner_key {
                view.removeFromSuperview()
            }
        }
    }
}

fileprivate extension UIView {
    private struct AssociatedKeys {
        static var inner_key: String?
    }
    
    var inner_key: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.inner_key) as? String
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.inner_key, newValue as String?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}
