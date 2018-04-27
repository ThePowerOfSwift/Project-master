//
//  HEChangeLanguageViewController.swift
//  Project
//
//  Created by weixhe on 2018/3/19.
//  Copyright © 2018年 com.weixhe. All rights reserved.
//

import UIKit

class HEChangeLanguageViewController: HEBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        
        let label = clabel(font: UIFont.systemFont(ofSize: 18), text: LS( self, key: "LanguageIsChanging", comment: "正在设置语言..."), textColor: UIColor.white, super: self.view)
        label.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        label.center = self.view.center
        label.textAlignment = .center
        
        let _ = DispatchQueue.main.delay(3) {
            self.dismiss(animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
