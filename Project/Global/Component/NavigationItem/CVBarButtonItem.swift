//
//  CVBarButtonItem.swift
//  Project
//
//  Created by caven on 2018/3/6.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit

private let kDefaultTitleSize: CGFloat = 15
private let kDefaultTitleColor: UIColor = UIColor.blue
private let kDefaultBtnHeight: CGFloat = 40

open class CVBarButtonItem: NSObject {
    // MARK: Property
    var title: String? {
        didSet { self.button!.setTitle(title, for: .normal) }
    }
    
    var highlightedTitle: String? {
        didSet { self.button!.setTitle(highlightedTitle, for: .highlighted) }
    }
    
    var image: UIImage? {
        didSet {
            if var icon = self.image {
                if icon.size.height > kDefaultBtnHeight {
                    icon = icon.scaleImage(scale: kDefaultBtnHeight / icon.size.height)!
                }
                self.imageN = icon
            } else {
                self.imageN = self.image
            }
        }
    }
   
    var highlightedImage: UIImage? {
        didSet {
            if var icon = highlightedImage {
                if icon.size.height > kDefaultBtnHeight {
                    icon = icon.scaleImage(scale: kDefaultBtnHeight / icon.size.height)!
                }
                self.imageH = icon
            } else {
                self.imageH = self.highlightedImage
            }
        }
    }
    
    var isHighlighted: Bool = false {
        didSet {
            self.button!.isHighlighted = self.isHighlighted
//            self.updateContentSpace(position: self.position, space: space)
        }
    }
    
    private var space: CGFloat = 0 // title 和 image 之间 的距离
    private var imageN: UIImage? { didSet { self.button!.setImage(self.imageN, for: .normal) } }
    private var imageH: UIImage? { didSet { self.button!.setImage(self.imageH, for: .highlighted) } }

    private(set) var button: UIButton? = {
        let button = UIButton(type: UIButtonType.custom)
        button.backgroundColor = UIColor.clear
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.titleLabel?.font = UIFont.systemFont(ofSize: kDefaultTitleSize)
        button.setTitleColor(kDefaultTitleColor, for: .normal)
        return button
    }()
    public var customView: UIView?
    
    // MARK: Init
    class func item(title: String, highlightedTitle: String?, target: Any?, action: Selector?) -> CVBarButtonItem {
        let item = CVBarButtonItem()
        item.title = title
        item.highlightedTitle = highlightedTitle
        item.addAction(target, action)
        item.updateFrame()
        return item
    }
    
    class func item(title: String, target: Any?, action: Selector?) -> CVBarButtonItem {
        return self.item(title: title, highlightedTitle: nil, target: target, action: action)
    }
    
    class func item(image: UIImage, highlightedImage: UIImage?, target: Any?, action: Selector?) -> CVBarButtonItem {
        let item = CVBarButtonItem()
        item.image = image
        item.highlightedImage = highlightedImage
        item.addAction(target, action)
        item.updateFrame()
        return item
    }
    
    class func item(image: UIImage, target: Any?, action: Selector?) -> CVBarButtonItem {
        return self.item(image: image, highlightedImage: nil, target: target, action: action)
    }
    
    class func item(title: String, image: UIImage, target: Any?, action: Selector?) -> CVBarButtonItem {
        let item = CVBarButtonItem()
        item.title = title
        item.image = image
        item.addAction(target, action)
        item.updateFrame()
        return item
    }
    
    // MARK: Method
    
    private func addAction(_ target: Any?, _ action: Selector?) {
        if action != nil {
            self.button!.addTarget(target, action: action!, for: .touchUpInside)
        } else {
            self.button!.addTarget(target, action: #selector(he_test_null_action), for: .touchUpInside)
        }
    }
    @objc private func he_test_null_action() {}
    
    private func updateFrame() -> Void {
        
        let height: CGFloat = kDefaultBtnHeight
        let currentTitle: String? = self.isHighlighted ? self.highlightedTitle : self.title
        let currentImage: UIImage? = self.isHighlighted ? self.imageH : self.imageN

        var titleW: CGFloat = 0.0
        if let text = currentTitle {
            titleW = text.autoWidth(font: self.button!.titleLabel!.font, fixedHeight: height)
        }
        
        var imageW: CGFloat = 0
        if let img = currentImage {
            imageW = img.size.width
        }
        
        let btnWigth = titleW + imageW + self.space
        self.button!.frame = CGRect(x: 0, y: 0, width: max(btnWigth, height), height: height)
        if self.button!.superview != nil {
            self.button!.center = CGPoint(x: self.button!.center.x, y: kDefaultBarCenterY)
        }
    }
    
//    public func updateContentSpace(position: UIButtonImagePosition, space: CGFloat) {
//        
//        self.updateFrame()
//    }
}



