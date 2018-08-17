//
//  CVPhotoAlbum.swift
//  Project
//
//  Created by caven on 2018/7/16.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit
import Photos

/**
 *   @brief 相册
 */
struct CVPhotoAlbum {

    /// 相册名称
    var title: String
    /// 相册内相片数量
    var count: Int
    /// 相册第一张图片缩略图
    var headImageAsset: PHAsset?
    /// 相册集，通过该属性获取该相册集下所有照片
    var assets: [PHAsset]
    /// 记录assets对应的fetchResult
    var fetchResult: PHFetchResult<PHAsset>?
    
    
    public init(title: String, count: Int, headImageAsset: PHAsset?, assets: [PHAsset]) {
        self.title = title
        self.count = count
        self.headImageAsset = headImageAsset
        self.assets = assets
    }
}

/// 相册的类型
enum CVAlbumType: Int {
    
    // 智能相册 类型：
    case selfies = 210          //    自拍
    case screenshots = 211      //    屏幕快照
    case depthEffect = 212      //    景深效果
    case slo_mo = 208           //    慢动作
    case videos = 202           //    视频
    case livePhotos = 213       //    Live Photo
    case cameraRoll = 209       //    相机胶卷
    case favorites = 203        //    个人收藏
    case panoramas = 201        //    全景照片
    case bursts = 207           //    连拍快照
    case recentlyAdded = 206    //    最近添加
    case timeLapse = 204        //    延时摄影
}
