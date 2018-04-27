//
//  HELanguageModel.swift
//  Project
//
//  Created by weixhe on 2018/3/16.
//  Copyright © 2018年 com.weixhe. All rights reserved.
//

import Foundation

class HELanguageModel: NSObject {
    let language: String    // 语言：none-language, zh-Hans, en
    let title: String       //  标题：跟随系统，简体中文，英文
    var isSelected: Bool
    
    init(title: String, language: String, isSelected: Bool) {
        self.title = title
        self.language = language
        self.isSelected = isSelected
    }
}

class HELanguageManager: NSObject {
    
    private var languages = [HELanguageModel]()
    
    func add(language: HELanguageModel) {
        if !self.languages.contains(language) {
            self.languages.append(language)
        }
    }
    
    func update(language: HELanguageModel) {
        for lang in self.languages {
            if lang.isEqual(language) {
                lang.isSelected = true
            } else {
                lang.isSelected = false
            }
        }
    }
    
    func getLanguages() -> [HELanguageModel] {
        return languages
    }
}
