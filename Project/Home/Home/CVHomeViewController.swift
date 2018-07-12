
//
//  CVHomeViewController.swift
//  Project
//
//  Created by caven on 2018/3/6.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit


class CVHomeViewController: CVBaseViewController {

    var hidenNav = false
    var tableView: UITableView!
    var viewModel: CVHomeViewModel = CVHomeViewModel()
    lazy var imageView = cv_imageView(image: nil, super: self.view)
    var pickView: CVPickerView!
    var sheet: CVActionSheet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = LS(self, key: "Title", comment: "首页")
        
        self.tableView = cv_tableView(delegate: self, dataSource: self, super: self.view)
        self.tableView.tableFooterView = cv_view(super: nil)
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(cv_safeNavBarHeight)
            make.height.equalTo(thisViewHeight)
        }

        let headerView = CVHomeHeaderView()
        self.tableView.tableHeaderView = headerView
        self.viewModel.loadBanner { (data: [CVCycleScrollModel], finish) in
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

extension CVHomeViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        
        let vc1 = UIViewController()
        vc1.view.backgroundColor = UIColor.orange
        
        cv_AppDelegate.register3D_TouchInController(self, for: cell, locationVC: vc1, commitVC: CVNormalCalendarViewController())
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
//            CVHUD.showFullScreenHUD(message: "hello")
//                CVHUD.showMessageHUD message: "message")
            CVHUD.showWaittingHUD(message: "hello", onView: self.view, superClickable: true)
//            CVHUD.showMessageHUD(message: "恭喜你！！！！！！！！", delay: 4)
//            CVHUD.showSucceedHUD(message: "SUCCESS")
//            CVHUD.showWarningHUD(message: "fasdfasfsfasfasfasfasfasfasfasdfasdfasfasdfafadasdfadfasdfadfadfadfadfadfadfadsfadfadfadfadfadfadfadfadfadfadfadfadfad")
           
//            let vc = CVNormalCalendarViewController()
//            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 1 {

            let vc = CVTestViewController()
            vc.index = indexPath.row
            self.navigationController?.pushViewController(vc, animated: true)

        } else if indexPath.row == 2 {
            let vc = CVTestViewController()
            vc.index = indexPath.row
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 3 {

            let vc = CVTestViewController()
            vc.index = indexPath.row
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension CVHomeViewController : CVPickerViewDelegate, CVPickerViewDataSource {
    func cv_numberOfComponents(in pickerView: CVPickerView) -> Int {
        return 3
    }
    
    func cv_pickerView(_ pickerView: CVPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 50
    }
    
    
    func cv_pickerView(_ pickerView: CVPickerView, viewForRow row: Int, forComponent component: Int, reusing view: CVPickerViewReusingView?) -> CVPickerViewReusingView {
        var cell = view
        if cell == nil {
            cell = CVPickerViewReusingView()
        }
        cell!.textLabel.text = "\(component)-\(row)"
        if (component == 0 && row == 0) {
            cell!.textLabel.text = "asdfasfsdfdsafafsfasdfsfdassdasfadadafsdafsdfadfadfasdfasdfasfdsa"
            cell!.textLabel.numberOfLines = 0
        }
        return cell!
    }
    
    func cv_cancel(_ pickerView: CVPickerView) {
        CVLog("Cancel PickerView")
    }
    
    func cv_done(_ pickerView: CVPickerView) {
        CVLog("Done PickerView")
    }
    
    func cv_pickerView(_ pickerView: CVPickerView, didSelectRow row: Int, inComponent component: Int) {
        CVLog("clickItem: \(component)-\(row)")
    }
}
