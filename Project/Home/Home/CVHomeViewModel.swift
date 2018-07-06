//
//  CVHomeViewModel.swift
//  Project
//
//  Created by caven on 2018/4/14.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import Foundation
import HandyJSON

class CVHomeViewModel {
    
    lazy var dataSource = [CVHomeModel]()
    lazy var banners = [CVCycleScrollModel]()
    
    let originJson = "[{\"text\":\"text\",\"num\":1},{\"text\":\"text\",\"num\":97},{\"text\":\"text\",\"num\":99},{\"text\":\"text\",\"num\":8},{\"text\":\"text\",\"num\":82}]"
    
    func loadData(finish:@escaping ([CVHomeModel])->()) {
        var array = [CVHomeModel]()
        for _ in 1...5 {
            let m = CVHomeModel()
            m.text = "text"
            m.number = Int(COM.arc4random(max: 100))
            array.append(m)
        }
        
        let json = array.toJSONString()
        
        cv_delay(1) { [unowned self] in
            self.dataSource = JSONDeserializer<CVHomeModel>.deserializeModelArrayFrom(json: json)! as! [CVHomeModel]
            finish(self.dataSource)
            
        }
    }
    
    func loadMoreData(finish:@escaping ([CVHomeModel], Bool)->()) {
        
        
        cv_delay(1) { [unowned self] in
            
            if self.dataSource.count > 15 {
                finish(self.dataSource, true)
                return
            }
            
            var array = [CVHomeModel]()
            for _ in 1...5 {
                let m = CVHomeModel()
                m.text = "text"
                m.number = Int(COM.arc4random(max: 100))
                array.append(m)
            }
            let json = array.toJSONString()
            self.dataSource += JSONDeserializer<CVHomeModel>.deserializeModelArrayFrom(json: json)! as! [CVHomeModel]
            finish(self.dataSource, false)
        }
    }
    
    func loadBanner(finish: @escaping ([CVCycleScrollModel], Bool) -> ()) {
        cv_delay(1) { [unowned self] in
            let imagesURLStrings = [
                "http://www.g-photography.net/file_picture/3/3587/4.jpg",
                "http://img2.zjolcdn.com/pic/0/13/66/56/13665652_914292.jpg",
                "http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg",
                "http://img3.redocn.com/tupian/20150806/weimeisheyingtupian_4779232.jpg",
                ];
            
            var arr = [CVHomeBannerModel]()
            for i in 0..<imagesURLStrings.count {
                let m = CVHomeBannerModel()
                m.id = i + 5
                m.url = imagesURLStrings[i]
                m.title = "我阿斯顿发了；就啊；是的发生；附加费；  空间很渴望和宽容和痛苦玩儿v比如去；上课你看；来上课了的烦恼爱的色放开机按键ad斯洛伐克的酸辣粉阿斯顿发了可能阿斯顿发顺丰阿斯蒂芬挨个如果我二哥发过阿达儿去玩儿阿萨德"

                m.font = UIFont.systemFont(ofSize: CGFloat(COM.arc4random(max: 4) + 12))
                m.textColor = UIColor.randomColor
                m.numberOfLines = Int(COM.arc4random(max: 5))
                arr.append(m)
            }
            
            let json = arr.toJSONString()
            self.banners = JSONDeserializer<CVHomeBannerModel>.deserializeModelArrayFrom(json: json)! as! [CVHomeBannerModel]
            finish(self.banners, true)
        }
    }
}
