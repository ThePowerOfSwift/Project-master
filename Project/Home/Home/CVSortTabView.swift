//
//  CVSortTabView.swift
//  Project
//
//  Created by caven on 2018/5/25.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit

class CVSortTabView: CVPageTabItem {

    var seperateLine: UIView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.seperateLine = cv_view(frame: CGRect.zero, color: UIColor.yellow, super: self)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(style: CVPageTabItemStyle) {
        super.init(style: style)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.seperateLine.frame = CGRectMake(self.cv_width - 1, (self.cv_height - self.cv_height * 0.6) / 2, 1, self.cv_height * 0.6)
    }
    
}


class CVCateTabItem: CVPageTabItem {
    
    var titleLabel: UILabel!
    
    var imageView: UIImageView!
    
    
    required init(style: CVPageTabItemStyle) {
        
        super.init(style: style)
        self.titleLabel = cv_label(font: UIFont.font_12, text: "", super: self)
        self.titleLabel.textColor = UIColor.black
        self.titleLabel.textAlignment = .center
        
        self.imageView = cv_imageView(image: UIImageNamed("back_black"), super: self)
        self.imageView.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi / 2))
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.titleLabel.frame = CGRectMake(0, 0, self.cv_width - 20, self.cv_height)
        self.imageView.frame = CGRectMake(self.cv_width - 20, 0, 10, self.cv_height)
    }
    
    override func cv_setNormalState(animation: Bool) {

        super.cv_setNormalState(animation: animation)
        self.imageView.transform = CGAffineTransform.identity
        self.titleLabel.textColor = self.textColor
        let duration = animation ? 0.3 : 0.0
        
        UIView.animate(withDuration: duration) { [weak self] in
            if let weakSelf = self {
                weakSelf.imageView.transform = CGAffineTransform.init(rotationAngle: CGFloat(-Double.pi / 2))
            }
        }

    }
    
    override func cv_setHighlightState(animation: Bool) {
        
        super.cv_setHighlightState(animation: animation)
        self.imageView.transform = CGAffineTransform.identity
        self.titleLabel.textColor = self.highlightColor ?? self.textColor
        let duration = animation ? 0.3 : 0.0
        UIView.animate(withDuration: duration) { [weak self] in
            if let weakSelf = self {
                weakSelf.imageView.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi / 2))
            }
        }
    }
    
}
