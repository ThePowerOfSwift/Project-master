//
//  CVHomeHeaderView.swift
//  Project
//
//  Created by caven on 2018/4/15.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit

class CVHomeHeaderView: UIView {

    let banner: CVCycleScrollView!
    override init(frame: CGRect) {
        self.banner = CVCycleScrollView()
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 180)
        self.addSubview(self.banner)
        self.banner.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
