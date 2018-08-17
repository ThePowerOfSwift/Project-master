//
//  CVBigPhotoViewController.swift
//  Project
//
//  Created by caven on 2018/7/18.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit
import Photos

/// 图片之间的间隔
fileprivate let cellMargin: CGFloat = 20

typealias CVBigPhotoSelectedClosure = ((_ index: Int, _ isSelected: Bool)->())

/**
 *   @brief 展示大图
 */
class CVBigPhotoViewController: CVBaseViewController {

    /* 公有属性 */
    var currentIndex: Int! = 0          // 当前显示的index
    var selectedAssets: [PHAsset]?      // 存储选中的asset
    var selectedClosure: CVBigPhotoSelectedClosure?
    var maxSelected: UInt = 0           // 最多选多少张，多选时使用，当值为0时，不做上限
    var assets: [PHAsset]? = [] { // 数据源1. 相册中的资源，需要再次获取图片
        didSet {
            self.total = self.assets?.count ?? 0
        }
    }
    var images: [UIImage]? = [] {
        didSet {
            self.total = self.images?.count ?? 0
        }
    }
    
    /* 私有属性 */
    fileprivate var numberLabel: UILabel!
    fileprivate var collectionView: UICollectionView!
    fileprivate var cacheImageNames: [String] = []
    fileprivate var total: Int = 0
    fileprivate var rightItem: CVBarButtonItem!
    
    /* 父类方法 */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cleanCache()
        self.title = LS(self, key: "Look Photo", comment: "浏览大图")
        
        self.setup()
        self.collectionView.scrollToItem(at: IndexPath(item: self.currentIndex, section: 0), at: .left, animated: false)
        self.updateIndicateText()  // 更新指示文字
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    deinit {
        self.cleanCache()
    }
}

// MARK: - 私有方法
fileprivate extension CVBigPhotoViewController {
    func setup() {
        
        let layout = CVBigPhotoFlowLayout()
        layout.distanceBetweenPages = cellMargin
        
        self.collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT), collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.isPagingEnabled = true
        self.collectionView.register(CVBigPhotoCell.self, forCellWithReuseIdentifier: "CVBigPhotoCell")

        self.view.addSubview(self.collectionView)
        
        self.numberLabel = UILabel(frame: CGRect(x: 0, y: SCREEN_HEIGHT - 50, width: SCREEN_WIDTH, height: 30))
        self.numberLabel.textColor = UIColor.white
        self.numberLabel.font = UIFont.systemFont(ofSize: 13)
        self.numberLabel.textAlignment = .center
        self.view.addSubview(self.numberLabel)
        
        let bundle = Bundle(path: Bundle.main.path(forResource: "CVPhoto", ofType: "bundle")!)!
        let normal = bundle.cv_path(forResource: "btn_unselected", ofType: "png")
        let highlight = bundle.cv_path(forResource: "btn_selected", ofType: "png")
        if normal != nil, highlight != nil {
            self.rightItem = CVBarButtonItem.item(image: UIImage(contentsOfFile: normal!)!, target: self, action: #selector(onSelectedPhotoAction(_:)))
            self.cv_navigationBar?.rightBarButtonItem = self.rightItem
            self.rightItem.button?.setImage(UIImage(contentsOfFile: highlight!)!, for: .selected)
            
            let asset = self.assets?[self.currentIndex]
            if (self.selectedAssets?.contains(asset!))! {
                self.rightItem.button?.isSelected = true
            } else {
                self.rightItem.button?.isSelected = false
            }
        }
    }
    
    /// 更新指示文字
    func updateIndicateText() {
        let currIndex = Int(self.currentIndex) + 1
        self.numberLabel.text = "\(currIndex)/\(self.total)"
    }
    
    // MARK: - Actions
    @objc func onSelectedPhotoAction(_ button: UIButton) {
        
        func imageAnimation() -> CAKeyframeAnimation {
            let animation = CAKeyframeAnimation(keyPath: "transform")
            animation.duration = 0.3
            animation.isRemovedOnCompletion = true
            animation.fillMode = kCAFillModeBackwards
            
            animation.values = [NSValue.init(caTransform3D: CATransform3DMakeScale(0.7, 0.7, 1.0)),
                                NSValue.init(caTransform3D: CATransform3DMakeScale(1.2, 1.2, 1.0)),
                                NSValue.init(caTransform3D: CATransform3DMakeScale(0.8, 0.8, 1.0)),
                                NSValue.init(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0))]
            return animation
        }

        if button.isSelected {  // 如果是选中，则直接取消
            button.isSelected = false
            let asset = self.assets?[self.currentIndex]
            if (self.selectedAssets?.contains(asset!))! {
                self.selectedAssets?.remove(asset!)
                self.selectedClosure?(self.currentIndex, false)
            }
        } else {  // 如果是未选中，则需要判断是否已达到最大量
            if self.maxSelected > 0 && (self.selectedAssets?.count)! >= Int(self.maxSelected) {
                CVHUD.showMessageHUD(message: "已达到选择最大值")
                return
            }
            button.isSelected = true
            button.layer.add(imageAnimation(), forKey: nil)
            let asset = self.assets?[self.currentIndex]
            if !(self.selectedAssets?.contains(asset!))! {
                self.selectedAssets?.append(asset!)
                self.selectedClosure?(self.currentIndex, true)
            }
        }
    }
    
    // MARK: - 缓存
    /// 将图片写到cache文件夹中
    func writeImageToCache(image: UIImage, indexPath: IndexPath) {
        DispatchQueue.global().async {
            // 命名规则，图片的位置
            let fileName = "\(indexPath.section)_\(indexPath.item).png"
            let path = CVCachesPath + "/CVPhoto/CVBigPhoto"
            // 先查看是否存在，如果不存在，添加到cache中
            if !self.cacheImageNames.contains(fileName) {
                let imageData = UIImagePNGRepresentation(image)
                CVFileHandle.createFileAtPath(fileName: fileName, contents: imageData, filePath: path)
                self.cacheImageNames.append(fileName);
            }
        }
    }
    
    /// 从cache中读取图片
    func readImageFromCache(indexPath: IndexPath) -> UIImage? {
        // 命名规则，图片的位置
        let fileName = "\(indexPath.section)_\(indexPath.item).png"
        let path = CVCachesPath + "/CVPhoto/CVBigPhoto/"
        // 先查看是否存在，如果存在，返回image，如果不存在，返回nil
        if self.cacheImageNames.contains(fileName) {
            return UIImage(contentsOfFile: path + fileName)
        }
        return nil
    }
    
    /// 清空cache中的图片缓存
    func cleanCache() {
        let path = CVCachesPath + "/CVPhoto/CVBigPhoto"
        CVFileHandle.removeFile(atPath: path)
        self.cacheImageNames.removeAll()
    }
}

// MARK: - UICollectionView 代理 和 数据源
extension CVBigPhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.total
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CVBigPhotoCell", for: indexPath) as! CVBigPhotoCell
        
        let cacheImage = self.readImageFromCache(indexPath: indexPath)
        cell.image = cacheImage
        if cacheImage == nil {
            CVPhotoManager.requestImage(asset: self.assets![indexPath.item]) { (image, info) in
                cell.image = image
                self.writeImageToCache(image: image, indexPath: indexPath)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.currentIndex = self.collectionView.indexPathsForVisibleItems.first?.row
        
        let asset = self.assets?[self.currentIndex]
        if (self.selectedAssets?.contains(asset!))! {
            self.rightItem.button?.isSelected = true
        } else {
            self.rightItem.button?.isSelected = false
        }
    }
    
    /// 点击了item
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.updateIndicateText()
    }
}

// MARK: - 大图显示的cell
class CVBigPhotoCell: UICollectionViewCell {
    
    /* 公有属性 */
    var image: UIImage? {
        didSet {
            self.imageView.image = image
            self.resetFrame()
        }
    }
    
    /* 私有属性 */
    private var imageView: UIImageView!
    private var scrollView: UIScrollView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        self.scrollView.delegate = self
        self.scrollView.maximumZoomScale = 2.0;
        self.scrollView.minimumZoomScale = 1.0;
        self.scrollView.backgroundColor = UIColor.black
        self.addSubview(self.scrollView)
        
        
        self.imageView = UIImageView(frame: self.bounds)
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.isUserInteractionEnabled = true
        self.scrollView.addSubview(self.imageView)
        
        let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(onSingleTap(_:)))
        singleTap.numberOfTapsRequired = 1
        
        let doubleTap = UITapGestureRecognizer.init(target: self, action: #selector(onDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        singleTap.require(toFail: doubleTap)
        
        self.scrollView.addGestureRecognizer(singleTap)
        self.imageView.addGestureRecognizer(doubleTap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - CVBigPhotoCell 的 私有方法
fileprivate extension CVBigPhotoCell {
    
    /// 重置 子视图的frame
    func resetFrame() {
        guard self.image != nil else { return }
        let image = self.image!
        let tempWidth = SCREEN_WIDTH
        let tempHeight = (tempWidth / image.size.width) * image.size.height
        let x = (SCREEN_WIDTH - tempWidth) / 2
        let y = (SCREEN_HEIGHT - tempHeight) / 2
        self.imageView.frame = CGRect(x: x, y: y, width: tempWidth, height: tempHeight)
    }
    
    // MARK: - Actions
    /// 事件 - 单击
    @objc func onSingleTap(_ sender: UITapGestureRecognizer) {
        self.viewController()?.cv_navigationBar?.isHidden = !(self.viewController()?.cv_navigationBar?.isHidden)!
    }
    
    /// 事件 - 双击
    @objc func onDoubleTap(_ sender: UITapGestureRecognizer) {
        
        let zoomView = self.viewForZooming(in: self.scrollView)!
        let point = sender.location(in: zoomView)

        var scale: CGFloat = 1
        if (scrollView.zoomScale != 2.0) {
            scale = 2.0
        } else {
            scale = 1.0
        }
        
        var zoomRect: CGRect = CGRect.zero
        zoomRect.size.height = self.scrollView.frame.size.height / scale
        zoomRect.size.width  = self.scrollView.frame.size.width  / scale
        zoomRect.origin.x    = point.x - (zoomRect.size.width  / 2.0)
        zoomRect.origin.y    = point.y - (zoomRect.size.height / 2.0)
        self.scrollView.zoom(to: zoomRect, animated: true)
    }
}

// MARK: - CVBigPhotoCell 的 scrollView 代理
extension CVBigPhotoCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 0.2, animations: {
            let offsetX = (scrollView.frame.width > scrollView.contentSize.width) ? (scrollView.frame.width - scrollView.contentSize.width) * 0.5 : 0.0
            let offsetY = (scrollView.frame.height > scrollView.contentSize.height) ? (scrollView.frame.height - scrollView.contentSize.height) * 0.5 : 0.0
            self.imageView.center = CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height * 0.5 + offsetY)
        })
    }
}

