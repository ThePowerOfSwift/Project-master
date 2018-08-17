//
//  CVBigPhotoFlowLayout.swift
//  Project
//
//  Created by caven on 2018/8/13.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit

class CVBigPhotoFlowLayout: UICollectionViewFlowLayout {

    var distanceBetweenPages: CGFloat = 0
    
    override func prepare() {
        super.prepare()
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
        self.scrollDirection = .horizontal
        let size = self.collectionView?.bounds.size
        self.itemSize = CGSize(width: (size?.width)!, height: (size?.height)!)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttriArray = super.layoutAttributesForElements(in: rect)
        let centerX = (self.collectionView?.contentOffset.x)! + (self.collectionView?.bounds.size.width)! / 2
        
        guard layoutAttriArray != nil else { return nil }
        
        var min = CGFloat.greatestFiniteMagnitude
        var minIdx: Int = 0
        for (index, oneAttri) in layoutAttriArray!.enumerated() {
            if abs(centerX - oneAttri.center.x) < min {
                min = abs(centerX - oneAttri.center.x)
                minIdx = index
            }
        }
        
        for (index, oneAttri) in layoutAttriArray!.enumerated() {
            
            if minIdx - 1 == index {
                oneAttri.center = CGPoint(x: oneAttri.center.x - self.distanceBetweenPages, y: oneAttri.center.y)
            }
            if minIdx + 1 == index {
                oneAttri.center = CGPoint(x: oneAttri.center.x + self.distanceBetweenPages, y: oneAttri.center.y)
            }
        }
        return layoutAttriArray
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
