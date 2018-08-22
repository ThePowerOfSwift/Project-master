//
//  UILabel+Layout.swift
//  Project
//
//  Created by caven on 2018/8/21.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import Foundation

extension UILabel {
   
    func autoHeight() {
        guard self.constraint_width != nil else { return }
        var autoHeight: CGFloat = 0
        if let text = self.text, !text.isEmpty {
            let size = CGSize(width: self.constraint_width!, height:0)
            let rect = text.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedStringKey.font : font], context: nil)
            autoHeight = rect.size.height
        }
        self.cv_heightEqualTo(autoHeight)
    }
    
    override func cv_updateLayout() {
        super.cv_updateLayout()
    }
    
}
