//
//  CVPlaceholderTextView.swift
//  CVKeyboardTextField
//
//  Created by caven on 2018/2/28.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit

open class CVPlaceholderTextView: UIView {

    fileprivate let placeholderLabel = UILabel()
    var placeholder: String = "" {
        didSet {
            self.placeholderLabel.text = placeholder
        }
    }
    public var placeholderHeight: CGFloat = 0.0
    var placeholderColor: UIColor = UIColor.lightGray {
        didSet {
            self.placeholderLabel.textColor = placeholderColor
        }
    }
    
    public var maxWords: NSInteger = 0 {
        didSet {
            self.updateFrame()
            self.numwordsLabel.text = numwords.replacingOccurrences(of: "<left>", with: "\(maxWords)")
                .replacingOccurrences(of: "<total>", with: "\(maxWords)")
                .replacingOccurrences(of: "<already>", with: "\(textView.text.count)")
        }
    }
    
    fileprivate let numwordsLabel = UILabel()
    public var numwords: String = "<already>/<total>"      // 用户自定义时 <left>:剩余字数 、 <total>:总字数 、 <already>:已写字数
    public var numwordsColor: UIColor = UIColor.lightGray {
        didSet {
            self.numwordsLabel.textColor = numwordsColor
        }
    }
    public var numwordsFont: UIFont = UIFont.systemFont(ofSize: 10) {
        didSet {
            self.numwordsLabel.font = numwordsFont
        }
    }
    public var numwordsHiden:Bool = true {    // 隐藏文字统计label
        didSet {
            self.updateFrame()
        }
    }
    
    public var numwordsHeight: CGFloat {
        get {
            var height: CGFloat = 0.0
            if (self.placeholder.count > 0 && self.numwordsHiden == false && maxWords != 0) {
                height = placeholder.autoHeight(font: self.numwordsLabel.font, fixedWidth: self.frame.width - textContentInset.left - textContentInset.right)
            }
            return height
        }
        
    }
    
    public var textView: UITextView = UITextView()
    public var textContentInset: UIEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5) {
        didSet {
            self.updateFrame()
        }
    }
    
    open override var frame: CGRect {
        didSet {
            self.updateFrame()
        }
    }
    
    // MARK: Initial
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    // MARK: Deinitial
    deinit {
        self.textView.removeObserver(self, forKeyPath: "font", context: nil)
        self.placeholderLabel.removeObserver(self, forKeyPath: "text", context: nil)

    }
    
    // MARK: Overwrite
    open override func layoutSubviews() {
        self.updateFrame()
    }
    // MARK: UI
    fileprivate func setupUI() {
        // 创建textView
        self.textView.font = UIFont.systemFont(ofSize: 14)
        self.textView.delegate = self;
        self.textView.backgroundColor = UIColor.clear
        if #available(iOS 11.0, *) {
            self.textView.contentInsetAdjustmentBehavior = .never
        }
        self.textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        self.textView.textContainer.lineFragmentPadding = 0
        self.textView.bounces = false
        self.textView.addObserver(self, forKeyPath: "font", options: NSKeyValueObservingOptions.new, context: nil)
        self.addSubview(self.textView)
        
        // 创建Hlaceholder
        self.placeholderLabel.numberOfLines = 0;
        self.placeholderLabel.textColor = self.placeholderColor
        self.placeholderLabel.font = UIFont.systemFont(ofSize: 14)
        self.placeholderLabel.backgroundColor = UIColor.clear
        self.placeholderLabel.addObserver(self, forKeyPath: "text", options: NSKeyValueObservingOptions.new, context: nil)
        self.addSubview(self.placeholderLabel)
        
        // 创建字数统计的label
        self.numwordsLabel.textColor = self.numwordsColor
        self.numwordsLabel.textAlignment = .right
        self.numwordsLabel.font = self.numwordsFont
        self.numwordsLabel.backgroundColor = UIColor.clear
        self.addSubview(self.numwordsLabel)
        
        self.updateFrame()
    }
    
    public func updateFrame() -> Void {
        let numwordsHeight: CGFloat =  self.numwordsHeight
        let x = self.textContentInset.left, y = self.textContentInset.top
        let width = self.frame.width - x - self.textContentInset.right
        let height = self.frame.height - y - self.textContentInset.bottom
        
        self.textView.frame = CGRect(x: x, y: y, width: width , height: height - numwordsHeight)
        self.placeholderLabel.frame = CGRect(x: x, y: y, width: width, height: self.placeholderHeight)
        self.numwordsLabel.frame = CGRect(x: x, y: self.textView.frame.maxY + self.textContentInset.bottom, width: width, height: numwordsHeight)
    }
}

// MARK: - UITextViewDelegate
extension CVPlaceholderTextView : UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        self.placeholderLabel.isHidden = textView.text.count > 0
        
        
        if self.maxWords > 0 {     // 有限制文字个数
            // 获得已输出字数与正输入字母数
            let selectedRange: UITextRange? = textView.markedTextRange;
            var pos: UITextPosition? = nil
            // 获取高亮部分 － 如果有联想词则解包成功
            if let judgeSelectedRange = selectedRange {
                pos = textView.position(from: judgeSelectedRange.start, offset: 0)
                if pos != nil {
                    return
                }
            }
            
            // 以下开始计算文字个数
            if textView.text.count > self.maxWords {
                let index: String.Index = textView.text.index(textView.text.startIndex, offsetBy: self.maxWords)
                let str = textView.text.prefix(upTo: index)
//                let str = textView.text[..<index]
                textView.text = String(str)
            }
            
            // 改变实时统计数字
            let left = self.maxWords - textView.text.count
            self.numwordsLabel.text = numwords.replacingOccurrences(of: "<left>", with: "\(left)")
                .replacingOccurrences(of: "<total>", with: "\(maxWords)")
                .replacingOccurrences(of: "<already>", with: "\(textView.text.count)")
        }
    }
}

// MARK: - CVPlaceholderTextView 观察者
extension CVPlaceholderTextView {
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let object = object as? UITextView, let _ = change {
            if object == self.textView && keyPath == "font" {
                self.placeholderLabel.font = self.textView.font;
            }
        } else if let object = object as? UILabel, let _ = change {
            if object == self.placeholderLabel && keyPath == "text" {
                var frame = self.placeholderLabel.frame
                var height: CGFloat = 0
                if let text = self.placeholderLabel.text {
                     height = text.autoHeight(font: self.placeholderLabel.font, fixedWidth: self.placeholderLabel.frame.width)
                    self.placeholderHeight = height
                }
                frame.size.height = height
                self.placeholderLabel.frame = frame
            }
        }
    }
}
