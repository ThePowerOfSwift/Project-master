//
//  CVPickerViewProtocol.swift
//  Project
//
//  Created by caven on 2018/5/21.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit

protocol CVPickerViewDataSource: class {
    func cv_numberOfComponents(in pickerView: CVPickerView) -> Int
    func cv_pickerView(_ pickerView: CVPickerView, numberOfRowsInComponent component: Int) -> Int
    func cv_pickerView(_ pickerView: CVPickerView, viewForRow row: Int, forComponent component: Int, reusing view: CVPickerViewReusingView?) -> CVPickerViewReusingView
}

@objc protocol CVPickerViewDelegate: class {
    @objc optional func cv_pickerView(_ pickerView: CVPickerView, widthForComponent component: Int) -> CGFloat
    @objc optional func cv_pickerView(_ pickerView: CVPickerView, rowHeightForComponent component: Int) -> CGFloat
    @objc optional func cv_pickerView(_ pickerView: CVPickerView, didSelectRow row: Int, inComponent component: Int)
    @objc optional func cv_cancel(_ pickerView: CVPickerView)
    @objc optional func cv_done(_ pickerView: CVPickerView)
    @objc optional func cv_dismiss(_ pickerView: CVPickerView)

}
