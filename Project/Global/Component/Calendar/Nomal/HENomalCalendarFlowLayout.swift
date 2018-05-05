//
//  HENomalCalendarFlowLayout.swift
//  Project
//
//  Created by weixhe on 2018/5/4.
//  Copyright © 2018年 com.weixhe. All rights reserved.
//

import UIKit

class HENomalCalendarFlowLayout: UICollectionViewFlowLayout {

    override init() {
        super.init()
        
        let screen = UIScreen.main.bounds.width
        
        // 头部年月视图的大小
        self.headerReferenceSize = CGSize(width: screen, height: 75)
        // 每个Cell大小 -1是用作1个像素的间距
        self.itemSize = CGSize(width: screen / 7 - 1, height: screen / 7)
        // 每行的最小间距
        self.minimumLineSpacing = 1;
        // 每列的最小间距，设置Cell的大小已经留出1个像素大小，所以此处设置0即可
        self.minimumInteritemSpacing = 0;
        // CollectionView视图的/上/左/下/右,的边距
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
