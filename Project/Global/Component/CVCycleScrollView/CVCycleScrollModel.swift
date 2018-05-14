//
//  CVCycleScrollModel.swift
//  Project
//
//  Created by caven on 2018/4/15.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit
import HandyJSON

class CVCycleScrollModel: HandyJSON {
    var id: Int = 0
    var url: String = ""    // 网络图片
    var imageName = ""      // 本地图片
    
    var placeholder: String = "cycle_placeholder"
    
    var title: String = ""
    
    /// 文本颜色
    var textColor: UIColor = UIColor.white
    /// 文本行数
    var numberOfLines: NSInteger = 2
    /// 文本字体
    var font: UIFont = UIFont.systemFont(ofSize: 15)
    /// 文本区域背景颜色
    var titleBackgroundColor: UIColor = UIColor.black.withAlphaComponent(0.3)
    /// 文本间距
    open var titleLeading: CGFloat = 15
    
    required init() {
        
    }
    
//    func mapping(mapper: HelpingMapper) {
//        mapper.specify(property: &url) { (text) -> URL? in
//            return URL(string: text)
//        }
//    }
}
