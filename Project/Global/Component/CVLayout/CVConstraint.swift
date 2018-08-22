//
//  CVConstraint.swift
//  Project
//
//  Created by caven on 2018/8/21.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import Foundation

enum CVAttributeItem : Int {
    case top
    case left
    case bottom
    case right
    case width
    case height
    case centerX
    case centerY
    case center
}


class CVConstraint : NSObject {
    
    internal var view: UIView
    internal var attribute: CVAttributeItem
    internal var constraint: CGFloat = 0     // 只对宽，高有效
    
    init(_ view: UIView, attribute: CVAttributeItem) {
        self.view = view
        self.attribute = attribute
    }
}

class CVRelationship : NSObject {
    internal let firstItem: CVConstraint
    internal let secondItem: CVConstraint?    // 如果second为nil，则相对于父类，或者是设置 宽 和 高
    internal var offset: CGFloat = 0
    internal var multiply: CGFloat = 1       // 针对 宽、高 比例设置
    
    init(firstItem: CVConstraint, secondItem: CVConstraint?) {
        self.firstItem = firstItem
        self.secondItem = secondItem
    }
    
    func offset(_ offset: CGFloat) {
        self.offset = offset
        self.firstItem.view.cv_updateLayout()
    }
    
    func multiply(_ multiply: CGFloat) {
        if multiply <= 0 {
            return
        }
        self.multiply = multiply
        self.firstItem.view.cv_updateLayout()
    }
}

internal extension CVRelationship {
    
    // 更新约束
    func cv_updateConstraint() {
        
        let firstItem = self.firstItem
        var secondItem = self.secondItem
        
        // 设置宽高
        if secondItem == nil  {
            if firstItem.attribute == .width || firstItem.attribute == .height {
                if firstItem.attribute == .width {
                    if firstItem.view.constraint_width == nil {
                        firstItem.view.constraint_width = firstItem.constraint * self.multiply
                    }
                } else if firstItem.attribute == .height {
                    if firstItem.view.constraint_height == nil {
                        firstItem.view.constraint_height = firstItem.constraint * self.multiply
                    }
                }
            } else {
                assert(firstItem.view.superview != nil, "请先添加到父类")
                secondItem = CVConstraint.init(firstItem.view.superview!, attribute: firstItem.attribute)
            }
        }
        
        switch firstItem.attribute {
        case .left:
            guard firstItem.view.constraint_x == nil else { return }
            let leftPoint = secondItem!.view.cv_origin
            let rightPoint = CGPoint(x: secondItem!.view.cv_x + secondItem!.view.cv_width , y: secondItem!.view.cv_y)
            let relativePoint: CGPoint = secondItem!.attribute == .right ? rightPoint : leftPoint        // 查找相对的点point
            let finialPoint = secondItem!.view.convertPoint(relativePoint, toView: firstItem.view)
            firstItem.view.constraint_x = finialPoint.x + offset
            
        case .right:
            
            if firstItem.view.constraint_x == nil && firstItem.view.constraint_width == nil { return }
            if firstItem.view.constraint_x != nil && firstItem.view.constraint_width != nil { return }
            
            let leftPoint = secondItem!.view.cv_origin
            let rightPoint = CGPoint(x: secondItem!.view.cv_x + secondItem!.view.cv_width , y: secondItem!.view.cv_y)
            let relativePoint: CGPoint = secondItem!.attribute == .left ? leftPoint : rightPoint        // 查找相对的点point
            let finialPoint = secondItem!.view.convertPoint(relativePoint, toView: firstItem.view)
            if firstItem.view.constraint_x != nil {
                firstItem.view.constraint_width = max(finialPoint.x - firstItem.view.constraint_x!, 0) - offset
            } else if firstItem.view.constraint_width != nil {
                firstItem.view.constraint_x = finialPoint.x - firstItem.view.constraint_width! - offset
            }
            
        case .top:
            guard firstItem.view.constraint_y == nil else { return }
            
            let topPoint = secondItem!.view.cv_origin
            let bottomPoint = CGPoint(x: secondItem!.view.cv_x, y: secondItem!.view.cv_y + secondItem!.view.cv_height)
            let relativePoint: CGPoint = secondItem!.attribute == .bottom ? bottomPoint : topPoint     // 查找相对的点point
            let finialPoint = secondItem!.view.convertPoint(relativePoint, toView: firstItem.view)
            firstItem.view.constraint_y = finialPoint.y + offset
            
        case .bottom:
            if firstItem.view.constraint_y == nil && firstItem.view.constraint_height == nil { return }
            if firstItem.view.constraint_y != nil && firstItem.view.constraint_height != nil { return }
            
            let topPoint = secondItem!.view.cv_origin
            let bottomPoint = CGPoint(x: secondItem!.view.cv_x, y: secondItem!.view.cv_y + secondItem!.view.cv_height)
            let relativePoint: CGPoint = secondItem!.attribute == .top ? topPoint : bottomPoint     // 查找相对的点point
            let finialPoint = secondItem!.view.convertPoint(relativePoint, toView: firstItem.view)
            if firstItem.view.constraint_y != nil {
                firstItem.view.constraint_height = max(finialPoint.y - firstItem.view.constraint_y!, 0) - offset
            } else if firstItem.view.constraint_height != nil {
                firstItem.view.constraint_y = finialPoint.y - firstItem.view.constraint_height! - offset
            }
        case .centerX:
            if firstItem.view.constraint_x == nil && firstItem.view.constraint_width == nil { return }
            
            let finialPoint = secondItem!.view.convertPoint(secondItem!.view.center, toView: firstItem.view)
            if firstItem.view.constraint_x != nil {
                firstItem.view.constraint_width = abs(finialPoint.x - firstItem.view.constraint_x! + offset) * 2
            } else if firstItem.view.constraint_width != nil {
                firstItem.view.constraint_x = finialPoint.x - firstItem.view.constraint_width! / 2 + offset
            }
        case .centerY:
            if firstItem.view.constraint_y == nil && firstItem.view.constraint_height == nil { return }
            
            let finialPoint = secondItem!.view.convertPoint(secondItem!.view.center, toView: firstItem.view)
            if firstItem.view.constraint_y != nil {
                firstItem.view.constraint_height = abs(finialPoint.y - firstItem.view.constraint_y! - offset) * 2
            } else if firstItem.view.constraint_height != nil {
                firstItem.view.constraint_y = finialPoint.y - firstItem.view.constraint_height! / 2 - offset
            }
        case .center:
            if firstItem.view.constraint_x == nil && firstItem.view.constraint_width == nil { return }
            if firstItem.view.constraint_y == nil && firstItem.view.constraint_height == nil { return }
            let finialPoint = secondItem!.view.convertPoint(secondItem!.view.center, toView: firstItem.view)
            if firstItem.view.constraint_x != nil {
                firstItem.view.constraint_width = abs(finialPoint.x - firstItem.view.constraint_x! + offset) * 2
            } else if firstItem.view.constraint_width != nil {
                firstItem.view.constraint_x = finialPoint.x - firstItem.view.constraint_width! / 2 + offset
            }
            if firstItem.view.constraint_y != nil {
                firstItem.view.constraint_height = abs(finialPoint.y - firstItem.view.constraint_y! - offset) * 2
            } else if firstItem.view.constraint_height != nil {
                firstItem.view.constraint_y = finialPoint.y - firstItem.view.constraint_height! / 2 - offset
            }
        default:
            print("Others relationships...")
        }
    }
}




//func == (left: CVConstraint, right: CVConstraint) -> Bool {
//    if left.view == right.view && left.attribute == right.attribute {
//        return true
//    }
//    return false
//}

func == (left: CVRelationship, right: CVRelationship) -> Bool {
    
    let result1 = (left.firstItem.view == right.firstItem.view && left.firstItem.attribute == right.firstItem.attribute)
    let result2 = (left.secondItem?.view == right.secondItem?.view && left.secondItem?.attribute == right.secondItem?.attribute)
    
    if result1 && result2 {
        return true
    }
    return false
}

