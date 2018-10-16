//
//  CVClient.swift
//  Project
//
//  Created by caven on 2018/3/29.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit
import Alamofire

/// 定义一些回调的闭包
typealias Success = (Any) -> (Void)
typealias Failture = (Error) -> (Void)

/// 网络层 - 简易封装
struct CVClient {
    
    static let shared: CVClient = CVClient()
    let headers = ["Accept":"application/json", "Content-Type":"allication/json"]
    private var manager: SessionManager? = nil

    init() {
        // 配置 , 通常默认即可
        let config: URLSessionConfiguration = URLSessionConfiguration.default
        // 设置超时时间为15S
        config.timeoutIntervalForRequest = 15
        // 根据config创建manager
        manager = SessionManager(configuration: config)
    }
    
    

    /// GET 请求，可以无参，结果
    func get(path: String, parameters: [String:Any]? = nil, success: Success? = nil, failture: Failture? = nil) {
        
        manager!.request(handleUrl(path), method: HTTPMethod.get, parameters: handleParameters(parameters), encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                success?(value)
            case let .failure(error):
                failture?(error)
            }
        }
    }
    
    /// POST 请求，可以无参，结果
    func post(path: String, parameters: [String:Any]? = nil, success: Success? = nil, failture: Failture? = nil) {
        
        manager!.request(handleUrl(path), method: HTTPMethod.post, parameters: handleParameters(parameters), encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                success?(value as! DataResponse<Any>)
            case let .failure(error):
                failture?(error)
            }
        }
    }
    
    /// 上传文件
    func upload(path: String, parameters: [String:Any]? = nil, datas:[CVUploadParam], success: Success? = nil, failture: Failture? = nil) {
        manager!.upload(multipartFormData: { (multipartFormData) in
            
            if let newParam = self.handleParameters(parameters) {
                for (key, value) in newParam {      // 上传一些参数
                    multipartFormData.append(String(describing: value).data(using: .utf8)!, withName: key)
                }
            }
            for param in datas {    // 上传文件
                multipartFormData.append(param.fileData, withName: param.serverName, fileName: param.fileName, mimeType: param.mimeType)
            }
        }, to: handleUrl(path), headers: headers) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { (response) in
                    success?(response)
                })
            case .failure(let error):
                failture?(error)
            }
        }
    }
    
    /// 下载文件: 支持断点下载
    @discardableResult
    func download(path: String, to: String, resumData: Data?, parameters: [String:Any]? = nil, success: @escaping (String) -> (), failure: @escaping (Error, Data?) -> ()) -> DownloadRequest {
        // 指定下载路径
        let destination: DownloadRequest.DownloadFileDestination = {_, response in
            let url = URL.init(string: to)!;
            return (url, [.removePreviousFile,.createIntermediateDirectories])
        }
        if let data = resumData {
            CVLog(data)
            return manager!.download(resumingWith: data, to: destination)
        }
        return manager!.download(handleUrl(path), method: .get, parameters: handleParameters(parameters), encoding: URLEncoding.default, headers: headers, to: destination)
            .responseData(completionHandler: { (response: DownloadResponse<Data>) in
                switch response.result {
                case .success(_):
                    // 下载完成
                    success(to)
                case let .failure(error):
                    // 中断时把已下载的数据返回
                    failure(error, response.resumeData)
                    break
                }
            })
    }
    
    /// 下载进度
    func downloadProgress(request: DownloadRequest, progress: @escaping Request.ProgressHandler) {
        request.downloadProgress(closure: progress)
    }
    
    private func handleParameters(_ parameters: [String:Any]?) -> [String:Any]? {
        var newparam: [String:Any]?
        if let param = parameters {
            newparam = self.param.merging(param, uniquingKeysWith: { (current, new) -> Any in
                return current      // 如果两个值冲突了，则返回新值
            })
            newparam = sign(newparam!)
        }
        return newparam
    }
    
    private func handleUrl(_ path: String) -> String {
        if path.hasPrefix("http://") || path.hasPrefix("https://") {
            return path
        } else {
            return Api.baseUrl.appending(path)
        }
    }
}

/// 定义一些固定的参数，签名等
extension CVClient {

    var param: Dictionary<String, Any> {
        return ["deviceType":cv_deviceName, "idfa":cv_UUID, "opversion":cv_sysVersion, "req_sec":"1522376970", "version":"3.84"]
    }
    
    func sign(_ param:[String: Any]) -> [String : Any] {
        
        
        
        
        let allKeys = param.keys.sorted()
        var result = Array<String>.init()
        
        for key in allKeys {
            let value: String = param[key] as! String
            result.append("\(key)=\(value)")
        }
        let queryString: String = result.joined(separator: "&") + "DAwF7FjqAQMBXBvyVCLJgOu8uCLbl5pq"
        let sign = queryString.md5
        
        var newParam = (param as NSDictionary).copy() as! Dictionary<String, Any>
        
        newParam["sign"] = sign
        newParam["appid"] = "638481987"
        return newParam
    }
}
