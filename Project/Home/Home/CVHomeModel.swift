//
//  CVHomeModel.swift
//  Project
//
//  Created by caven on 2018/4/9.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import Foundation
import HandyJSON

class CVHomeModel: HandyJSON {
    var text: String? = ""
    var number: Int? = 0
    
    
    required init() {
        
    }
    
    // 处理本地和服务器字段不一致
    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &number, name: "num")
    }

}

class CVHomeBannerModel: CVCycleScrollModel {
    
}


