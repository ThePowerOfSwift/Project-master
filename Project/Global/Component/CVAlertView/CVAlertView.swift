//
//  CVAlertView.swift
//  Project
//
//  Created by caven on 2018/7/2.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit

private let screenWidth  = UIScreen.main.bounds.size.width
private let screenHeight = UIScreen.main.bounds.size.height
private let contentWidth: CGFloat  = 270.0
private let contentHeight: CGFloat = 88.0
private let height_button: CGFloat = 44.0
private let margin_left: CGFloat = 16

private let color_button_title_cancel = UIColor.init(red: 10.0/255, green: 96.0/255, blue: 255.0/255, alpha: 1.0)
private let color_button_title_other = UIColor.init(red: 70.0/255, green: 130.0/255, blue: 233.0/255, alpha: 1.0)
private let color_button_bg_image = UIColor.init(red: 235.0/255, green: 235.0/255, blue: 235.0/255, alpha: 1.0)
private let color_line = UIColor.init(red: 219.0/255, green: 219.0/255, blue: 219.0/255, alpha: 1.0)

typealias CVAlertViewClickButtonClosure = ((_ alertView: CVAlertView, _ buttonIndex: Int) -> Void)?

/// alertView出现时的动画
enum CVAlertViewAnimationOptions {
    case none           // 默认， 没有任何动画，直接显示出来
    case zoom           // 先放大，再缩小，在还原
    case topToCenter    // 从上到中间
}

enum CVTextAlignment {
    case left
    case center
    case right
}

protocol CVAlertViewDelegate {
    /// alert 被点击时的回调
    func alertView(alertView: CVAlertView, clickedButtonAtIndex: Int)
}

class CVAlertView: UIView {
    
    public var delegate: CVAlertViewDelegate?
    public var animationOption: CVAlertViewAnimationOptions = .none
    public var textAlignment: CVTextAlignment = .center {
        willSet {
            switch newValue {
            case .left:
                self.titleLabel.textAlignment = .left
                self.messageLabel.textAlignment = .left
            case .center:
                self.titleLabel.textAlignment = .center
                self.messageLabel.textAlignment = .center
            case .right:
                self.titleLabel.textAlignment = .right
                self.messageLabel.textAlignment = .right
            }
        }
    }
    
    public var attributedText: NSAttributedString? {
        willSet {
            self.messageLabel.attributedText = newValue
            self.updateFrame()
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
    public var otherTitleColor: UIColor = color_button_title_other {
        willSet {
            for button in self.otherButtonArray {
                button.setTitleColor(newValue, for: .normal)
            }
        }
    }


    // MARK: - Private Property
    private var contentView: UIView!
    private var titleLabel: UILabel!
    private var messageLabel: UILabel!
    private var messageScrollView: UIScrollView!
    private var cancelButton: UIButton?
    private var otherButtonArray: [UIButton] = []
    private var bottomView: UIView!
    
    private var effectView: UIVisualEffectView!
    
    private var title: String?
    private var message: String?
    
    private var cancelButtonTitle: String?
    private var otherButtonTitles: [String]? = []
    private var clickButtonBlock: CVAlertViewClickButtonClosure
    
    // MARK: - init
    override init(frame: CGRect) {
        contentView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: contentWidth, height: contentHeight))
        contentView.center = CGPoint(x: screenWidth / 2, y: screenHeight / 2)
        contentView.backgroundColor = UIColor.white
        contentView.layer.cornerRadius  = 10
        contentView.layer.masksToBounds = true
        contentView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
        
        
        titleLabel = UILabel(frame: CGRect(x: margin_left, y: 22, width: contentWidth - margin_left * 2, height: 0))
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        
        messageScrollView = UIScrollView(frame: CGRect(x: margin_left, y: 22, width: contentWidth - margin_left * 2, height: 0))
        messageScrollView.showsVerticalScrollIndicator = false
        messageScrollView.showsHorizontalScrollIndicator = false
        
        messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: messageScrollView.frame.width, height: 0))
        messageLabel.textColor = UIColor.black
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.systemFont(ofSize: 13)
        messageLabel.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]

        bottomView = UIView(frame: CGRect(x: 0, y: 0, width: contentWidth, height: 0))
        
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
    public convenience init(title: String?, message: String?, delegate: CVAlertViewDelegate?, cancelButtonTitle: String?, otherButtonTitles: [String]?) {
        
        self.init()
        
        // 标题
        self.title = title
        self.titleLabel.text   = title
        
        // 消息
        self.message = message
        
        self.messageLabel.text = message
        self.messageLabel.sizeToFit()
        
        self.delegate = delegate
        self.cancelButtonTitle = cancelButtonTitle
        
        if var others = otherButtonTitles {
            for c in others {
                if c.isBlank(trimWhiteSpace: true) {
                    others.remove(c)
                }
            }
            self.otherButtonTitles = others
        }
      
        self.setupDefault()
        self.setupButton()
        self.updateFrame()
    }
    
    // MARK: - Public Method
    @discardableResult
    open class func show(title: String, message: String?, cancelButtonTitle: String?, otherButtonTitles: String? ... , clickButtonBlock: CVAlertViewClickButtonClosure) -> CVAlertView {
        var others: [String] = []
        for c in otherButtonTitles {
            if let string = c {
                others.append(string)
            } else {
                break
            }
        }
        let alertView = CVAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: cancelButtonTitle, otherButtonTitles: others)
        alertView.clickButtonBlock = clickButtonBlock
        alertView.show()
        return alertView
    }
    
    @discardableResult
    open class func show(title: String, message: String?, cancelButtonTitle: String?, otherButtonTitle: String?, clickButtonBlock: CVAlertViewClickButtonClosure) -> CVAlertView {
        let others: [String] = otherButtonTitle != nil ? [otherButtonTitle!] : []
        let alertView = CVAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: cancelButtonTitle, otherButtonTitles: others)
        alertView.clickButtonBlock = clickButtonBlock
        alertView.show()
        return alertView
    }
    
    // shows popup alert animated.
    open func show() {
        
        UIApplication.shared.keyWindow?.addSubview(self)
        
        switch animationOption {
            
        case .none:
            self.contentView.alpha = 0.0
            UIView.animate(withDuration: 0.34, animations: { [unowned self] in
                if self.visual == true {
                    self.effectView.effect = UIBlurEffect(style: .dark)
                }
                self.contentView.alpha = 1.0
            })
            break
            
        case .zoom:
            
            self.contentView.layer.setValue(0, forKeyPath: "transform.scale")
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
                [unowned self] in
                if self.visual == true {
                    self.effectView.effect = UIBlurEffect(style: .dark)
                }
                self.contentView.layer.setValue(1.0, forKeyPath: "transform.scale")
            }, completion: { _ in
            })
            
            break
        case .topToCenter:
            
            let startPoint = CGPoint(x: center.x, y: self.contentView.frame.height)
            self.contentView.layer.position = startPoint
            
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: { [unowned self] in
                if self.visual == true {
                    self.effectView.effect = UIBlurEffect(style: .dark)
                }
                self.contentView.layer.position = self.center
            }, completion: { _ in
            })
            break
        }
    }
    
    // MARK: - Private Method
    
    /// 初始化默认属性
    fileprivate func setupDefault() {
        self.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        self.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.backgroundColor  = UIColor.clear
        self.visual = true
        self.animationOption = .zoom
        self.addSubview(self.effectView)
        self.addSubview(self.contentView)
        self.contentView.backgroundColor = UIColor.white
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.messageScrollView)
        self.messageScrollView.addSubview(self.messageLabel)
        self.contentView.addSubview(self.bottomView)
    }
    
    /// 创建buttons
    private func setupButton() {
        
        var buttonY: CGFloat = 10
        self.otherButtonArray.removeAll()
        
        // 如果有otherTitles
        if let otherTitles = self.otherButtonTitles, otherTitles.count > 0 {
            if otherTitles.count == 1 {  // 如果只有1个otherTitle，则横排1行
                var off_x: CGFloat = 0
                var width: CGFloat = contentWidth
                
                if self.cancelButtonTitle?.isEmpty == false { // 有cancelTitle
                    width = contentWidth / 2
                    
                    // cancel
                    let title = self.cancelButtonTitle ?? ""
                    let selector = #selector(onClickCancel(button:))
                    let cancelBtn = generateButton(frame: CGRect(x: off_x, y: buttonY, width: width, height: height_button), title: title, target: self, action: selector)
                    cancelBtn.setTitleColor(color_button_title_cancel, for: .normal)
                    self.cancelButton = cancelBtn
                    self.bottomView.addSubview(cancelBtn)
                    off_x = width
                }
                // others
                let title = otherTitles.first!
                let selector = #selector(onClickOther(button:))
                let otherBtn = generateButton(frame: CGRect(x: off_x, y: buttonY, width: width, height: height_button), title: title, target: self, action: selector)
                self.bottomView.addSubview(otherBtn)
                self.otherButtonArray.append(otherBtn)

            } else {        // 如果otherTitle > 1， 则将按钮竖排，并加上取消按钮
                
                // others
                for number in 0..<otherTitles.count {
                    let title = otherTitles[number]
                    let selector = #selector(onClickOther(button:))
                    let button = generateButton(frame: CGRect(x: 0, y: buttonY, width: contentWidth, height: height_button), title: title, target: self, action: selector)
                    self.otherButtonArray.append(button)
                    self.bottomView.addSubview(button)
                    buttonY += height_button  // 将buttonY移动到下一个起始位置
                }
                
                if self.cancelButtonTitle?.isEmpty == false { // 有cancelTitle
                    // cancel
                    let title = self.cancelButtonTitle ?? ""
                    let selector = #selector(onClickCancel(button:))
                    // cancel
                    let cancelBtn = generateButton(frame: CGRect(x: 0, y: buttonY, width: contentWidth, height: height_button), title: title, target: self, action: selector)
                    cancelBtn.setTitleColor(color_button_title_cancel, for: .normal)
                    self.cancelButton = cancelBtn
                    self.bottomView.addSubview(cancelBtn)
                }
            }
        } else {
            // 如果没有otherTitles
            if self.cancelButtonTitle?.isEmpty == false { // 有cancelTitle
                // cancel
                let title = self.cancelButtonTitle ?? ""
                let selector = #selector(onClickCancel(button:))
                // cancel
                let cancelBtn = generateButton(frame: CGRect(x: 0, y: buttonY, width: contentWidth, height: height_button), title: title, target: self, action: selector)
                cancelBtn.setTitleColor(color_button_title_cancel, for: .normal)
                self.cancelButton = cancelBtn
                self.bottomView.addSubview(cancelBtn)
            }
        }

    }
    
    private func updateFrame() {
        
        // 标题
        let labelX: CGFloat = margin_left
        let labelY: CGFloat = 20
        let labelW: CGFloat = contentWidth - 2 * labelX
        self.titleLabel.sizeToFit()
        
        let size = self.titleLabel.frame.size
        self.titleLabel.frame = CGRect(x: 0, y: labelY, width: labelW, height: size.height)
        
        // 内容
        let messageY = self.titleLabel.frame.maxY
        self.messageLabel.sizeToFit()
        let sizeMessage = self.messageLabel.frame.size
        var msgScrollHeight = sizeMessage.height + 10
        
        // 按钮
        var buttonH: CGFloat = 10
        
        if self.otherButtonArray.count == 0 {  // 如果others为0，则不管是否存在cancel，高度都为按钮的高度，这个是message与bottom的间隔
            buttonH += height_button
        } else {
            if self.otherButtonArray.count == 1 {
                buttonH += height_button
            } else {
                buttonH += height_button * CGFloat(self.otherButtonArray.count)  // 所有other按钮的高度
                if self.cancelButton != nil { // 有cancel按钮
                    buttonH += height_button
                }
            }
        }

        
        // 在这里需要计算整体的高度，不能超出屏幕
        if messageY + buttonH + msgScrollHeight > screenHeight - 60 {  // 屏幕上下留最少30的边距
            msgScrollHeight = screenHeight - 60 - messageY - buttonH
        }
        self.titleLabel.frame = CGRect(x: labelX, y: labelY, width: labelW, height: size.height)
        self.messageScrollView.frame = CGRect(x: labelX, y: messageY, width: labelW, height: msgScrollHeight)
        self.messageScrollView.contentSize = CGSize(width: labelW, height: sizeMessage.height + 10)
        self.messageLabel.frame = CGRect(x: 0, y: 5, width: labelW, height: sizeMessage.height)
        self.bottomView.frame = CGRect(x: 0, y: self.messageScrollView.frame.maxY, width: contentWidth, height: buttonH)
        
        self.contentView.frame = CGRect(x: 0, y: 0, width: contentWidth, height: messageY + buttonH + msgScrollHeight)
        self.contentView.center = self.center
    }
    
    /// 创建按钮
    private func generateButton(frame: CGRect, title: String, target: Any, action: Selector) -> UIButton {
        let button = UIButton(type: .custom)
        button.frame = frame
        button.setTitleColor(color_button_title_other, for: .normal)
        button.setTitle(title, for: .normal)
        button.setBackgroundImage(generateImage(color: color_button_bg_image), for: .highlighted)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(target, action: action, for: .touchUpInside)
            
        
        let lineUp = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 0.5))
        lineUp.backgroundColor = color_line
        let lineRight = UIView(frame: CGRect(x: frame.size.width, y:  0, width: 0.5, height: frame.size.height))
        lineRight.backgroundColor = color_line
        
        button.addSubview(lineUp)
        button.addSubview(lineRight)
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
    
    /// 移除alert
    private func remove() {
        
        switch self.animationOption {
        case .none:
            
            UIView.animate(withDuration: 0.3, animations: { [unowned self] in
                if self.visual == true {
                    self.effectView.effect = nil
                }
                self.contentView.alpha = 0.0
            }, completion: { [unowned self] (finished: Bool) in
                self.removeFromSuperview()
            })
            
            break
            
        case .zoom:
            UIView.animate(withDuration: 0.3, animations: { [unowned self] in
                self.contentView.alpha = 0.0
                if self.visual == true {
                    self.effectView.effect = nil
                }
            }, completion: { [unowned self] (finished: Bool) in
                    self.removeFromSuperview()
            })
            
            break
        case .topToCenter:
            let endPoint = CGPoint(x: center.x, y: frame.height + contentView.frame.height)
            UIView.animate(withDuration: 0.3, animations: {
                if self.visual == true {
                    self.effectView.effect = nil
                }
                self.contentView.layer.position = endPoint
            }, completion: {[unowned self] (finished: Bool) in
                self.removeFromSuperview()
            })
            break
        }
    }
    
    // MARK: - Actions
    
    /// 点击了取消按钮
    @objc func onClickCancel(button: UIButton) {
        self.delegate?.alertView(alertView: self, clickedButtonAtIndex: 0)
        if let aBlock = self.clickButtonBlock {
            aBlock(self, 0)
        }
        self.remove()
    }
    
    /// 点击了其他的按钮
    @objc func onClickOther(button: UIButton) {
        let buttonIndex = self.otherButtonArray.index(of: button)! + 1
        self.delegate?.alertView(alertView: self, clickedButtonAtIndex: buttonIndex)
        if let aBlock = self.clickButtonBlock {
            aBlock(self, buttonIndex)
        }
        self.remove()
    }
}
