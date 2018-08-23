//
//  CVLanguageViewController.swift
//  Project
//
//  Created by caven on 2018/3/15.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit

enum LanguageKinds: String {
    case FollowSystem = "FollowSystem"
    case SimpliedChinese = "SimpliedChinese"
    case English = "English"
}

class CVLanguageViewController: CVBaseViewController {

    var dataSource: [CVLanguageModel]?
    let manager: CVLanguageManager = CVLanguageManager()
    
    lazy var tableView: UITableView = {
        let tableView = cv_tableView(delegate: self, dataSource: self, super: self.view)
        tableView.frame = CGRect.init(x: 0, y: cv_safeNavBarHeight, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - cv_safeNavBarHeight)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = LS(self, key: "Title", comment: "语言设置")
        //********* 此处的代码需要根据app需求进行自定义
        let data: [(String, String)] = [(LS(self, key: "FollowSystem", comment: "跟随系统"),        "FollowSystem"),
                                        (LS(self, key: "SimpliedChinese", comment: "简体中文"),     "zh-Hans"),
                                        (LS(self, key: "English", comment: "英文"),                "en")]
        
        //********* 以上的代码需要根据app需求进行自定义
        
        
        let currentLanguage: String = CVLanguageHelper.getLanguage()
        for i in 0..<data.count {
            let one = data[i]
            let isSelected = currentLanguage == one.1
            let lang = CVLanguageModel(title: one.0, language: one.1, isSelected: isSelected)
            manager.add(language: lang)
        }
        
        self.dataSource = manager.getLanguages()
        self.tableView.register(CVChooseLanguageCell.self, forCellReuseIdentifier: "cell")
        self.tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showHUD(complete: @escaping (()->())) {
        let changeLanguageVC = CVChangeLanguageViewController()
        self.present(changeLanguageVC, animated: true, completion: complete)
    }
    
}

extension CVLanguageViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource != nil ? self.dataSource!.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CVChooseLanguageCell
        cell.selectionStyle = .none
        let model = self.dataSource![indexPath.row]
        cell.titleLabel!.text = model.title
        cell.chooseImageView!.backgroundColor = model.isSelected ? UIColor.red : UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.dataSource![indexPath.row]
        if !model.isSelected {
            model.isSelected = true
            manager.update(language: model)
            tableView.reloadData()
            
            self.showHUD(complete: {
                CVLanguageHelper.setLanguage(language: model.language)
            })
        }
    }
}
