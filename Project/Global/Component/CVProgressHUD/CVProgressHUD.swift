//
//  CVProgressHUD.swift
//  Project
//
//  Created by caven on 2018/7/10.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit

open class CVProgressHUD: UIView {
    
    /// 内边距（mainView 的 subView 到 mainView 的左右边距）
    struct CVPadding {
        var top: CGFloat = 10
        var left: CGFloat = 10
        var bottom: CGFloat = 10
        var right: CGFloat = 10
    }
    /// 外边距（mainView 到 superView 的边距）
    struct CVMargin {
        var top: CGFloat = 10
        var left: CGFloat = 50
        var bottom: CGFloat = 10
        var right: CGFloat = 50
    }
    
    fileprivate lazy var backgroundView: CVBackgroundView = {
        return CVBackgroundView()
    }()

    /// 显示内容的 mainView
    fileprivate lazy var mainView: CVBackgroundView = {
        
        let mainView = CVBackgroundView()
        mainView.backgroundColor = shadowColor
        mainView.layer.cornerRadius = 5
        return mainView
    }()
    /// mainView 的 size
    fileprivate var mainViewSize = CGSize(width: 0, height: 0)
    
    /// 显示 indicator 的 View
    fileprivate lazy var indicatorContainer: UIView = {
        
        let indicatorContainer = UIView()
        return indicatorContainer
    }()
    
    /// 指示器
    fileprivate lazy var indicator: CVIndicator = {
        let indicator = CVIndicator()
        return indicator
    }()
    
    /// 显示 title 的 label
    fileprivate lazy var titleLabel: UILabel = {
        
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byTruncatingMiddle
        titleLabel.text = ""
        titleLabel.textColor = UIColor.white
        return titleLabel
    }()
    /// titleText 的 size
    fileprivate var titleTextSize: CGSize! = CGSize(width: 0, height: 0)
    
    /// 显示 detail 的 label
    fileprivate lazy var detailLabel: UILabel = {
        let detailLabel = UILabel()
        detailLabel.textAlignment = NSTextAlignment.center
        detailLabel.numberOfLines = 0
        detailLabel.text = ""
        detailLabel.textColor = UIColor.white
        return detailLabel
    }()
    /// detailText 的 size
    fileprivate var detailTextSize = CGSize(width: 0, height: 0)
    
    /// 控件高度上的间距
    fileprivate let spaceOfHeight: CGFloat = 5.0
    
    
    // MARK: - 外部可控制的属性
    
    /// 背景 View 的颜色
    var backgroundViewColor = UIColor.clear {
        didSet { self.backgroundView.backgroundColor = self.backgroundViewColor }
    }
    
    /// mainView 的颜色
    var mainViewColor = shadowColor {
        didSet{ self.mainView.backgroundColor = self.mainViewColor }
    }
    
    /// indicatorContainer 的 size
    var indicatorContainerSize = CGSize(width: 40, height: 40)
    
    /// 自定义 indicatorView
    var customIndicatorView: UIView? {
        didSet {
            if self.indicatorContainerVisible && self.customIndicatorView != nil { // indicator 显示
                self.indicatorContainerSize = self.customIndicatorView!.frame.size
                self.indicator.removeFromSuperview()
                self.indicatorContainer.addSubview(self.customIndicatorView!)
            } else {
                self.customIndicatorView = nil
            }
        }
    }
    
    /// 是否显示 indicatorView
    var indicatorContainerVisible = true {
        didSet {
            if !self.indicatorContainerVisible { // indicator 不显示
                self.indicatorContainerSize = CGSize(width: 0, height: 0)
                self.indicator.removeFromSuperview()
            }
        }
    }
    
    /// titleLabel 显示的文字
    var titleText = ""{
        didSet {
            self.titleLabel.text = self.titleText
            self.mainView.addSubview(self.titleLabel)
        }
    }
    
    /// detailText 显示的文字
    var detailText = "" {
        didSet {
            self.detailLabel.text = self.detailText
            self.mainView.addSubview(self.detailLabel)
        }
    }
    
    /// 是否圆角
    var cornerRadius: CGFloat? {
        didSet {
            guard let tempCornerRadius = cornerRadius else { return }
            self.mainView.layer.cornerRadius = tempCornerRadius
        }
    }
    /// 内部颜色
    var contentColor: UIColor? {
        didSet { updateViewsForColor() }
    }
    
    /// 文字字体
    var textFont: UIFont! {
        didSet {
            self.titleLabel.font = textFont
            self.detailLabel.font = textFont
        }
    }
    
    // MARK: - 下面几个属性可以控制 hud 的边距
    var padding: CVPadding = CVPadding()    /// 内边距（mainView 的 subView 到 mainView 的左右边距）
    var margin: CVMargin = CVMargin()       /// 外边距（mainView 到 superView 的边距）
    var mainViewOffSet: CGFloat = 0
    
    /// HUD 的 superView 是否可以点击 默认不可点击
    var superViewClickable = false
    
    // MARK: - Init
    
    // 重写了父类的 init(frame: CGRect)
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 便利构造方法
    convenience init(view: UIView) {
        self.init(frame: view.bounds)
        self.backgroundColor = UIColor.clear
        self.commonInit()
    }
    
    // 重写 layoutSubviews
    override open func layoutSubviews() {
        
        self.calculateLayout()
        self.setMainViewFrame()
        self.setSubviewsFrames()
        super.layoutSubviews()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if self.superViewClickable {
            
            guard let hitView: UIView = super.hitTest(point, with: event) else { return nil }
            if hitView == self { return nil } else { return hitView }
        } else {
            
            return super.hitTest(point, with: event)
        }
    }
}

// MARK: - 创建和移除HUD的方法
extension CVProgressHUD {
    
    /// 创建 HUD，并添加到 View 上
    class func showMessageHUD(addTo view: UIView) -> CVProgressHUD {
        // 调用便利构造方法 创建HUD
        let hud = CVProgressHUD(view: view)
        view.addSubview(hud)
        return hud
    }
    
    /// 移除 Hud
    @discardableResult
    class func hideHUD(forView view: UIView, animated: Bool) -> Bool {
        
        guard let hud = self.getHUD(from: view) else { return false }
        if animated {
            UIView.animate(withDuration: 0.5, animations: {
                hud.alpha = 0.0
            }, completion: { (true) in
                hud.removeFromSuperview()
            })
        } else {
            hud.removeFromSuperview()
        }
        return true
    }
}

// MARK: - 内部方法  Private Method
fileprivate extension CVProgressHUD {
    
    /// 获取 view 上的 HUD
    class func getHUD(from view: UIView) -> CVProgressHUD? {
        
        for view in view.subviews {
            if view.isKind(of: self){
                return view as? CVProgressHUD
            }
        }
        return nil
    }
    
    /// 做一些通用的初始化操作
    func commonInit() {
        self.tintColor = UIColor.white
        self.setupViews()
        self.registerForNotifications()
    }
    
    /// 注册通知
    func registerForNotifications() {
        
        NotificationCenter.default.addObserver(self, selector:#selector(statusBarOrientationDidChange(notification:)), name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation, object: nil)
        // 在 deinit 中移除了
    }
    
    /// 接收通知调用的方法
    @objc func statusBarOrientationDidChange(notification:NSNotification) {
        
        guard let temp = self.superview else {
            return
        }
        self.frame = temp.bounds
    }
    
    /// 创建并添加控件
    func setupViews() {
        self.addSubview(self.backgroundView)
        self.addSubview(self.mainView)
        self.mainView.addSubview(self.indicatorContainer)
        self.indicatorContainer.addSubview(self.indicator)
    }
    
    /// 更新颜色
    func updateViewsForColor() {
        self.tintColor = self.contentColor
        self.titleLabel.textColor = self.contentColor
        self.detailLabel.textColor = self.contentColor
        self.indicator.color = self.contentColor
    }
}

// MARK: - 布局方法
fileprivate extension CVProgressHUD {
    
    /// 计算布局
    func calculateLayout() {
        
        // 获取 titleText 的 size
        guard let titleText = self.titleLabel.text else { return }
        if !titleText.isEmpty {
            let size = self.textSize(text: titleText, font: self.titleLabel.font, size: CGSize(width: 0, height: 0)).size
            let allSpace: CGFloat = self.padding.left + self.padding.right + self.margin.left + self.margin.right // 左右内外边距计算
            if size.width > (self.frame.size.width - allSpace) {  // 不能超出屏幕
                self.titleTextSize = CGSize(width: self.frame.size.width - allSpace, height: size.height)
            } else {
                self.titleTextSize = size
            }
            self.titleTextSize.height = self.titleTextSize.height + self.spaceOfHeight
        }
        
        // 获取 detailText 的 size
        guard let detailText = self.detailLabel.text else { return }
        if !detailText.isEmpty {
            
            let size = self.textSize(text: detailText, font: detailLabel.font, size: CGSize(width: 0, height: 0)).size
            let allSpace: CGFloat = self.padding.left + self.padding.right + self.margin.left + self.margin.right // 左右内外边距计算
            if size.width > (self.frame.size.width - allSpace) {    // 不能超出屏幕, 如果超出了，则固定最大宽度重新计算高度
                self.detailTextSize = self.textSize(text: detailText, font: detailLabel.font, size: CGSize(width: frame.size.width - allSpace, height: 0)).size
                self.detailTextSize.height = self.detailTextSize.height + size.height
            } else if size.width < kHUDScreenWidth / 4 {  // 不能小于屏幕宽度的1/4
                self.detailTextSize = CGSize(width: kHUDScreenWidth / 4, height: size.height)
            } else {
                self.detailTextSize = size
            }
            self.detailTextSize.height = self.detailTextSize.height + self.spaceOfHeight
        }
        
        // 计算 mainView 的 size
        let mainViewHeigt = self.indicatorContainerSize.height + self.titleTextSize.height + detailTextSize.height + self.padding.bottom + self.padding.top
        
        var arr = [self.indicatorContainerSize.width, self.titleTextSize.width, self.detailTextSize.width]
        var max = arr[0]
        for i in 0..<arr.count { if arr[i] > max{ max = arr[i] } }
        let mainViewWidth = max
        
        // 统一控件宽度
        self.indicatorContainerSize.width = max
        self.titleTextSize.width = max
        self.detailTextSize.width = max
        
        self.mainViewSize = CGSize(width: mainViewWidth + self.padding.left + self.padding.right, height: mainViewHeigt)
    }
    
    /// 设置 backgroundView 和 mainView 的 frame
    func setMainViewFrame() {
        self.backgroundView.frame = bounds
        self.mainView.frame.size = CGSize(width: mainViewSize.width, height: mainViewSize.height)
        
        if self.mainView.superview != nil {
            var tmpCenter = mainView.superview!.center
            tmpCenter.y = tmpCenter.y + self.mainViewOffSet
            self.mainView.center = center
        }
    }
    
    /// 设置 mianView 子控件 frame
    func setSubviewsFrames () {
        
        // indicatorView
        self.indicatorContainer.frame = CGRect(x: self.padding.left,
                                               y: self.padding.top,
                                               width: self.indicatorContainerSize.width,
                                               height: self.indicatorContainerSize.height)
        
        if (self.customIndicatorView != nil) {
            
            self.customIndicatorView!.center = CGPoint(x: self.viewWidth((self.customIndicatorView?.superview)!) / 2,
                                                       y: self.viewHeight((self.customIndicatorView?.superview)!) / 2)
            
            // customIndicatorView 没有设置 frame
            assert(self.viewWidth(self.customIndicatorView!) > CGFloat(0) && self.viewHeight(self.customIndicatorView!) > CGFloat(0) ,"warning：customIndicatorView 没有设置宽和高，如果你确实想这么干，那就注释了这个断言吧 ")
            
        } else {
            self.indicator.frame = self.indicatorContainer.bounds
        }
        
        // titleLabel
        self.titleLabel.frame = CGRect(x: self.padding.left,
                                       y: self.rectMaxY(self.indicatorContainer),
                                       width: self.titleTextSize.width,
                                       height: self.titleTextSize.height)
        // detailLabel
        self.detailLabel.frame = CGRect(x: self.padding.left,
                                        y: self.rectMaxY(self.titleLabel) ,
                                        width: self.detailTextSize.width,
                                        height: self.detailTextSize.height)
        
    }
    
}

// MARK: - CVIndicator
fileprivate class CVIndicator: UIView {
    
    var color: UIColor? = UIColor.white {
        
        didSet { commonInit() }
    }
    
    let lineWidth: CGFloat = 2.0
    
    fileprivate lazy var indicatorLayer: CAShapeLayer = {
        
        let indicatorLayer = CAShapeLayer()
        return indicatorLayer
    }()
    
    fileprivate lazy var gradientLayer: CAGradientLayer = {
        
        let gradientLayer = CAGradientLayer()
        return gradientLayer
    }()
    
    override var frame: CGRect {
        
        didSet {
            commonInit()
            startAnimation()
        }
    }
    
    fileprivate func commonInit() {
        
        backgroundColor = UIColor.clear
        
        let radius: CGFloat = 10.0
        
        // 设置 渐变 图层
        gradientLayer.colors = [color!.cgColor, UIColor.white.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.25)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        let gradientLayerCenter = CGPoint(x: frame.size.width / 2 - radius, y: frame.size.height / 2 - radius)
        
        gradientLayer.frame = CGRect(x: gradientLayerCenter.x, y: gradientLayerCenter.y, width: radius * 2 + lineWidth, height: radius * 2 + lineWidth)
        
        // 设置 mask 图层
        indicatorLayer.fillColor = UIColor.clear.cgColor
        indicatorLayer.strokeColor = UIColor.black.cgColor
        indicatorLayer.lineWidth = lineWidth
        indicatorLayer.lineCap = kCALineCapRound
        
        // 绘制 path
        let startAngle: CGFloat = 0
        let endAngle = CGFloat(Double.pi / 2 * 3)
        let arcCenter = CGPoint(x: gradientLayer.frame.size.width / 2, y: gradientLayer.frame.size.height / 2)
        let path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        indicatorLayer.path = path.cgPath
        gradientLayer.mask = indicatorLayer
        
        layer.addSublayer(gradientLayer)
    }
    
    fileprivate func startAnimation() {
        
        // 创建旋转动画
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = NSNumber.init(value:  Double.pi * 2.0)
        // 旋转指定角度需要的时间
        animation.duration = 1.0
        // 旋转重复次数
        animation.repeatCount = MAXFLOAT
        // 动画执行完后不移除
        animation.isRemovedOnCompletion = true
        animation.isRemovedOnCompletion = false
        // 将动画添加到视图的laye上
        gradientLayer.add(animation, forKey: "rotationAnimation")
    }
}

// MARK: - CVBackgroundView
fileprivate class CVBackgroundView: UIView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        guard let hitView: UIView = super.hitTest(point, with: event) else { return nil }
        if hitView == self { return nil } else { return hitView }
    }
}

// MARK: - 通用方法
fileprivate extension CVProgressHUD {
    
    func textSize(text: String, font: UIFont, size: CGSize) -> CGRect {
        
        let attributes = [NSAttributedStringKey.font : font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect: CGRect = text.boundingRect(with: size, options: option, attributes: attributes, context: nil)
        return rect;
    }
    
    func viewWidth(_ view:UIView) -> CGFloat {
        return view.frame.size.width
    }
    
    func viewHeight(_ view:UIView) -> CGFloat {
        return view.frame.size.height
    }
    
    func rectMaxX(_ view:UIView) -> CGFloat {
        return view.frame.maxX
    }
    
    func rectMaxY(_ view:UIView) -> CGFloat {
        return view.frame.maxY
    }
    
    func rectMinX(_ view:UIView) -> CGFloat {
        return view.frame.minX
    }
    
    func rectMinY(_ view:UIView) -> CGFloat {
        return view.frame.minY
    }
}

// MARK: - 参数

fileprivate let shadowColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)

fileprivate let kHUDScreenWidth = UIScreen.main.bounds.width

fileprivate let kHUDScreenHeight = UIScreen.main.bounds.height
