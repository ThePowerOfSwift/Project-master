//
//  CVActionSheet.swift
//  Project
//
//  Created by caven on 2018/7/9.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit

private let screenWidth  = UIScreen.main.bounds.size.width
private let screenHeight = UIScreen.main.bounds.size.height
private let height_button: CGFloat = 50
private let height_bottom_view: CGFloat = 70
private let margin_left: CGFloat = 10

private let color_title = UIColor.init(red: 100.0/255, green: 100.0/255, blue: 100.0/255, alpha: 1.0)
private let color_button_title_cancel = UIColor.init(red: 10.0/255, green: 96.0/255, blue: 255.0/255, alpha: 1.0)
private let color_button_title_other = UIColor.init(red: 70.0/255, green: 130.0/255, blue: 233.0/255, alpha: 1.0)
private let color_button_bg_image = UIColor.init(red: 235.0/255, green: 235.0/255, blue: 235.0/255, alpha: 1.0)
private let color_line = UIColor.init(red: 219.0/255, green: 219.0/255, blue: 219.0/255, alpha: 1.0)

typealias CVActionSheetClosure = ((_ buttonIndex: Int) -> Void)?

class CVActionSheet: UIView {


    public var titleFont: UIFont = UIFont.systemFont(ofSize: 13) {
        willSet {
            self.titleLabel.font = newValue
        }
    }
    public var textAlignment: CVTextAlignment = .center {
        willSet {
            switch newValue {
            case .left:
                self.titleLabel.textAlignment = .left
                for btn in self.buttonArray {
                    btn.contentHorizontalAlignment = .left
                }
            case .center:
                self.titleLabel.textAlignment = .center
                for btn in self.buttonArray {
                    btn.contentHorizontalAlignment = .center
                }
            case .right:
                self.titleLabel.textAlignment = .right
                for btn in self.buttonArray {
                    btn.contentHorizontalAlignment = .right
                }
            }
        }
    }
    
    // background visual
    public var visual = false {
        willSet(newValue) {
            if newValue == true {
                self.effectView.backgroundColor = UIColor.clear
            } else {
                self.effectView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 102.0/255)
            }
        }
        
    }
    // backgroudColor visual
    public var visualBGColor = UIColor(red: 0, green: 0, blue: 0, alpha: 102.0/255) {
        willSet(newValue) {
            self.effectView.backgroundColor = newValue
        }
    }
    
    public var cancelTitleColor: UIColor = color_button_title_cancel {
        willSet {
            self.cancelButton?.setTitleColor(newValue, for: .normal)
        }
    }
    public var textNormalColor: UIColor = color_button_title_other {  // 设置按钮正常状态下的文字颜色
        willSet {
            for button in self.buttonArray {
                button.setTitleColor(newValue, for: .normal)
            }
        }
    }
    public var textHighlightColor: UIColor? {     // 按钮选中的颜色
        willSet {
            for btn in self.buttonArray {
                btn.setTitleColor(newValue, for: .selected)
            }
        }
    }
    public var selectedIndex: Int?              // 选中item的index
    
    
    // MARK: - Private Property
    private var contentView: UIView!
    private var titleLabel: UILabel!
    private var scrollView: UIScrollView!
    private var cancelButton: UIButton!
    private var buttonArray: [UIButton] = []
    private var bottomView: UIView!     // 取消按钮的view
    
    private var effectView: UIVisualEffectView!
    
    private var title: String?
    
    private var cancelButtonTitle: String = LS(key: "Cancel", comment: "取消")
    private var sheets: [String] = []
    private var clickButtonClosure: CVActionSheetClosure
    
    // MARK: - init
    override init(frame: CGRect) {
        contentView = UIView(frame: CGRect(x: margin_left, y: 0.0, width: screenWidth - 2 * margin_left, height: 0))
        contentView.backgroundColor = UIColor.clear
        contentView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
        contentView.layer.cornerRadius  = 10
        contentView.layer.masksToBounds = true
        
        titleLabel = UILabel(frame: CGRect(x: margin_left, y: 22, width: contentView.frame.height - margin_left * 2, height: 0))
        titleLabel.textColor = color_title
        titleLabel.textAlignment = .center
        titleLabel.font = self.titleFont
        
        scrollView = UIScrollView(frame: CGRect(x: margin_left, y: 22, width: contentView.frame.height - margin_left * 2, height: 0))
        scrollView.backgroundColor = UIColor.clear
        
        
        bottomView = UIView(frame: CGRect(x: 0, y: screenHeight - height_bottom_view, width: screenWidth, height: height_bottom_view))
        bottomView.backgroundColor = UIColor.clear
        
        effectView = UIVisualEffectView()
        effectView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        effectView.effect = nil
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// 遍历构造器
    public convenience init(title: String?, sheets: [String], clickButtonClosure: CVActionSheetClosure) {
        self.init()
        
        // 标题
        self.title = title
        self.titleLabel.text = title
        
        var others = sheets
        for c in sheets {
            if c.isBlank(trimWhiteSpace: true) { // 过滤掉空的字符串
                others.remove(c)
            }
        }
        self.sheets = others
        
        self.setupDefault()
        self.setupButton()
        self.updateFrame()
    }
    
    // MARK: - Public Method
    
    @discardableResult
    open class func show(title: String?, sheets: String... , clickButtonClosure: CVActionSheetClosure) -> CVActionSheet {
        
        let actionSheet = CVActionSheet(title: title, sheets: sheets, clickButtonClosure: clickButtonClosure)
        actionSheet.show()
        return actionSheet
    }
    
    open func show() {
        self.show(select: self.selectedIndex)
    }
    
    open func show(select index: Int?) {
        
        for btn in self.buttonArray {
            btn.isSelected = false
        }
        
        if index == nil {
            self.selectedIndex = nil
            
        } else {
            if index! > 0 && index! < self.buttonArray.count {
                self.selectedIndex = index
            }
        }
        
        if self.selectedIndex != nil {
            let btn = self.buttonArray[self.selectedIndex!]
            btn.isSelected = true
        }
        
        UIApplication.shared.keyWindow?.addSubview(self)
        
        self.contentView.alpha = 0.0
        UIView.animate(withDuration: 0.34, animations: { [unowned self] in
            if self.visual == true {
                self.effectView.effect = UIBlurEffect(style: .dark)
            }
            self.contentView.alpha = 1.0
        })
    }
    
    // MARK: - Private Method
    /// 初始化默认属性
    fileprivate func setupDefault() {
        self.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        self.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.backgroundColor  = UIColor.clear
        self.visual = true
        self.addSubview(self.effectView)
        self.addSubview(self.contentView)
        self.contentView.backgroundColor = UIColor.white
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.scrollView)
        self.addSubview(self.bottomView)
    }
    
    /// 创建buttons
    private func setupButton() {
        
        var buttonY: CGFloat = 0
        self.buttonArray.removeAll()
        
        // others
        if self.sheets.count > 0 {
            for number in 0..<self.sheets.count {
                let title = self.sheets[number]
                let selector = #selector(onClickOther(button:))
                let button = generateButton(frame: CGRect(x: margin_left, y: buttonY, width: screenWidth - 4 * margin_left, height: height_button), title: title, target: self, action: selector)
                self.buttonArray.append(button)
                
                let lineUp = UIView(frame: CGRect(x: 0, y: buttonY, width: screenWidth - 2 * margin_left, height: 0.5))
                lineUp.backgroundColor = color_line
                
                self.scrollView.addSubview(button)
                self.scrollView.addSubview(lineUp)
                
                buttonY += height_button  // 将buttonY移动到下一个起始位置
            }
        }
    
        // cancel
        let title = self.cancelButtonTitle
        let selector = #selector(onClickCancel(button:))
        let cancelY = (self.bottomView.frame.height - height_button) / 2
        // cancel
        let cancelBtn = generateButton(frame: CGRect(x: 0, y: cancelY, width: screenWidth - 2 * margin_left, height: height_button), title: title, target: self, action: selector)
        cancelBtn.setTitleColor(color_button_title_cancel, for: .normal)
        cancelBtn.layer.cornerRadius  = 10
        cancelBtn.layer.masksToBounds = true
        self.cancelButton = cancelBtn
        self.bottomView.addSubview(cancelBtn)
    }
    
    private func updateFrame() {
        
        self.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        self.effectView.frame = self.bounds
        
        
        // 标题
        let labelX: CGFloat = margin_left
        let labelY: CGFloat = 5
        let labelW: CGFloat = screenWidth - 4 * labelX
        self.titleLabel.sizeToFit()
        
        let size = CGSize(width: self.titleLabel.frame.size.width, height: self.titleLabel.frame.size.height + 10)
        self.titleLabel.frame = CGRect(x: 0, y: labelY, width: labelW, height: size.height)
        
        // 按钮
        let space: CGFloat = 5 // titleLabel 距离 scrollView 的距离
        var scrollH: CGFloat = height_button * CGFloat(self.buttonArray.count)  // others 的总高度
        
        // 在这里需要计算整体的高度，不能超出屏幕
        var contentViewHeight = self.titleLabel.frame.maxY + space + scrollH
        if self.title == nil || self.title?.count == 0 {
            contentViewHeight = scrollH
        }
        if contentViewHeight > screenHeight - 30 {  // 屏幕上边留最少30的边距
            if self.title == nil || self.title?.count == 0 {
                contentViewHeight = screenHeight - 30 - height_bottom_view
                scrollH = contentViewHeight
            } else {
                contentViewHeight = screenHeight - 30 - height_bottom_view
                scrollH = contentViewHeight - (self.titleLabel.frame.maxY + space)
            }
        }
        
        let width = screenWidth - margin_left * 2
        
        self.contentView.frame = CGRect(x: margin_left, y: screenHeight - contentViewHeight - height_bottom_view, width: width, height: contentViewHeight)
        
        self.titleLabel.frame = CGRect(x: labelX, y: labelY, width: labelW, height: size.height)
        let y: CGFloat = (self.title == nil || self.title?.count == 0) ? 0 : self.titleLabel.frame.maxY + space
        self.scrollView.frame = CGRect(x: 0, y: y, width: width, height: scrollH)
        self.scrollView.contentSize = CGSize(width: width, height: height_button * CGFloat(self.buttonArray.count))
        self.bottomView.frame = CGRect(x: self.contentView.frame.minX, y: self.contentView.frame.maxY, width: width, height: height_bottom_view)
        
    }

    /// 创建按钮
    private func generateButton(frame: CGRect, title: String, target: Any, action: Selector) -> UIButton {
        let button = UIButton(type: .custom)
        button.frame = frame
        button.setTitleColor(color_button_title_other, for: .normal)
        button.setTitle(title, for: .normal)
        button.setBackgroundImage(generateImage(color: UIColor.white), for: .normal)
        button.setBackgroundImage(generateImage(color: color_button_bg_image), for: .highlighted)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(target, action: action, for: .touchUpInside)
        
        return button
    }
    
    /// 创建图片
    private func generateImage(color: UIColor) -> UIImage? {
        
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 移除actionSheet
    private func remove() {
        UIView.animate(withDuration: 0.3, animations: { [unowned self] in
            if self.visual == true {
                self.effectView.effect = nil
            }
            self.contentView.alpha = 0.0
        }, completion: { [unowned self] (finished: Bool) in
            self.removeFromSuperview()
        })
    }


    // MARK: - Actions

    /// 点击了取消按钮
    @objc private func onClickCancel(button: UIButton) {
        if let aBlock = self.clickButtonClosure {
            aBlock(0)
        }
        self.remove()
    }

    /// 点击了其他的按钮
    @objc private func onClickOther(button: UIButton) {
        let buttonIndex = self.buttonArray.index(of: button)! + 1
        if let aBlock = self.clickButtonClosure {
            aBlock(buttonIndex)
        }
        self.selectedIndex = buttonIndex - 1
        self.remove()
    }
}
