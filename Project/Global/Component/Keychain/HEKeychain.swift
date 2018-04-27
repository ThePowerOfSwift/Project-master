//
//  HEKeychain.swift
//  Project
//
//  Created by weixhe on 2018/3/27.
//  Copyright © 2018年 com.weixhe. All rights reserved.
//

import Foundation
import KeychainAccess

private let kServer = "com.weixhe.project.keychain"
private let kUUID = "com.weixhe.project.UUID"

class HEKeyChain {
    
    static let shared = HEKeyChain()        // 单例
    
    // 该方法相当于OC中的load()方法
    static func awake() {
        if shared.get(key: kUUID) == nil {
            shared.set(NSUUID().uuidString, key: kUUID)
        }
    }
    
    func set(_ value: String, key: String) {
        try? Keychain.init(service: kServer).set(value, key: key)
    }
    
    func get(key: String) -> String? {
        return try! Keychain.init(service: kServer).get(key)
    }
    
    func remove(key: String) {
        try? Keychain.init(service: kServer).remove(key)
    }
    
    func update(_ value: String, key: String) {
        try? Keychain.init(service: kServer).set(value, key: key)
    }
    
    static func appIdentifier() -> String {
        var str = shared.get(key: kUUID)
        if str == nil {
            str = NSUUID().uuidString
            shared.set(str!, key: kUUID)
        }
        return str!
    }
}
