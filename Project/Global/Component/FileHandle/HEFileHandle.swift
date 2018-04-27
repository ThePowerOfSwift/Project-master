//
//  HEFileHandle.swift
//  Project
//
//  Created by weixhe on 2018/3/19.
//  Copyright © 2018年 com.weixhe. All rights reserved.
//

import Foundation

class HEFileHandle {
    
    /// 创建一个文件夹
    class func createFolder(path: String) {
        
        let fileManager: FileManager = FileManager.default
        if fileManager.fileExists(atPath: path) == false {
            // withIntermediateDirectories为ture表示路径中间如果有不存在的文件夹都会创建
            try? fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    /// 创建一个文件
    class func createFileAtPath(fileName: String,  filePath: String) {
        let manager = FileManager.default
        let file = filePath + "/" + fileName
        let exist = manager.fileExists(atPath: file)
        if !exist { // 如果不存在，则创建文件
             manager.createFile(atPath: file, contents:nil, attributes:nil)
        }
    }
    
    /// 获取指定路径下的所有目录和文件, deep为true时，会递归遍历子文件夹
    class func findAllFiles(atPath path: String, deep: Bool) -> [String]? {
        if deep {
            let contentsOfPaths = FileManager.default.subpaths(atPath: path)
            return contentsOfPaths!
        } else {
            let contentsOfPaths = try? FileManager.default.contentsOfDirectory(atPath: path)
            return contentsOfPaths
        }
    }
    
    /// 获取文件的属性，比如创建时间、大小、类型等
    class func attributesForFile(path: String) -> [FileAttributeKey : Any]? {
        
        let attributes = try? FileManager.default.attributesOfItem(atPath: path) // 结果为Dictionary类型
        return attributes
    }
    
    /// 计算单个文件的大小
    class func fileSize(atPath path: String) -> Int64 {
        
        let manager = FileManager.default
        if manager.fileExists(atPath: path) {
            let attr = self.attributesForFile(path: path)
            if let attr = attr {
                let size: Int64 = attr[FileAttributeKey.size] as! Int64
                return size ;
            }
        }
        return 0;
    }
    class func fileSizeFormat(_ fileSize: Int64) -> String {
        
        var string = ""
        switch fileSize {
        case 0..<1024:
            string = "\(fileSize)B"
        case 1024..<1048576:    // 1024*1024
            string = "\(fileSize / 1024)K"
        case 1024*1024..<1073741824:    // 1024*1024*1024
            string = "\(fileSize / 1048576)M"
        default:
            string = "\(fileSize / 1073741824)G"
        }
        return string
    }
    
    /// 计算某个文件夹的大小
    class func folderSize(atPath path: String) -> Int64 {
        let files = self.findAllFiles(atPath: path, deep: true)
        var totalSize: Int64 = 0
        if let files = files {
            for (_, one) in files.enumerated() {
                totalSize += self.fileSize(atPath: path + "/" + one)
            }
        }
        return totalSize
    }
    
    /// 获取文件的路径
    class func filePath(path: String) -> String {
        return (path as NSString).deletingLastPathComponent
    }
    
    /// 删除文件夹或者文件
    class func removeFile(atPath path: String) {
        try? FileManager.default.removeItem(atPath: path)
    }
    
    /// 清空缓存
    class func cleanCache() {
        // 1. 清空 cache 包
        self.removeFile(atPath: CachesPath)
        // 2. 清空tem包
        self.removeFile(atPath: TmpPath)
    }
}

class HEPlistHandle {
    
    private class func check(_ plistName: String) -> String {
        return (plistName as NSString).deletingPathExtension
    }
    
    private class func fullPath(_ plistName: String, _ path: String?) -> String {
        
        var filePath = ""
        if let path = path {
            filePath = path + ("/" + check(plistName) + ".plist")
        } else {
            filePath = LibraryPath + ("/" + check(plistName) + ".plist")
        }
        return filePath
    }
    
    /// 创建一个plist文件
    class func createPist(plistName: String, path: String?) {
        
        let filePath = fullPath(plistName, path)
        // 不存在plist文件就创建
        if FileManager.default.fileExists(atPath: filePath) == false {
            let fileManager: FileManager = FileManager.default
            // 创建plist
            fileManager.createFile(atPath: filePath, contents: nil, attributes: nil)
            let Dictionary = NSMutableDictionary()
            Dictionary.write(toFile: filePath, atomically: true)  // 写入
        }
    }
    
    /// 写入plist值 ：注： force为true时，可能会覆盖原有的value值
    class func setValue(_ value: Any, key: String, force: Bool = false, plistName: String, path: String?) {
        
        let filePath = fullPath(plistName, path)

        // 读取plist文件的内容
        let dataDictionary = NSMutableDictionary(contentsOfFile: filePath)
        if (dataDictionary?.object(forKey: key) != nil && !force) {   // 已经存在，且不强制写入value ,直接return
            return
        } else {
            // 添加数据
            dataDictionary?.setValue(value, forKey: key)
        }
        // 重新写入到plist
        dataDictionary?.write(toFile: filePath, atomically: true)
    }
    
    /// 获取某一个key的对象
    class func getValueForKey(_ key: String, plistName: String, path: String?) -> Any? {
        
        let filePath = fullPath(plistName, path)
        // 读取plist文件的内容
        let dataDictionary = NSDictionary(contentsOfFile: filePath)
        let result: Any? = dataDictionary?.object(forKey: key)
        return result
    }
    
    /// 获取plist所有对象
    class func getAllPlistValue(plistName: String, path: String?) -> NSDictionary? {
        
        let filePath = fullPath(plistName, path)
        let dataDictionary = NSDictionary(contentsOfFile: filePath)
        return dataDictionary
    }
    
    /// 删除plist的所有对象
    class func removeAllPlistValue(plistName: String, path: String?) {
        
        let filePath = fullPath(plistName, path)
        let dataDictionary = NSMutableDictionary(contentsOfFile: filePath)
        if let data = dataDictionary {
            if data.allKeys.count > 0 {
                data.removeAllObjects()
                // 重新写入
                data.write(toFile: filePath, atomically: true)
            }
        }
    }
    
    /// 删除plist的Key对象
    class func removeKeyPlistValue(plistName: String, key: String, path: String?) {
        
        let filePath = fullPath(plistName, path)
        let dataDictionary = NSMutableDictionary(contentsOfFile: filePath)
        if let data = dataDictionary {
            if data.allKeys.count > 0 {
                data.removeObject(forKey: key) // 删除
                // 重新写入
                data.write(toFile: filePath, atomically: true)
            }
        }
    }
}
