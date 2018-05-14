//
//  CVUploadParam.swift
//  Project
//
//  Created by caven on 2018/3/30.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import Foundation
import UIKit

// 文件的mineType ：http://www.iana.org/assignments/media-types/media-types.xhtml
enum CVMineType: String {
    case audio  = "audio/aac"
    case jpg    = "image/jpeg"
    case png    = "image/png"
    case txt    = "text/plain"
    case xml    = "text/xml"
    case html   = "text/html"
    case any    = "application/octet-stream"
}

class CVUploadParam {
    let fileData: Data
    let fileName: String          // 保存到服务器时对应的名字，可不设
    let serverName: String        // 服务器对应的字段名
    let mimeType: String
    
    init(data: Data, fileName: String, serverName: String, mimeType: CVMineType) {
        self.fileData = data
        self.fileName = fileName
        self.serverName = serverName
        self.mimeType = mimeType.rawValue
    }
}

class CVImageUploadParam: CVUploadParam {
    let image: UIImage?
    
    override init(data: Data, fileName: String = defaultFileName(), serverName: String, mimeType: CVMineType) {
        self.image = nil
        let newFileName = CVImageUploadParam.handleFileName(fileName)
        super.init(data: data, fileName: newFileName, serverName: serverName, mimeType: mimeType)
    }
    
    init(image: UIImage, fileName: String = defaultFileName(), serverName: String, mimeType: CVMineType) {
        self.image = image
        let newFileName = CVImageUploadParam.handleFileName(fileName)
        super.init(data: UIImageJPEGRepresentation(image, 0.5)!, fileName: newFileName, serverName: serverName, mimeType: mimeType)
    }
    
    private static func handleFileName(_ fileName: String) -> String {
        return (fileName as NSString).deletingPathExtension.appending(".jpeg")
    }
}

private func defaultFileName() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMddHHmmss"
    return formatter.string(from: Date())
}


