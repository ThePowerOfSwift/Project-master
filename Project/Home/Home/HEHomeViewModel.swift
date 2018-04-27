//
//  HEHomeViewModel.swift
//  Project
//
//  Created by fumubang on 2018/4/14.
//  Copyright © 2018年 com.weixhe. All rights reserved.
//

import Foundation
import HandyJSON

class HEHomeViewModel {
    
    lazy var dataSource = [HEHomeModel]()
    lazy var banners = [HECycleScrollModel]()
    
    let originJson = "[{\"text\":\"text\",\"num\":1},{\"text\":\"text\",\"num\":97},{\"text\":\"text\",\"num\":99},{\"text\":\"text\",\"num\":8},{\"text\":\"text\",\"num\":82}]"
    
    func loadData(finish:@escaping ([HEHomeModel])->()) {
        var array = [HEHomeModel]()
        for _ in 1...5 {
            let m = HEHomeModel()
            m.text = "text"
            m.number = Int(COM.arc4random(max: 100))
            array.append(m)
        }
        
        let json = array.toJSONString()
        
        DispatchQueue.main.delay(1) {
            self.dataSource = JSONDeserializer<HEHomeModel>.deserializeModelArrayFrom(json: json)! as! [HEHomeModel]
            finish(self.dataSource)
        }
    }
    
    func loadMoreData(finish:@escaping ([HEHomeModel], Bool)->()) {
        
        
        DispatchQueue.main.delay(1) {
            
            if self.dataSource.count > 15 {
                finish(self.dataSource, true)
                return
            }
            
            var array = [HEHomeModel]()
            for _ in 1...5 {
                let m = HEHomeModel()
                m.text = "text"
                m.number = Int(COM.arc4random(max: 100))
                array.append(m)
            }
            let json = array.toJSONString()
            self.dataSource += JSONDeserializer<HEHomeModel>.deserializeModelArrayFrom(json: json)! as! [HEHomeModel]
            finish(self.dataSource, false)
        }
    }
    
    func loadBanner(finish: @escaping ([HECycleScrollModel], Bool) -> ()) {
        DispatchQueue.main.delay(1) {
            let imagesURLStrings = [
                "http://www.g-photography.net/file_picture/3/3587/4.jpg",
                "http://img2.zjolcdn.com/pic/0/13/66/56/13665652_914292.jpg",
                "http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg",
                "http://img3.redocn.com/tupian/20150806/weimeisheyingtupian_4779232.jpg",
                ];
            
            var arr = [HEHomeBannerModel]()
            for i in 0..<imagesURLStrings.count {
                let m = HEHomeBannerModel()
                m.id = i + 5
                m.url = imagesURLStrings[i]
                m.title = "我阿斯顿发了；就啊；是的发生；附加费；  空间很渴望和宽容和痛苦玩儿v比如去；上课你看；来上课了的烦恼爱的色放开机按键ad斯洛伐克的酸辣粉阿斯顿发了可能阿斯顿发顺丰阿斯蒂芬挨个如果我二哥发过阿达儿去玩儿阿萨德"

                m.font = UIFont.systemFont(ofSize: CGFloat(COM.arc4random(max: 4) + 12))
                m.textColor = UIColor.randomColor
                m.numberOfLines = Int(COM.arc4random(max: 5))
                arr.append(m)
            }
            
            let json = arr.toJSONString()
            self.banners = JSONDeserializer<HEHomeBannerModel>.deserializeModelArrayFrom(json: json)! as! [HEHomeBannerModel]
            finish(self.banners, true)
        }
    }
}
