//
//  CVCameraPhoto.swift
//  Project
//
//  Created by caven on 2018/3/19.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import Foundation
import UIKit

class CVCameraPhoto : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    static let instanse = CVCameraPhoto()
    
    private var callBack: ((_ value: UIImage) -> Void)?
    
    func showCameraSheet(vc: UIViewController, _ call: @escaping ((_ value: UIImage) -> Void)) {
        
        self.callBack = call
        
        COM.actionSheet(vc: vc, title: LS(self, key: "Title", comment: "选择图片"), sheets: [LS(self, key: "Camera", comment: "相机"), LS(self, key: "Photo", comment: "照片")]) { (index) -> (Void) in
            switch index {
            case 0:     // 相机
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let picker = UIImagePickerController()  // 创建图片控制器
                    picker.delegate = self  // 设置代理
                    picker.sourceType = UIImagePickerControllerSourceType.camera    // 设置来源
                    picker.allowsEditing = true // 允许编辑
                    vc.present(picker, animated: true, completion: nil)   // 打开相机
                } else {
                    
                    CVAlertView.show(title: LS(key: "Tip", comment: "提示"), message: LS(self, key: "NotSupportVideo", comment: "该设备不支持摄像"), cancelButtonTitle: LS(key: "Cancel", comment: "取消"), otherButtonTitle: nil, clickButtonBlock: { (alertView, index) in
                        
                    })
                }
            case 1:     // 相册
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let picker = UIImagePickerController()  // 创建图片控制器
                    picker.delegate = self  // 设置代理
                    picker.sourceType = UIImagePickerControllerSourceType.photoLibrary    // 设置来源
                    picker.allowsEditing = true // 允许编辑
                    vc.present(picker, animated: true, completion: nil)   // 打开相机
                } else {
                    CVAlertView.show(title: LS(key: "Tip", comment: "提示"), message: LS(self, key: "NotSupportVideo", comment: "该设备不支持摄像"), cancelButtonTitle: LS(key: "Cancel", comment: "取消"), otherButtonTitle: nil, clickButtonBlock: { (alertView, index) in
                        
                    })
                }
            default:
                CVLog(message: "完善 swift 的default")
            }
        }
    }
    
    // MARK: 获取系统的图片
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        if self.callBack != nil {
            self.callBack!(image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.callBack = nil
        picker.dismiss(animated: true, completion: nil)
    }
}

