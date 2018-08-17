//
//  Bundle+Extension.swift
//  Project
//
//  Created by caven on 2018/7/31.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import Foundation
extension Bundle {
    func cv_path(forResource name: String?, ofType ext: String?) -> String? {
        
        var path = self.path(forResource: name, ofType: ext)
        if path != nil {
            return path!
        }
        
        let scale = UIScreen.main.scale
        if abs(scale - 3) <= 0.001 {
            path = self.cv_path_3x(forResource: name, ofType: ext)
            if path == nil {
                path = self.cv_path_2x(forResource: name, ofType: ext)
                if path == nil {
                    path = self.cv_path_x(forResource: name, ofType: ext)
                }
            }
        } else if abs(scale - 2) <= 0.001 {
            path = self.cv_path_2x(forResource: name, ofType: ext)
            if path == nil {
                path = self.cv_path_3x(forResource: name, ofType: ext)
                if path == nil {
                    path = self.cv_path_x(forResource: name, ofType: ext)
                }
            }
        } else {
            path = self.cv_path_x(forResource: name, ofType: ext)
            if path == nil {
                path = self.cv_path_2x(forResource: name, ofType: ext)
                if path == nil {
                    path = self.cv_path_3x(forResource: name, ofType: ext)
                }
            }
        }
        
        return path!
    }
    
    private func cv_path_3x(forResource name: String?, ofType ext: String?) -> String? {
        var tempName: String?
        var path: String?
        
        if (name?.hasSuffix("@3x"))! {
            tempName = name
        } else if (name?.hasSuffix("@2x"))! {
            tempName = name?.subString(to: (name?.count)! - 3).appending("@3x")
        } else {
            tempName = name?.appending("@3x")
        }
        path = self.path(forResource: tempName, ofType: ext)
        return path
        
    }
    
    private func cv_path_2x(forResource name: String?, ofType ext: String?) -> String? {
        var tempName: String?
        var path: String?
        
        if (name?.hasSuffix("@3x"))! {
            tempName = name?.subString(to: (name?.count)! - 3).appending("@2x")
        } else if (name?.hasSuffix("@2x"))! {
            tempName = name
        } else {
            tempName = name?.appending("@2x")
        }
        path = self.path(forResource: tempName, ofType: ext)
        return path
    }
    
    private func cv_path_x(forResource name: String?, ofType ext: String?) -> String? {
        var tempName: String?
        var path: String?
        
        if (name?.hasSuffix("@3x"))! {
            tempName = name?.subString(to: (name?.count)! - 3)
        } else if (name?.hasSuffix("@2x"))! {
            tempName = name?.subString(to: (name?.count)! - 3)
        } else {
            tempName = name
        }
        path = self.path(forResource: tempName, ofType: ext)
        return path
    }
}
