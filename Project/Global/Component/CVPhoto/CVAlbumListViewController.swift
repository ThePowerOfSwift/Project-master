//
//  CVAlbumListViewController.swift
//  Project
//
//  Created by caven on 2018/7/18.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit
import Photos

/**
 *   @brief 相册列表
 */
class CVAlbumListViewController: CVBaseViewController {
    
    /* 公开属性 */
    var isMultiSelect: Bool = false   // 是否为多选，默认false
    
    /// 这里是单选，切图的选择
    var willClipPhoto: CVClipPhotoClosure?      // 即将剪切 回调
    var cropX: CGFloat?
    var cropY: CGFloat?
    var cropWidth: CGFloat?
    var cropHeight: CGFloat?
    var margin: CVMargin?
    
    
    /// 这里是多选的属性传值
    var willSelectPhotos: CVPhotoSelectClosure?  // 多选的时候返回结果
    var maxSelected: UInt = 0                    // 最多选多少张，多选时使用，当值为0时，不做上限

    
    /* 私有属性 */
    private var dataSource: [CVPhotoAlbum] = []
    private var tableView: UITableView!

    /* 父类方法 */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = LS(self, key: "Photos", comment: "图片库")

        let y = self.cv_navigationBar != nil ? self.cv_navigationBar!.frame.maxY : 0
        self.tableView = cv_tableView(delegate: self, dataSource: self, super: self.view)
        self.tableView.frame = CGRect(x: 0, y: y, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - y)
        self.tableView.register(CVAlbumCell.self, forCellReuseIdentifier: "CVAlbumCell")
        self.tableView.tableFooterView = UIView()
        
        self.registerNotification()
        self.authorization()
        
        // 进入本页面后直接推入下一界面
        self.gotoThumbPageFromAlbumIndex(0, animation: false)
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
fileprivate extension CVAlbumListViewController {
    
    /// 判断申请相册权限
    func authorization() {
        CVPhotoManager.requestAuthorization { [weak self] (status: CVPhotoLibraryStatus) in
            guard let strongSelf = self else { return }
            switch status {
            case .authorized:   // 用户已授权，允许访问
                strongSelf.getAlbumList()
            case .denied:       // 用户拒绝访问
                let title = LS(key: "Tip", comment: "提示")
                let content = LS(self, key: "No Photos Permissions", comment: "您已拒绝访问相册，是否重新允许我们访问您的相册")
                let cancel = LS(key: "Cancel", comment: "取消")
                let sure = LS(key: "Sure", comment: "确定")
                CVAlertView.show(title: title, message: content, cancelButtonTitle: cancel, otherButtonTitles: sure, clickButtonClosure: { (index) in
                    if index == 1 {     // 跳转到设置相册权限页
                        let urltemp = URL(string: "prefs:root=Photos")
                        if let url = urltemp, UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.openURL(url)
                        }
                    }
                })
            }
        }
    }
    
    /// 获取相册列表
    func getAlbumList() {
        self.dataSource = CVPhotoManager.fetchAllAblums()
        self.tableView.reloadData()
    }
    
    /// 进入展示thumb页
    func gotoThumbPageFromAlbumIndex(_ index: Int, animation: Bool = true) {
        let album = self.dataSource[index]
        
        let thumbVC = CVThumbPhotoViewController()
        thumbVC.album = album
        thumbVC.isMultiSelect = self.isMultiSelect
        
        if self.isMultiSelect {       // 多选
            thumbVC.selectPhotos = self.willSelectPhotos    // 多选结果
            thumbVC.maxSelected = self.maxSelected      // 多选的上限
            
        } else {   // 单选、切图
            thumbVC.willClipPhoto = self.willClipPhoto  // 单选截图
            thumbVC.cropX = self.cropX
            thumbVC.cropY = self.cropY
            thumbVC.cropWidth = self.cropWidth
            thumbVC.cropHeight = self.cropHeight
            thumbVC.margin = self.margin
        }
        self.navigationController?.pushViewController(thumbVC, animated: animation)
    }
    
    /// 注册通知
    func registerNotification() {
        PHPhotoLibrary.shared().register(self)
    }
    
    /// 注销通知
    func unregisterNotification() {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
}

// MARK: - 共有方法
extension CVAlbumListViewController {
    
    class func show(_ vc: UIViewController, clip: CGRect = CGRect.zero, margin: CVMargin = CVMargin.zero, result: @escaping CVClipPhotoClosure) {
        
        let albumListVC = CVAlbumListViewController()
        albumListVC.isMultiSelect = false // 单选
        albumListVC.willClipPhoto = result
        if !clip.equalTo(CGRect.zero) {
            albumListVC.cropX = clip.minX
            albumListVC.cropY = clip.minY
            albumListVC.cropWidth = clip.width
            albumListVC.cropHeight = clip.height
        }
        if !margin.isZero {
            albumListVC.margin = margin
        }
        let nav = UINavigationController(rootViewController: albumListVC)
        nav.isNavigationBarHidden = true
        vc.present(nav, animated: true, completion: nil)
    }
}

// MARK: - 显示通知
extension CVAlbumListViewController : PHPhotoLibraryChangeObserver {
    
    /// 实现通知
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.async {
            self.getAlbumList()
        }
    }
}

// MARK: - UITableView 代理 和 数据源
extension CVAlbumListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    /// 设置cell的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    /// 显示cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CVAlbumCell") as! CVAlbumCell
        
        let one = self.dataSource[indexPath.row]
        cell.titleLabel.text = one.title + "(\(one.count))"
        
        if one.count == 0 {
            cell.albumImageView.image = UIImage()
        } else {
            unowned let weakCell = cell
            CVPhotoManager.requestImage(asset: one.headImageAsset!, size: CGSize(width: 70, height: 70)) { (image, info) in
                weakCell.albumImageView.image = image
            }
        }
        return cell
    }
    
    /// 点击cell事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.gotoThumbPageFromAlbumIndex(indexPath.row)
    }
}

// MARK: - 相册列表 Cell
fileprivate class CVAlbumCell: UITableViewCell {
    
    var titleLabel: UILabel!
    var albumImageView: UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = .disclosureIndicator
        
        self.albumImageView = cv_imageView(image: nil, super: self.contentView)
        self.albumImageView.contentMode = .scaleAspectFill

        self.titleLabel = cv_label(font: UIFont.systemFont(ofSize: 17), text: nil, super: self.contentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.albumImageView.frame = CGRect(x: 10, y: 5, width: 60, height: 60)
        
        let x = self.albumImageView.frame.maxX + 5
        let w = self.frame.width - x - 10
        self.titleLabel.frame = CGRect(x: x, y: 5, width: w, height: 60)
    }
}
