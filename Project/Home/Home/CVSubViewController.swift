//
//  CVSubViewController.swift
//  Project
//
//  Created by caven on 2018/6/20.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit

class CVSubViewController: CVBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var showTableView = true
    var cate: String = ""
    
    var tableView: UITableView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if showTableView {
            self.tableView = ctableView(delegate: self, dataSource: self, super: self.view)
            self.tableView?.frame = self.view.bounds
            self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        } else {
            let label = clabel(font: UIFont.systemFont(ofSize: 14), text: cate, super: self.view)
            label.frame = CGRectMake(50, 100, 100, 90)
            label.backgroundColor = UIColor.brown
            label.textColor = UIColor.white
            label.textAlignment = .center
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell!.textLabel?.text = "\(self.cate) -- \(indexPath.row)"
        
        return cell!
    }

}
