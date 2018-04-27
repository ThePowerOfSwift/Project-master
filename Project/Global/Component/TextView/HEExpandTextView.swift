//
//  HEExpandTextView.swift
//  HEKeyboardTextField
//
//  Created by weixhe on 2018/3/1.
//  Copyright © 2018年 com.weixhe. All rights reserved.
//

import UIKit

open class HEExpandTextView: HEPlaceholderTextView {
    
    public enum HEExpandDirection {
        case toUp   // 向上延伸
        case toDown // 向下延伸
    }
    // MARK: Property
    public var expandDirection: HEExpandDirection = .toDown     // 延伸方向选择，默认向下延伸
    public var maxVisibleLines: NSInteger = 4        // 最大的可见行数，
    private var _textViewDefaultHeight: CGFloat = 0.0 // 只做存储，不再外用，模拟OC的setter和getter
    public var textViewDefaultHeight: CGFloat {
        get {
            return _textViewDefaultHeight - self.numwordsHeight - self.textContentInset.top - self.textContentInset.bottom
        }
        set {
            _textViewDefaultHeight = newValue
        }
    }
    
    // MARK: Initial
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    // MARK: DeInitial
    deinit {
        self.textView.removeObserver(self, forKeyPath: "contentSize", context: nil)
    }
    
    // MARK: Overwrite
    override open func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: UI
    fileprivate func setup() {
        self.textViewDefaultHeight = self.frame.height      // 记录初始化时候的height
        self.textView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
}

// MARK: - HEExpandTextView 计算高度
extension HEExpandTextView {
    /// 根据行数line计算高度46
    fileprivate func textViewCurrentHeightForLines(_ numberOfLines : Int) -> CGFloat {
        var height = self.textViewDefaultHeight
        let lineTotalHeight = textView.font!.lineHeight * CGFloat(numberOfLines)
        if lineTotalHeight > height {
            height = lineTotalHeight
        }
        return CGFloat(roundf(Float(height)));
    }
    
    /// 根据行数计算输入框的适当高度
    fileprivate func appropriateInputbarHeight() -> CGFloat {
        var height : CGFloat = 0.0;

        if self.textView.numberOfLines() == 0 || self.textView.numberOfLines() == 1 {
            height = self.textViewDefaultHeight
        } else if self.textView.numberOfLines() < self.maxVisibleLines {
            height = textViewCurrentHeightForLines(textView.numberOfLines())
            if height < self.textViewDefaultHeight {
                height = self.textViewDefaultHeight
            }
        } else {
            height = textViewCurrentHeightForLines(self.maxVisibleLines)
        }
        
        height += self.numwordsHeight + self.textContentInset.top + self.textContentInset.bottom   // 加上 剩余文字提示bar的高度 and textContentInset的内边距
        return CGFloat(roundf(Float(height)));
    }
}

// MARK: - HEExpandTextView 观察者
extension HEExpandTextView {
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        
        if let object = object as? UITextView, let _ = change {
            if object == self.textView && keyPath == "contentSize" {
                
                let newInputbarHeight = self.appropriateInputbarHeight()
                if newInputbarHeight != self.frame.size.height && self.superview != nil {
                    UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions(), animations: { () -> Void in
                        if self.expandDirection == .toUp {
                            self.frame = CGRect(x: self.frame.minX,  y: self.frame.maxY - newInputbarHeight , width: self.frame.width, height: newInputbarHeight)
                            self.layoutIfNeeded()
                        } else if self.expandDirection == .toDown {
                            self.frame = CGRect(x: self.frame.minX,  y: self.frame.minY, width: self.frame.width, height: newInputbarHeight)
                            self.layoutIfNeeded()
                        }

                    }, completion:{_ in
                    })
                }
            }
        }
    }
}
