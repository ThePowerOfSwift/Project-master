//
//  UIImage+Extension.swift
//  Project
//
//  Created by caven on 2018/3/9.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import Foundation
import UIKit

public func UIImageNamed(_ name: String) -> UIImage {
    return UIImage(named: name)!
}
public extension UIImage {
    
    /// 重置image的size
    func scaleImage(reSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(reSize, false, UIScreen.main.scale);
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height));
        let reSizeImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return reSizeImage;
    }
    
    /// 按照比例放缩
    func scaleImage(scale: CGFloat) -> UIImage? {
        let reSize = CGSize(width: self.size.width * scale, height: self.size.height * scale)
        return self.scaleImage(reSize: reSize)
    }
}
