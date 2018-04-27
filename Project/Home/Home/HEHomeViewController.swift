//
//  ViewController.swift
//  Project
//
//  Created by weixhe on 2018/3/6.
//  Copyright © 2018年 com.weixhe. All rights reserved.
//

import UIKit


class HEHomeViewController: HEBaseViewController {

    var hidenNav = false
    var tableView: UITableView!
    var viewModel: HEHomeViewModel = HEHomeViewModel()
    lazy var imageView = cimageView(image: nil, super: self.view)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = LS(self, key: "Title", comment: "首页")
        
        self.tableView = ctableView(delegate: self, dataSource: self, super: self.view)
        self.tableView.tableFooterView = cview(super: nil)
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(navigation_height())
            make.height.equalTo(thisViewHeight)
        }
        
        let headerView = HEHomeHeaderView()
        self.tableView.tableHeaderView = headerView
        self.viewModel.loadBanner { (data: [HECycleScrollModel], finish) in
            headerView.banner.dataSource = data
        }
        
        self.tableView.refreshing {
            [weak self] in
            self?.viewModel.loadData { (data) in
                self?.tableView.endRefreshing(isSuccess: true)
                self?.tableView.endLoadMore(isNoMoreData: false)
                self?.tableView.reloadData()
            }
        }
        self.tableView.loadingMore  {
            [weak self] in
            self?.viewModel.loadMoreData { (data, noMoreData) in
                if noMoreData {
                    self?.tableView.endLoadMore(isNoMoreData: noMoreData)
                } else {
                    self?.tableView.endLoadMore(isNoMoreData: noMoreData)
                    self?.tableView.reloadData()
                }
            }

        }
        
        self.tableView.startRefreshing()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
}

extension HEHomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        let model = self.viewModel.dataSource[indexPath.row]
        cell.textLabel?.text = model.text! + " \(String(describing: model.number))"
        return cell
    }
    
}


