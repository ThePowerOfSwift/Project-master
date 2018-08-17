//
//  CVThumbPhotoViewController.swift
//  Project
//
//  Created by caven on 2018/7/18.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit
import Photos

fileprivate let item_num: CGFloat = 4
fileprivate let item_space: CGFloat = 2

typealias CVPhotoSelectClosure = ((_ selectedAssets: [PHAsset]) -> ())

class CVThumbPhotoViewController: CVBaseViewController {
    
    /* 公开属性 */
    var album: CVPhotoAlbum!
    var isMultiSelect: Bool = false   // 是否为多选，默认false
    
    /// 这里是单选，切图的选择
    var willClipPhoto: CVClipPhotoClosure?      // 即将剪切 回调
    var cropX: CGFloat?
    var cropY: CGFloat?
    var cropWidth: CGFloat?
    var cropHeight: CGFloat?
    var margin: CVMargin?
    
    /// 这里是多选的属性传值
    var selectPhotos: CVPhotoSelectClosure?     // 多选的时候返回结果
    var maxSelected: UInt = 0                   // 最多选多少张，多选时使用，当值为0时，不做上限
    
    
    /* 私有属性 */
    private var collectionView: UICollectionView!
    private var selectedAssets: [PHAsset] = []     // 多选时，存储选中的asset
    private var bottomView: CVSelectPreviewView!

    /* 父类方法 */
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = LS(self, key: "Choose Photo", comment: "选择图片")
        if self.isMultiSelect {
            self.setupBottomView()
        }
        self.setupCollection()
        self.cv_navigationBar?.rightBarButtonItem = CVBarButtonItem.item(title: LS(key: "Cancel", comment: "取消"), target: self, action: #selector(onCancelAction(_:)))
        
        self.registerNotification()
        self.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.unregisterNotification()
    }

}

// MARK: - 私有方法 Private Method
fileprivate extension CVThumbPhotoViewController {
    
    /// 创建bottom视图
    func setupBottomView() {
        self.bottomView = CVSelectPreviewView(frame: CGRect(x: 0, y: SCREEN_HEIGHT - cv_safeAreaInsets.bottom - 65, width: SCREEN_WIDTH, height: 65))
        self.bottomView.backgroundColor = UIColor.white
        self.bottomView.shadow(radius: 3, offset: CGSize(width: 0, height: -1))
        self.bottomView.deletePhotoFromBottom = { [weak self] (index: Int) in       // bottom 删除已选择的图片
            guard let strongSelf = self else { return }
            
            let ass = strongSelf.album.assets[index]
            if strongSelf.selectedAssets.contains(ass) {  // 已经选中的asset，则取消选中
                strongSelf.selectedAssets.remove(ass)
                strongSelf.collectionView.reloadData()
            }
        }
        self.bottomView.finishChoosePhotoFromBottom = { [weak self] in      // bottom 完成选择
            guard let strongSelf = self else { return }
            strongSelf.selectPhotos?(strongSelf.selectedAssets)  // 回调多选的结果
        }
        self.view.addSubview(self.bottomView)
    }
    
    /// 创建collection视图
    func setupCollection() {
        let y = self.cv_navigationBar != nil ? self.cv_navigationBar!.frame.maxY : 0
        let itemWidth = (SCREEN_WIDTH - (item_num - 1) * item_space) / item_num;
        let frame: CGRect
        if self.isMultiSelect {
            frame = CGRect(x: 0, y: y, width: SCREEN_WIDTH, height: self.bottomView.frame.minY - y)
        } else {
            frame = CGRect(x: 0, y: y, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - y)
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumLineSpacing = item_space
        layout.minimumInteritemSpacing = item_space
        layout.footerReferenceSize = CGSize(width: SCREEN_WIDTH, height: 70)
        self.collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.register(CVThumbCell.self, forCellWithReuseIdentifier: "CVThumbCell")
        self.collectionView.register(CVFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "CVFooterView")
        self.view.addSubview(self.collectionView)
        
         if self.isMultiSelect {
            self.view.bringSubview(toFront: self.bottomView)
        }
    }
    
    /// 获取相册列表
    func loadData() {
        if self.album.assets.count == 0 {
            let album = CVPhotoManager.fetchCameraRollAlbum()
            self.album = album
        }
        self.collectionView.reloadData()
        self.collectionView.scrollToItem(at: IndexPath(row: self.album.assets.count - 1, section: 0), at: .bottom, animated: true)
    }
    
    /// 注册通知
    func registerNotification() {
        PHPhotoLibrary.shared().register(self)
    }
    
    /// 注销通知
    func unregisterNotification() {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    @objc func onCancelAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - 显示通知
extension CVThumbPhotoViewController : PHPhotoLibraryChangeObserver {
    
    /// 实现通知
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        if self.album.fetchResult == nil {
            return
        }
        let changes: PHFetchResultChangeDetails? = changeInstance.changeDetails(for: self.album.fetchResult!)
        if changes != nil, changes!.hasIncrementalChanges { // 新增了一个改变
            // 增加了
            if changes!.insertedObjects.count > 0 {
                self.album.assets.append(contentsOf: changes!.insertedObjects)
            }
            // 减少了
            if changes!.removedObjects.count > 0 {
                
                // 查看已选中的数组中是否包含这些移除的asset
                for asset in changes!.removedObjects {
                    if self.selectedAssets.contains(asset) {
                        let index = self.album.assets.index(of: asset)!
                        self.selectedAssets.remove(asset)
                        self.bottomView.deleteOneImage(at: index)
                    }
                }
                
                self.album.assets.remove(changes!.removedObjects)
            }
            self.album.fetchResult = changes!.fetchResultAfterChanges
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.collectionView.scrollToItem(at: IndexPath(row: self.album.assets.count - 1, section: 0), at: .right, animated: true)
            }
        }
    }
}

// MARK: - UICollectionView 的 代理 和 数据源
extension CVThumbPhotoViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.album.assets.count
    }
    
    /// 显示cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CVThumbCell", for: indexPath) as! CVThumbCell

        let one = self.album.assets[indexPath.row]
        
        if !self.isMultiSelect {      // 单选
            cell.showCheckIcon = false
        } else {        // 多选
            cell.showCheckIcon = true
            weak var weakOne = one
            // 默认是否选中
            if self.selectedAssets.contains(one) {
                cell.defaultChecked = true
            } else {
                cell.defaultChecked = false
            }
            
            // 点击了选中
            weak var weakCell = cell
            cell.checked = { [weak self] in
                guard let strongSelf = self else { return false }
                guard let strongOne = weakOne else { return false }
                guard let strongCell = weakCell else { return false }

                if strongSelf.selectedAssets.contains(strongOne) {  // 已经选中的asset，则取消选中
                    strongSelf.selectedAssets.remove(one)
                    strongSelf.bottomView.deleteOneImage(at: indexPath.row)
                    return false
                }
                
                if strongSelf.maxSelected > 0 && strongSelf.selectedAssets.count >= strongSelf.maxSelected {
                    CVHUD.showMessageHUD(message: "已达到选择最大值")
                    return false
                }
                
                strongSelf.selectedAssets.append(strongOne)
                strongSelf.bottomView.addOneImage(strongCell.imageView.image!, at: indexPath.row)

                return true
            }
        }
        
        weak var weakCell = cell
        CVPhotoManager.requestImage(asset: one, size: CGSize(width: SCREEN_WIDTH / 4, height: SCREEN_WIDTH / 4)) { (image, info) in
            guard let strongCell = weakCell else { return }
            strongCell.imageView.image = image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusableView: UICollectionReusableView!
        
        if kind == UICollectionElementKindSectionFooter {
            reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "CVFooterView", for: indexPath)
            
            let local = NSString(format: LS(self, key: "Totals", comment: "总共") as NSString, "\(self.album.assets.count)")
            (reusableView as! CVFooterView).titleLabel.text = local as String
        }
        
        return reusableView
    }
    
    /// 点击cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
  
        if !self.isMultiSelect {  // 单选，直接进入截图界面
            let clipVC =  CVClipPhotoViewController()
            clipVC.assets = self.album.assets[indexPath.row]
            clipVC.clipPhoto = self.willClipPhoto
            if self.cropX != nil { clipVC.cropX = self.cropX! }
            if self.cropY != nil { clipVC.cropY = self.cropY! }
            if self.cropWidth != nil { clipVC.cropWidth = self.cropWidth! }
            if self.cropHeight != nil { clipVC.cropHeight = self.cropHeight! }
            if self.margin != nil { clipVC.margin = self.margin! }
            self.navigationController?.pushViewController(clipVC, animated: true)
        } else {        // 多选
            
            let bigPhotoVC = CVBigPhotoViewController()
            bigPhotoVC.assets = self.album.assets
            bigPhotoVC.currentIndex = indexPath.row
            bigPhotoVC.selectedAssets = self.selectedAssets
            bigPhotoVC.maxSelected = self.maxSelected
            bigPhotoVC.selectedClosure = { [weak self] (index: Int, isSelected: Bool) in
                if let strongSelf = self {
                    if isSelected {
                        let asset = strongSelf.album.assets[index]
                        strongSelf.selectedAssets.append(asset)
                        CVPhotoManager.requestImage(asset: asset, size: CGSize(width: SCREEN_WIDTH / 4, height: SCREEN_WIDTH / 4)) { [weak self] (image, info) in
                            guard let strongSelf = self else { return }
                            strongSelf.bottomView.addOneImage(image, at: index)
                        }
                    } else {
                        strongSelf.selectedAssets.remove(strongSelf.album.assets[index])
                        strongSelf.bottomView.deleteOneImage(at: index)
                    }
                    strongSelf.collectionView.reloadData()
                }
            }
            self.navigationController?.pushViewController(bigPhotoVC, animated: true)
        }
    }
}

// MARK: - 缩略图 cell
typealias CVCellCheckedClosure = () -> Bool
fileprivate class CVThumbCell : UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView(frame: CGRect.zero)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        self.contentView.addSubview(iv)
        return iv
    }()
    
    lazy var checkIcon: UIImageView = {
        let iv = UIImageView(frame: CGRect.zero)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        let bundle = Bundle(path: Bundle.main.path(forResource: "CVPhoto", ofType: "bundle")!)!
        let imagePath = bundle.cv_path(forResource: "btn_unselected", ofType: "png")
        if imagePath != nil {
            iv.image = UIImage(contentsOfFile: imagePath!)
        }
        self.contentView.addSubview(iv)
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(onCheckPhotoGesture(gesture:))))
        return iv
    }()
    
    var defaultChecked: Bool = false {
        didSet {
            self.setCellChecked(defaultChecked)
        }
    }
    
    var showCheckIcon: Bool = false { // 是否显示可选按钮，默认false
        didSet {
            self.checkIcon.isHidden = !self.showCheckIcon
        }
    }
    
    var checked: CVCellCheckedClosure?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.imageView.isHidden = false
        self.checkIcon.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.frame = self.bounds
        self.checkIcon.frame = CGRect(x: self.bounds.width - 25, y: 5, width: 20, height: 20)
    }
    
    //  MARK: - Actions
    @objc func onCheckPhotoGesture(gesture: UIGestureRecognizer?) {
        let result = self.checked?()
        if let result = result, result {
            self.setCellChecked(true)
        } else {
            self.setCellChecked(false)
        }
    }
    
    // MARK: - 私有方法
    
    fileprivate func setCellChecked(_ checked: Bool) {
        if checked {
            let bundle = Bundle(path: Bundle.main.path(forResource: "CVPhoto", ofType: "bundle")!)!
            let imagePath = bundle.cv_path(forResource: "btn_selected", ofType: "png")
            guard imagePath != nil else { return }
            self.checkIcon.image = UIImage(contentsOfFile: imagePath!)
            self.checkIcon.layer.add(self.imageAnimation(), forKey: nil)
        } else {
            let bundle = Bundle(path: Bundle.main.path(forResource: "CVPhoto", ofType: "bundle")!)!
            let imagePath = bundle.cv_path(forResource: "btn_unselected", ofType: "png")
            guard imagePath != nil else { return }
            self.checkIcon.image = UIImage(contentsOfFile: imagePath!)
        }
    }
    
    fileprivate func imageAnimation() -> CAKeyframeAnimation {
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
}

fileprivate class CVFooterView: UICollectionReusableView {
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 13)
        self.addSubview(label)
        return label;
    }()
}

// MARK: -
// MARK: - 底部选中缩略图
class CVSelectPreviewView: UIView {
    
    var maxSelected: UInt = 0                    // 最多选多少张，多选时使用，当值为0时，不做上限
    var deletePhotoFromBottom: ((_ index: Int)->())?
    var finishChoosePhotoFromBottom: (()->())?
    
    /* 私有属性 */
    private var dataSource: [UIImage] = []
    private var indexArray: [Int] = []
    
    lazy private var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.frame.height - 10, height: self.frame.height - 10)
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.frame.width - self.frame.height, height: self.frame.height), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CVSelectPreviewCell.self, forCellWithReuseIdentifier: "CVSelectPreviewCell")
        self.addSubview(collectionView)
        return collectionView
    }()
    
    lazy private var doneBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: self.frame.width - self.frame.height + 5, y: 5, width: self.frame.height - 10, height: self.frame.height - 10)
        btn.addTarget(self, action: #selector(doneAction(_:)), for: .touchUpInside)
        btn.backgroundColor = UIColor.red
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.corner(radius: btn.frame.height / 2, maskToBoudse: true)
        self.addSubview(btn)
        return btn
    }()
    
    override func layoutSubviews() {
        self.updateText()
    }
    
    // MARK: - 共有方法
    func addOneImage(_ image: UIImage, at index: Int) {
        if !self.indexArray.contains(index) {
            self.dataSource.append(image)
            self.indexArray.append(index)
            self.updateText()
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.collectionView.scrollToItem(at: IndexPath(row: self.dataSource.count - 1, section: 0), at: .right, animated: true)
            }
        }
    }
    
    func deleteOneImage(at index: Int) {
        if self.indexArray.contains(index) {
            self.dataSource.remove(at: self.indexArray.index(of: index)!)
            self.indexArray.remove(index)
            self.updateText()
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    @objc private func doneAction(_ sender: UIButton) {
        self.finishChoosePhotoFromBottom?()
    }
    
    // MARK: - 私有方法
    private func updateText() {
        if self.maxSelected == 0 {
            self.doneBtn.setTitle(LS(key: "Done", comment: "完成"), for: .normal)
        } else {
            let text = LS(key: "Done", comment: "完成") + "\n\(self.indexArray.count)/\(self.maxSelected)"
            self.doneBtn.setTitle(text, for: .normal)
        }
    }
}

extension CVSelectPreviewView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    /// 显示cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CVSelectPreviewCell", for: indexPath) as! CVSelectPreviewCell
        
        cell.imageView.image = self.dataSource[indexPath.row]
        cell.deleteImage = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.deletePhotoFromBottom?(strongSelf.indexArray[indexPath.row])
            strongSelf.deleteOneImage(at: strongSelf.indexArray[indexPath.row])
        }
        return cell
    }
}

class CVSelectPreviewCell: UICollectionViewCell {
    var imageView: UIImageView!
    var closeBtn: UIButton!
    var deleteImage: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        self.addSubview(self.imageView)
        
        self.closeBtn = UIButton(type: .custom)
        self.closeBtn.frame = CGRect(x: self.frame.width - 40, y: 0, width: 40, height: 40)
        self.closeBtn.contentVerticalAlignment = .top
        self.closeBtn.contentHorizontalAlignment = .right
        let bundle = Bundle(path: Bundle.main.path(forResource: "CVPhoto", ofType: "bundle")!)!
        let imagePath = bundle.cv_path(forResource: "icon_close", ofType: "png")!
        self.closeBtn.setImage(UIImage(contentsOfFile: imagePath), for: .normal)
        self.closeBtn.addTarget(self, action: #selector(onDeleteImageAction(_:)), for: .touchUpInside)
        self.addSubview(self.closeBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onDeleteImageAction(_ sender: UIButton) {
        self.deleteImage?()
    }
}
