//
//  CVPhoto.swift
//  Project
//
//  Created by caven on 2018/7/16.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit
import Photos

enum CVPhotoLibraryStatus {
    case authorized     // 用户已授权，允许访问
    case denied         // 用户拒绝访问
}



typealias AuthorizationClosure = ((_ status: CVPhotoLibraryStatus)->Void)
typealias RequestImageClosure = ((_ image: UIImage, _ info: [AnyHashable : Any]?)->())
typealias RequestDataClosure = ((_ data: Data, _ info: [AnyHashable : Any]?)->())

private var ignoreAlbums: [Int] = [205, 1000000201]  // 忽略的相册
private var destineAlbums: [Int] = []   // 指定相册

struct CVPhotoManager {
    
    // MARK: - 授权相册权限
    /// 判断是否拥有权限去访问用户的相册，需要随时调用获取
    static func requestAuthorization(closure: @escaping AuthorizationClosure) {
        let status: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:   // 用户已授权，允许访问
            closure(.authorized)
        case .denied:       // 用户拒绝访问
            closure(.authorized)
        case .notDetermined:    // 用户从未进行过授权等处理，首次访问相应内容会提示用户进行授权
            PHPhotoLibrary.requestAuthorization { (status) in
                DispatchQueue.main.async {
                    closure(.authorized)
                }
            }
        case .restricted:   // 应用没有相关权限，且当前用户无法改变这个权限，比如:家长控制
            CVAlertView.show(title: "提示", message: "应用没有相关权限，请检查设备", cancelButtonTitle: "取消", otherButtonTitles: "确定", clickButtonClosure: nil)
        }
    }

    // MARK: - 获取所有相册列表
    
    /// 设置指定的某些相册
    static func setDestineAlbums(_ albums: [Int]?) {
        if albums != nil && albums!.count > 0 {
            destineAlbums = albums!
        } else {
            destineAlbums = []
        }
    }
    
    /// 获取所有相册列表
    static func fetchAllAblums() -> [CVPhotoAlbum] {
        var albums: [CVPhotoAlbum] = []
        albums.append(contentsOf: self.fetchSystemAblum())
        albums.append(contentsOf: self.fetchUsersAlbum())
        return albums
    }
    
    /// 获取相机胶卷
    static func fetchCameraRollAlbum() -> CVPhotoAlbum {
        self.setDestineAlbums([CVAlbumType.cameraRoll.rawValue])
        let albums = self.fetchSystemAblum()
        self.setDestineAlbums(nil)
        return albums.first!
    }
    
    /// 获取系统相册列表
    static func fetchSystemAblum() -> [CVPhotoAlbum] {
        let smartAlbums: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        
        var albums: [CVPhotoAlbum] = []
        
        // smartAlbums中保存的是各个智能相册对应的PHAssetCollection
        for i in 0..<smartAlbums.count {
            // 获取一个相册(PHAssetCollection)
            let collection = smartAlbums[i]
            if collection.isKind(of: PHAssetCollection.classForCoder()) {
                
                // 类型强制转换
                let assetCollection = collection
                let subtype = assetCollection.assetCollectionSubtype.rawValue
                // 有指定相册, 则取指定相册；如果没有指定相册，则过滤掉已删除相册即可
                if destineAlbums.count > 0 {
                    if !destineAlbums.contains(subtype) {
                        continue
                    }
                } else {
                    if ignoreAlbums.contains(subtype) {
                        continue
                    }
                }
                let (assets, fetchResult) = self.fetchAssets(in: assetCollection)
                guard assets.count > 0 else { continue }
                // 创建相册模型
                let title = collection.localizedTitle != nil ? collection.localizedTitle! : "未知相册"
                var album = CVPhotoAlbum(title: title, count: assets.count, headImageAsset: assets.last, assets: assets)
                album.fetchResult = fetchResult
                albums.append(album)
            }
        }
        return albums
    }

    /// 获取用户自定义的相册
    static func fetchUsersAlbum() -> [CVPhotoAlbum] {
        // topLevelUserCollections中保存的是各个用户创建的相册对应的PHAssetCollection
        let topLevelUserCollections: PHFetchResult = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        
        var albums: [CVPhotoAlbum] = []
        
        for i in 0..<topLevelUserCollections.count {
            
            // 获取一个相册(PHAssetCollection)
            let collection = topLevelUserCollections[i]
            if collection.isKind(of: PHAssetCollection.classForCoder()) {
                // 类型强制转换
                let assetCollection = collection as! PHAssetCollection
                let (assets, fetchResult) = self.fetchAssets(in: assetCollection)
                guard assets.count > 0 else { continue }
                // 创建相册模型
                let title = collection.localizedTitle != nil ? collection.localizedTitle! : "未知相册"
                var album = CVPhotoAlbum(title: title, count: assets.count, headImageAsset: assets.last, assets: assets)
                album.fetchResult = fetchResult
                albums.append(album)
            }
        }
        return albums
    }
    
    // MARK: - 从相册中获取资源
    /// 从相册中获取资源，ascending：按时间排序方式，默认true
    static func fetchAssets(in assetCollection: PHAssetCollection, ascending: Bool = true) -> ([PHAsset], PHFetchResult<PHAsset>) {

        let options: PHFetchOptions = PHFetchOptions.init()
        options.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: ascending)]
        
        let result: PHFetchResult = PHAsset.fetchAssets(in: assetCollection, options: options)
        
        var assetArray = [PHAsset]()
        for i in 0..<result.count {
            // 获取一个资源(PHAsset)
            let asset = result[i]
            assetArray.append(asset)
        }
        return (assetArray, result)
    }
    
    // MARK: - 将资源asset转换成图片
    static func requestImage(asset: PHAsset, size: CGSize = PHImageManagerMaximumSize, asyn: Bool = true, closure: @escaping RequestImageClosure) {
        
        let manager = PHCachingImageManager.default()
        let option = PHImageRequestOptions() // 可以设置图像的质量、版本、也会有参数控制图像的裁剪
        option.isSynchronous = !asyn     // 同步or异步
        option.isNetworkAccessAllowed = true    // 接受从iCloud下载
        
        let scale = UIScreen.main.scale
        let newSize = size.width == PHImageManagerMaximumSize.width ? PHImageManagerMaximumSize : CGSize.init(width: size.width * scale, height: size.height * scale)
        manager.requestImage(for: asset, targetSize: newSize, contentMode: .aspectFit, options: option) { (image, info) in
            
            if info != nil {
                let isCancel = info![PHImageCancelledKey] as? Int  == 1
                let isError = info![PHImageErrorKey] as? Int  == 1
                if !isCancel && !isError && image != nil {
                    DispatchQueue.main.async {
                        closure(image!, info)
                    }
                }
            }
        }
    }
    
    /// 获取图片的data
    static func requestImageData(asset: PHAsset, asyn: Bool = true, closure: @escaping RequestDataClosure) {
        let manager = PHCachingImageManager.default()
        let option = PHImageRequestOptions() // 可以设置图像的质量、版本、也会有参数控制图像的裁剪
        option.isSynchronous = !asyn     // 同步or异步
        option.isNetworkAccessAllowed = true    // 接受从iCloud下载
        
        manager.requestImageData(for: asset, options: option) { (data, dataUTI, orientation: UIImageOrientation, info) in
            if info != nil {
                let isCancel = info![PHImageCancelledKey] as? Int == 1
                let isError = info![PHImageErrorKey] as? Int  == 1
                if !isCancel && !isError && data != nil {
                    DispatchQueue.main.async {
                        closure(data!, info)
                    }
                }
            }
        }
    }
}
