//
//  HESettingCell.swift
//  Project
//
//  Created by weixhe on 2018/3/23.
//  Copyright © 2018年 com.weixhe. All rights reserved.
//

import UIKit

class HESettingCell: UITableViewCell {
    
    var titleLabel: UILabel?
    var detailLabel: UILabel?
    var switchBar: UISwitch?
    

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel = clabel(font: UIFont.systemFont(ofSize: 15), text: nil, super: self.contentView)
        titleLabel!.frame = CGRect(x: 10, y: 0, width: SCREEN_WIDTH - 20, height: self.frame.height)
        
        detailLabel = clabel(font: UIFont.systemFont(ofSize: 15), text: nil, super: self.contentView)
        detailLabel!.frame = CGRect(x: SCREEN_WIDTH - 10 - 100, y: 0, width: 100, height: self.frame.height)
        detailLabel!.textAlignment = .right
        detailLabel!.textColor = UIColor(hex: 0x999999)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
