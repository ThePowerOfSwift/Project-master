//
//  HESettingViewController.swift
//  Project
//
//  Created by weixhe on 2018/3/15.
//  Copyright © 2018年 com.weixhe. All rights reserved.
//

import UIKit

class HESettingViewController: HEBaseViewController {

    var dataSource: [HESettingModel]?
    var cacheSize: String = ""
    
    
    lazy var tableView: UITableView = {
        let tableView = ctableView(delegate: self, dataSource: self, super: self.view)
        tableView.frame = CGRect.init(x: 0, y: navigation_height(), width: SCREEN_WIDTH, height: thisViewHeight)
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = LS(self, key: "Title", comment: "设置")
        
        // 计算缓存
        self.cacheSize = HEFileHandle.fileSizeFormat(HEFileHandle.fileSize(atPath: CachesPath) + HEFileHandle.fileSize(atPath: TmpPath))
        let langu = HESettingModel.init(LS(self, key: "LanguageSetting", comment: "语言"), .language, nil)
        let cache = HESettingModel.init(LS(self, key: "CleanCache", comment: "清空缓存"), .cleanCache, cacheSize)
        let version = HESettingModel.init(LS(self, key: "AppVersion", comment: "版本"), .appVersion, "v\(COM.appVersion)")
        self.dataSource = [langu, cache, version]
        self.tableView.register(HESettingCell.self, forCellReuseIdentifier: "cell")
        self.tableView.tableFooterView = UIView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HESettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource != nil ? self.dataSource!.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HESettingCell
        let one = self.dataSource![indexPath.row]
        cell.titleLabel!.text = one.title
        cell.detailLabel!.text = one.detail
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let one = self.dataSource![indexPath.row]
        switch one.key {
        case .language:
            let languageVC = HELanguageViewController()
            self.navigationController!.pushViewController(languageVC, animated: true)
        case .cleanCache:
            HEFileHandle.cleanCache()
            let cell = tableView.cellForRow(at: indexPath) as! HESettingCell
            cell.detailLabel!.text = "0K"
        default:
            HELog(message: "Other")
        }
    }
}
