//
//  CVPageTabMaskView.swift
//  Project
//
//  Created by caven on 2018/5/25.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit

class CVPageTabMaskView: UIView {

    var line: UIView?
    var ratio: CGFloat = 1
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    convenience init(lineRatio: CGFloat = 1) {
        self.init(frame: CGRect.zero)
        self.line = cv_view(frame: CGRect.zero, color: UIColor.red, super: self)
        self.ratio = lineRatio
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.line?.frame = CGRectMake(0, self.height - 2, self.width * self.ratio, 2)
        self.line?.centerX = self.width / 2
    }

}
