//
//  CVPickerViewReusingView.swift
//  Project
//
//  Created by caven on 2018/5/22.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit

class CVPickerViewReusingView: UIView {
    
    var textLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.textLabel = cv_label(font: UIFont.font_18, text: "", super: self)
        self.textLabel.textAlignment = .center
        self.textLabel.textColor = UIColor.black
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textLabel.frame = self.bounds
    }
}
