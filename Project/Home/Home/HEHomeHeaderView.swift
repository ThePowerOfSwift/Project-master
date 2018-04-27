//
//  HEHomeHeaderView.swift
//  Project
//
//  Created by fumubang on 2018/4/15.
//  Copyright © 2018年 com.weixhe. All rights reserved.
//

import UIKit

class HEHomeHeaderView: UIView {

    let banner: HECycleScrollView!
    override init(frame: CGRect) {
        self.banner = HECycleScrollView()
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 180)
        self.addSubview(self.banner)
        self.banner.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        DispatchQueue.main.delay(3) {
//            self.banner.autoScrollTimeInterval = 1;
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
