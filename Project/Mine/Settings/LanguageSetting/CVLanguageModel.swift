//
//  CVLanguageModel.swift
//  Project
//
//  Created by caven on 2018/3/16.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import Foundation

class CVLanguageModel: NSObject {
    let language: String    // 语言：none-language, zh-Hans, en
    let title: String       //  标题：跟随系统，简体中文，英文
    var isSelected: Bool
    
    init(title: String, language: String, isSelected: Bool) {
        self.title = title
        self.language = language
        self.isSelected = isSelected
    }
}

class CVLanguageManager: NSObject {
    
    private var languages = [CVLanguageModel]()
    
    func add(language: CVLanguageModel) {
        if !self.languages.contains(language) {
            self.languages.append(language)
        }
    }
    
    func update(language: CVLanguageModel) {
        for lang in self.languages {
            if lang.isEqual(language) {
                lang.isSelected = true
            } else {
                lang.isSelected = false
            }
        }
    }
    
    func getLanguages() -> [CVLanguageModel] {
        return languages
    }
}
