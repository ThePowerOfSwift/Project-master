//
//  CVCycleCell.swift
//  Project
//
//  Created by caven on 2018/4/15.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit

class CVCycleCell: UICollectionViewCell {
    
    
    /// 标题
    var title: String = "" {
        didSet {
            self.titleLabel.text = "\(title)"
            
            if title.count > 0 {
                self.titleBackView.isHidden = false
                self.titleLabel.isHidden = false
            } else {
                self.titleBackView.isHidden = true
                self.titleLabel.isHidden = true
            }
        }
    }
    
    /// 标题颜色
    var titleColor: UIColor = UIColor.white {
        didSet {
            self.titleLabel.textColor = titleColor
        }
    }
    
    // 标题字体
    var titleFont: UIFont = UIFont.systemFont(ofSize: 15) {
        didSet {
            self.titleLabel.font = titleFont
        }
    }
    
    // 文本行数
    var numberOfLines: NSInteger = 1 {
        didSet {
            self.titleLabel.numberOfLines = numberOfLines
        }
    }
    
    /// 标题文本x轴间距
    var titleLabelLeading: CGFloat = 15 {
        didSet {
            self.titleLabel.updateConstraints { (make) in
                make.left.equalTo(titleLabelLeading)
                make.right.equalTo(titleLabelLeading)
            }
        }
    }
    
    /// 标题背景色
    var titleBackViewBackgroundColor: UIColor = UIColor.black.withAlphaComponent(0.3) {
        didSet {
            self.titleBackView.backgroundColor = titleBackViewBackgroundColor
        }
    }

    var imageView: UIImageView!
    private var titleLabel: UILabel!
    private var titleBackView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.imageView = cimageView(image: nil, super: self.contentView)
        self.titleBackView = cview(color: self.titleBackViewBackgroundColor, super: self.contentView)
        self.titleLabel = clabel(font: self.titleFont, text: nil, super: self.contentView)
        self.titleLabel.textColor = self.titleColor
        self.titleLabel.text = ""

        // 适配
        self.imageView.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
        
        self.titleLabel.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
        }
        
        self.titleBackView.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(self.titleBackView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


