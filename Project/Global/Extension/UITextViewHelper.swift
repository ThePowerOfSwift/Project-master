//
//  UITextViewHelper.swift
//  UITextViewHelper
//
//  Created by caven on 2018/3/1.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import Foundation
import UIKit

public extension UITextView {
    
    public func numberOfLines() -> Int {
        if self.text.count == 0 { return 0 }
        
        let text = self.text as NSString
        let textAttributes = [NSAttributedStringKey.font: self.font!]
        var width: CGFloat = UIEdgeInsetsInsetRect(self.frame, self.textContainerInset).width
        width -= 2.0 * self.textContainer.lineFragmentPadding
        let boundingRect: CGRect = text.boundingRect(with: CGSize(width:width,height:9999), options: [NSStringDrawingOptions.usesLineFragmentOrigin , NSStringDrawingOptions.usesFontLeading], attributes: textAttributes, context: nil)
        let line = boundingRect.height / self.font!.lineHeight
        if line < 1.0 { return 1 }
        return abs(Int(line))
    }
}
