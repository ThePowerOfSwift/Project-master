//
//  CVClipPhotoViewController.swift
//  Project
//
//  Created by caven on 2018/7/18.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit
import Photos

fileprivate let screen_width: CGFloat = UIScreen.main.bounds.width
fileprivate let screen_height: CGFloat = UIScreen.main.bounds.height
fileprivate let mask_border_width: CGFloat = 1
fileprivate let mask_border_color: UIColor = UIColor(red: 34 / 255.0, green: 34 / 255.0, blue: 34 / 255.0, alpha: 1)
fileprivate let min_crop_area: CGFloat = 50  // 裁切区域最少有50px
struct CVMargin {
    var top: CGFloat
    var left: CGFloat
    var bottom: CGFloat
    var right: CGFloat
    
    static let zero: CVMargin = CVMarginMake(0, 0, 0, 0)
    var isZero: Bool {
        get {
            return self.isEqualTo(CVMargin.zero)
        }
    }
    func isEqualTo(_ margin: CVMargin) -> Bool {
        if self.top == margin.top && self.left == margin.left && self.bottom == margin.bottom && self.right == margin.right {
            return true
        }
        return false
    }
}

func CVMarginMake(_ top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat) -> CVMargin {
     return CVMargin(top: top, left: left, bottom: bottom, right: right)
}


/// 激活手势的方式: 拖动的是image 或者是 crop的边框
enum CVCropDragType {
    case left
    case right
    case top
    case bottom
    case image
    case none
}

typealias CVClipPhotoClosure = ((_ image: UIImage)->())

/**
 *   @brief 切图
 */
class CVClipPhotoViewController: CVBaseViewController {

    /* 公有属性 */
    var assets: PHAsset?
    var cropX: CGFloat = 0
    var cropY: CGFloat = (screen_height - screen_width / 2) / 2
    var cropWidth: CGFloat = screen_width {
        didSet {
            if self.cropWidth < min_crop_area {
                if self.dragType == .left {
                    self.cropX -= min_crop_area - self.cropWidth
                }
                self.cropWidth = min_crop_area
            }
        }
    }
    var cropHeight: CGFloat = screen_width / 2 {
        didSet {
            if self.cropHeight < min_crop_area {
                if self.dragType == .top {
                    self.cropY -= min_crop_area - self.cropHeight
                }
                self.cropHeight = min_crop_area
            }
        }
    }
    
    var margin: CVMargin = CVMarginMake(15, 0, 15, 0)   // 设置crop的范围
    
    var clipPhoto: CVClipPhotoClosure?      // 剪切图片的结果
    
    
    /* 私有属性 */
    private var sourceImage: UIImage!
    private var imageView: UIImageView!
    private var mask: UIView!
    private var originFrame: CGRect = CGRect.zero
    private var dragType: CVCropDragType = .none

    /* 父类方法 */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        self.cv_navigationBar?.isHidden = true
        
        if self.assets == nil {
            return
        }
        
        self.imageView = UIImageView(frame: CGRect.zero)
        self.imageView.contentMode = .scaleAspectFit
        self.view.addSubview(self.imageView)
        
        self.setMaskView()      // 遮罩
        self.setBottomView()    // 底部工具栏
        self.addGesture()
        
        
        CVPhotoManager.requestImageData(asset: self.assets!) { [weak self] (data, info) in
            guard let strongSelf = self else { return }
            
            strongSelf.sourceImage = UIImage(data: data)!.fixOrientation()
            strongSelf.imageView.image = strongSelf.sourceImage
            strongSelf.resetFrame()
            // 记录初始的数据
            strongSelf.originFrame = strongSelf.imageView.frame
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - 私有方法 Private Methods
fileprivate extension CVClipPhotoViewController {
    /// 重置 子视图的frame
    func resetFrame() {
        guard self.sourceImage != nil else { return }
        let image = self.sourceImage!
        var tempWidth: CGFloat = 0, tempHeight: CGFloat = 0
        
        tempWidth = screen_width
        tempHeight = (tempWidth / image.size.width) * image.size.height

        let x: CGFloat = 0
        let y: CGFloat = self.cropY - (tempHeight - self.cropHeight) / 2
        self.imageView.frame = CGRect(x: x, y: y, width: tempWidth, height: tempHeight)
        
        /* 这里的算法会让图片受限于cropView
        self.imageView.center = CGPoint(x: self.cropX + self.cropWidth / 2, y: self.self.cropY + self.self.cropHeight / 2)
        if image.size.width / self.cropWidth <= image.size.height / self.cropHeight {
            tempWidth = self.cropWidth
            tempHeight = (tempWidth / image.size.width) * image.size.height
        } else {
            tempHeight = self.cropHeight
            tempWidth = (tempHeight / image.size.height) * image.size.width
        }

        let x = self.cropX - (tempWidth - self.cropWidth) / 2
        let y = self.cropY - (tempHeight - self.cropHeight) / 2
        self.imageView.frame = CGRect(x: x, y: y, width: tempWidth, height: tempHeight)
         */
    }
    
    /// 设置遮罩，展示切图部分
    func setMaskView() {
        self.mask = UIView(frame: self.view.bounds)
        self.view.addSubview(self.mask)
        self.addClopLayer()
    }
    /// 在mask上添加layer，展示裁切的边框
    func addClopLayer() {
        self.mask.layer.sublayers = nil
        
        let clipFrame = CGRect(x: self.cropX, y: self.cropY, width: self.cropWidth, height: self.cropHeight)
        let path = UIBezierPath(roundedRect: self.mask.frame, cornerRadius: 0)
        let rect_bezier = UIBezierPath(rect: clipFrame)
        path.append(rect_bezier)
        
        let shapeLayer = CVClipRectLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillRule = kCAFillRuleEvenOdd;
        shapeLayer.fillColor = UIColor.black.cgColor
        shapeLayer.opacity = 0.5
        shapeLayer.frame = self.mask.bounds
        shapeLayer.setLeft(self.cropX, top: self.cropY, right: self.cropX + self.cropWidth, bottom: self.cropY + self.cropHeight)
        
        self.mask.layer.addSublayer(shapeLayer)
    }
    
    /// 设置底部的按钮
    func setBottomView() {
        let bottomView = UIView(frame: CGRect(x: 0, y: screen_height - cv_safeAreaInsets.bottom - 60, width: screen_width, height: 60))
        bottomView.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        self.view.addSubview(bottomView)
        
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.setTitle(LS(key: "Cancel", comment: "取消"), for: .normal)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        cancelBtn.setTitleColor(UIColor.white, for: .normal)
        cancelBtn.frame = CGRect(x: 0, y: 0, width: 80, height: 60)
        cancelBtn.addTarget(self, action: #selector(onClickCancelAction(button:)), for: .touchUpInside)
        bottomView.addSubview(cancelBtn)
        
        let doneBtn = UIButton(type: .custom)
        doneBtn.setTitle(LS(key: "Choose", comment: "选取"), for: .normal)
        doneBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        doneBtn.setTitleColor(UIColor.white, for: .normal)
        doneBtn.frame = CGRect(x: screen_width - 80, y: 0, width: 80, height: 60)
        doneBtn.addTarget(self, action: #selector(onClickDoneAction(button:)), for: .touchUpInside)
        bottomView.addSubview(doneBtn)
    }
    
    /// 添加手势
    func addGesture() {
        self.view.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(handleCenterPinGesture(pinGesture:))))
        self.view.addGestureRecognizer(CVPanGestureRecognizer(target: self, action: #selector(handleDynamicPanGesture(panGesture:)), super: self.view))
    }
    
    /// 截图功能
    func cropImage() -> UIImage {
        guard self.sourceImage != nil else {
            return UIImage()
        }
        let imageScale: CGFloat = min(self.imageView.frame.width / self.sourceImage.size.width, self.imageView.frame.height / self.sourceImage.size.height)
        let cropX: CGFloat = (self.cropX - self.imageView.frame.origin.x) / imageScale
        let cropY: CGFloat = (self.cropY - self.imageView.frame.origin.y) / imageScale
        let cropWidth: CGFloat = self.cropWidth / imageScale
        let cropHeight: CGFloat = self.cropHeight / imageScale
        let cropRect: CGRect = CGRect(x: cropX, y: cropY, width: cropWidth, height: cropHeight)
        
        let newImage: UIImage = UIImage(cgImage: self.sourceImage!.cgImage!.cropping(to: cropRect)!)
        return newImage
    }
    
    // MARK: - Actions
    /// 事件 - 点击【取消】按钮
    @objc func onClickCancelAction(button: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /// 事件 - 点击【完成】按钮
    @objc func onClickDoneAction(button: UIButton) {
        let image = self.cropImage()
        if self.clipPhoto != nil {
            self.clipPhoto!(image)
        }
        
        if self.presentingViewController != nil {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    /// 事件 - 放缩手势
    @objc func handleCenterPinGesture(pinGesture: UIPinchGestureRecognizer) {
        let scaleRation: CGFloat = 3
        // 放缩开始与放缩中
        if pinGesture.state == .began || pinGesture.state == .changed {
            let pinchCenter: CGPoint = pinGesture.location(in: self.view)  // 两个手指的中心点
            let distanceX = (self.imageView.frame.origin.x - pinchCenter.x) * (pinGesture.scale - 1)
            let distanceY = (self.imageView.frame.origin.y - pinchCenter.y) * (pinGesture.scale - 1)
            let newFrame = CGRect(x: self.imageView.frame.origin.x + distanceX, y: self.imageView.frame.origin.y + distanceY, width: self.imageView.frame.width * pinGesture.scale, height: self.imageView.frame.height * pinGesture.scale)
            self.imageView.frame = newFrame
            pinGesture.scale = 1
        }
        
        // 放缩结束
        if pinGesture.state == .ended {
            let ration: CGFloat =  self.imageView.frame.size.width / self.originFrame.size.width

            // 缩放过大
            if (ration > 5) {
                let newFrame = CGRect(x: 0, y: 0, width: self.originFrame.size.width * scaleRation, height: self.originFrame.size.height * scaleRation)
                self.imageView.frame = newFrame
            }

            // 缩放过小
            if (ration < 0.25) {
                self.imageView.frame = self.originFrame
            }

            // 对图片进行位置修正
            var resetPosition = self.imageView.frame

            if (resetPosition.origin.x >= self.cropX) {
                resetPosition.origin.x = self.cropX
            }
            if (resetPosition.origin.y >= self.cropY) {
                resetPosition.origin.y = self.cropY
            }
            if (resetPosition.size.width + resetPosition.origin.x < self.cropX + self.cropWidth) {
                let movedLeftX = fabs(resetPosition.size.width + resetPosition.origin.x - (self.cropX + self.cropWidth))
                resetPosition.origin.x += movedLeftX
            }
            if (resetPosition.size.height + resetPosition.origin.y < self.cropY + self.cropHeight) {
                let moveUpY = fabs(resetPosition.size.height + resetPosition.origin.y - (self.cropY + self.cropHeight))
                resetPosition.origin.y += moveUpY
            }
            self.imageView.frame = resetPosition

            // 对图片缩放进行比例修正，防止过小
            if self.cropX < self.imageView.frame.origin.x
                || ((self.cropX + self.cropWidth) > self.imageView.frame.origin.x + self.imageView.frame.size.width)
                || self.cropY < self.imageView.frame.origin.y
                || ((self.cropY + self.cropHeight) > self.imageView.frame.origin.y + self.imageView.frame.size.height) {
                self.imageView.frame = self.originFrame
            }
        }
    }
    
    /// 事件 - 拖动手势
    @objc func handleDynamicPanGesture(panGesture: CVPanGestureRecognizer) {
        
        let translation = panGesture.translation(in: self.imageView.superview)
        let Ex: CGFloat = 20
        let begin = panGesture.beginPoint
        let move = panGesture.movePoint
        
        if panGesture.state == .began {
            if begin.y >= self.cropY - Ex && begin.y <= self.cropY + Ex && begin.x >= self.cropX && begin.x <= self.cropX + self.cropWidth {
                // 拖动上侧的line：触点在上侧线的左右20px内，且在crop框的宽度内
                self.dragType = .top
                
            } else if begin.x >= self.cropX - Ex && begin.x <= self.cropX + Ex && begin.y >= self.cropY && begin.y <= self.cropY + self.cropHeight {
                // 拖动左侧的line：触点在左侧线的左右20px内，且在crop框的高度内
                self.dragType = .left
                
            } else if begin.y >= self.cropY + self.cropHeight - Ex && begin.y <= self.cropY + self.cropHeight + Ex && begin.x >= self.cropX && begin.x <= self.cropX + self.cropWidth {
                // 拖动下侧的line：触点在下侧线的左右20px内，且在crop框的高度内
                self.dragType = .bottom
                
            } else if begin.x >= self.cropX + self.cropWidth - Ex && begin.x <= self.cropX + self.cropWidth + Ex && begin.y >= self.cropY && begin.y <= self.cropY + self.cropHeight {
                // 拖动右侧的line：触点在右侧线的左右20px内，且在crop框的高度内
                self.dragType = .right
                
            } else {
                // 拖动的是图片
                self.dragType = .image
                
            }
        }
        
        // 滑动过程中进行位置改变
        if panGesture.state == .changed {
            
            var diff: CGFloat = 0
            
            switch self.dragType {
            case .top:      // 上 line
                diff = move.y - self.cropY
                if diff >= 0 || diff < 0 && self.cropY >= self.imageView.frame.minY && self.cropY >= self.margin.top {
                    self.cropHeight -= diff
                    self.cropY += diff
                }
                self.addClopLayer()
            case .left:     // 左 line
                diff = move.x - self.cropX
                if diff >= 0 || diff < 0 && self.cropX > self.imageView.frame.minX && self.cropX >= self.margin.left {
                    self.cropWidth -= diff
                    self.cropX += diff
                }
                self.addClopLayer()
            case .bottom:   // 下 line
                diff = move.y - self.cropY - self.cropHeight
                let aa = min(self.imageView.frame.minY + self.imageView.frame.height, screen_height - self.margin.bottom)
                if diff >= 0 && (self.cropY + self.cropHeight) < aa {
                    self.cropHeight += diff
                } else if diff < 0 && self.cropHeight >= min_crop_area {
                    self.cropHeight += diff
                }
                self.addClopLayer()
            case .right:    // 右 line
                diff = move.x - self.cropX - self.cropWidth
                if diff >= 0 && (self.cropX + self.cropWidth) < min(self.imageView.frame.minX + self.imageView.frame.width, screen_width - self.margin.right) {
                    self.cropWidth += diff
                } else if diff < 0 && self.cropWidth >= min_crop_area {
                    self.cropWidth += diff
                }
                self.addClopLayer()
            default:        // image
                self.imageView.center = CGPoint(x: self.imageView.center.x + translation.x, y: self.imageView.center.y + translation.y)
                panGesture.setTranslation(CGPoint.zero, in: self.view)
            }
        }
        
        // 滑动结束后进行位置修正
        if panGesture.state == .ended || panGesture.state == .cancelled {
       
            switch self.dragType {
            case .top:      // 上 line

                if self.cropY < max(self.imageView.frame.minY, self.margin.top) {
                    let temp = self.cropY + self.cropHeight
                    self.cropY = max(self.imageView.frame.minY, self.margin.top)
                    self.cropHeight = temp - self.cropY
                }
                self.addClopLayer()
                
            case .left:     // 左 line

                if self.cropX < max(self.imageView.frame.minX, self.margin.left) {
                    let temp = self.cropX + self.cropWidth
                    self.cropX = max(self.imageView.frame.minX, self.margin.left)
                    self.cropWidth = temp - self.cropX
                }
                self.addClopLayer()
            case .bottom:   // 下 line

                if self.cropY + self.cropHeight > min(self.imageView.frame.minY + self.imageView.frame.height, self.mask.frame.minY + self.mask.frame.height - self.margin.bottom) {
                    self.cropHeight = min(self.imageView.frame.minY + self.imageView.frame.height, self.mask.frame.minY + self.mask.frame.height - self.margin.bottom) - self.cropY
                }
                self.addClopLayer()
            case .right:    // 右 line

                if (self.cropX + self.cropWidth > min(self.imageView.frame.minX + self.imageView.frame.width, self.mask.frame.minY + self.mask.frame.height - self.margin.right)) {
                    self.cropWidth = min(self.imageView.frame.minX + self.imageView.frame.width, self.mask.frame.minX + self.mask.frame.width - self.margin.right) - self.cropX
                }
                self.addClopLayer()
            default:        // image
                var currentFrame: CGRect = self.imageView.frame
                if currentFrame.origin.x >= self.cropX {
                    currentFrame.origin.x = self.cropX
                }
                if currentFrame.origin.y >= self.cropY {
                    currentFrame.origin.y = self.cropY
                }
                if currentFrame.size.width + currentFrame.origin.x < self.cropX + self.cropWidth {
                    let movedLeftX = fabs(currentFrame.size.width + currentFrame.origin.x - (self.cropX + self.cropWidth))
                    currentFrame.origin.x += movedLeftX
                }
                if currentFrame.size.height + currentFrame.origin.y < self.cropY + self.cropHeight {
                    let moveUpY = fabs(currentFrame.size.height + currentFrame.origin.y - (self.cropY + self.cropHeight))
                    currentFrame.origin.y += moveUpY
                }
                
                UIView.animate(withDuration: 0.3) { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.imageView.frame = currentFrame
                }
            }
            
            self.dragType = .none
        }
    }
}


// MARK: - CAShapeLayer
class CVClipRectLayer : CAShapeLayer {
    var clipLeft: CGFloat = 50
    var clipTop: CGFloat = 50
    var clipRight: CGFloat = screen_width - 50
    var clipBottom: CGFloat = 400
    
    func setLeft(_ left: CGFloat, top: CGFloat, right: CGFloat, bottom: CGFloat) {
        self.clipLeft = left
        self.clipTop = top
        self.clipRight = right
        self.clipBottom = bottom
        self.setNeedsDisplay()
    }

    override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        UIGraphicsPushContext(ctx)
        
        ctx.setStrokeColor(UIColor.white.cgColor)
        ctx.setLineWidth(2)
        
        // 绘制左侧竖线
        ctx.move(to: CGPoint(x: self.clipLeft, y: self.clipTop))
        ctx.addLine(to: CGPoint(x: self.clipLeft, y: self.clipBottom))
        ctx.setShadow(offset: CGSize(width: 2, height: 0), blur: 2)
        ctx.strokePath()
        
        // 绘制下横线
        ctx.move(to: CGPoint(x: self.clipLeft, y: self.clipBottom))
        ctx.addLine(to: CGPoint(x: self.clipRight, y: self.clipBottom))
        ctx.setShadow(offset: CGSize(width: 0, height: -2), blur: 2)
        ctx.strokePath()
        
        // 绘制右侧竖线
        ctx.move(to: CGPoint(x: self.clipRight, y: self.clipBottom))
        ctx.addLine(to: CGPoint(x: self.clipRight, y: self.clipTop))
        ctx.setShadow(offset: CGSize(width: -2, height: 0), blur: 2)
        ctx.strokePath()
        
        // 绘制上横线
        ctx.move(to: CGPoint(x: self.clipRight, y: self.clipTop))
        ctx.addLine(to: CGPoint(x: self.clipLeft, y: self.clipTop))
        ctx.setShadow(offset: CGSize(width: 0, height: 2), blur: 2)
        ctx.strokePath()
        
        UIGraphicsPopContext()
        
    }
}


// MARK: - CVPanGestureRecognizer
class CVPanGestureRecognizer : UIPanGestureRecognizer {
    var beginPoint: CGPoint = CGPoint.zero
    var movePoint: CGPoint = CGPoint.zero
    
    var targetView: UIView!
    
    init(target: Any?, action: Selector?, super: UIView) {
        super.init(target: target, action: action)
        self.targetView = `super`
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        let touch = ((touches as NSSet).anyObject() as AnyObject)   // 进行类型转化
        self.beginPoint = touch.location(in: self.targetView)       // 获取当前点击位置
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        let touch = ((touches as NSSet).anyObject() as AnyObject)   // 进行类型转化
        self.movePoint = touch.location(in: self.targetView)        // 获取当前点击位置
    }
}
