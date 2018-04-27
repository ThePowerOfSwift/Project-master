//
//  HEChooseLanguageCell.swift
//  Project
//
//  Created by weixhe on 2018/3/16.
//  Copyright © 2018年 com.weixhe. All rights reserved.
//

import UIKit

class HEChooseLanguageCell: UITableViewCell {

    var titleLabel: UILabel?
    var chooseImageView: UIImageView?
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.titleLabel = clabel(font: UIFont.systemFont(ofSize: 15), text: nil, textColor: UIColor.black, super: self.contentView)
        self.titleLabel!.frame = CGRect.init(x: 10, y: 0, width: SCREEN_WIDTH - 30, height: self.frame.height)
        self.chooseImageView = cimageView(image: nil, super: self.contentView)
        self.chooseImageView?.frame = CGRect.init(x: SCREEN_WIDTH - 30, y: self.frame.height / 2 - 5, width: 10, height: 10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
