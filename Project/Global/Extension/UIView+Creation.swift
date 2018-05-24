//
//  UIView+Creation.swift
//  Project
//
//  Created by caven on 2018/3/16.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIView Create
func cview(frame: CGRect = CGRect.zero, color: UIColor = UIColor.white, super: UIView?) -> UIView {
    let view = UIView(frame: frame)
    view.backgroundColor = color
    if `super` != nil { `super`!.addSubview(view) }
    return view
}

// MARK: - UILabel Create
func clabel(font: UIFont, text: String?, textColor: UIColor = UIColor.black, super: UIView?) -> UILabel {
    let label = UILabel(frame: CGRect.zero)
    label.font = font
    label.text = text
    label.textColor = textColor
    if `super` != nil { `super`!.addSubview(label) }
    return label
}

func clabel_mul(font: UIFont, text: String?, textColor: UIColor = UIColor.black, super: UIView?) -> UILabel {
    let label = clabel(font: font, text: text, textColor: textColor, super: `super`)
    label.numberOfLines = 0
    return label
}

// MARK: - UITextField Create
func ctextField(font: UIFont, placeholder: String?, delegate: Any? = nil, super: UIView?) -> UITextField {
    let textField = UITextField(frame: CGRect.zero)
    textField.font = font
    textField.placeholder = placeholder
    textField.returnKeyType = .done
    textField.clearButtonMode = .whileEditing
    textField.delegate = delegate as? UITextFieldDelegate
    if `super` != nil { `super`!.addSubview(textField) }
    return textField
}

// MARK: - UITextView Create
func ctextView(font: UIFont, placeholder: String?, delegate: Any? = nil, super: UIView?) -> CVPlaceholderTextView {
    let textView = CVPlaceholderTextView(frame: CGRect.zero)
    textView.textView.font = font
    textView.placeholder = placeholder ?? ""
    textView.textView.delegate = delegate as? UITextViewDelegate
    if `super` != nil { `super`!.addSubview(textView) }
    return textView
}

// MARK: - UIImageView Create
func cimageView(image: UIImage?, super: UIView?) -> UIImageView {
    let imageView = UIImageView(frame: CGRect.zero)
    imageView.image = image
    imageView.isUserInteractionEnabled = true
    if `super` != nil { `super`!.addSubview(imageView) }
    return imageView
}

// MARK: - UIButton Create
func cbutton(bg: UIColor?, title: String?, color: UIColor? = UIColor.blue, super: UIView?) -> UIButton {
    let button = UIButton(type: UIButtonType.custom)
    button.cv_setTitle(title, color: color, state: .normal)
    if `super` != nil { `super`!.addSubview(button) }
    return button
}

func cbutton(bg: UIColor?, image: UIImage?, super: UIView?) -> UIButton {
    let button = cbutton(bg: bg, title: nil, color: nil, super: `super`)
    button.setImage(image, for: .normal)
    return button
}

// MARK: - UIScrollView Create
func cscrollView(delegate: Any?, pagingEnabled: Bool = false, super: UIView?) -> UIScrollView {
    let scrollView = UIScrollView(frame: CGRect.zero)
    scrollView.delegate = delegate as? UIScrollViewDelegate
    scrollView.isPagingEnabled = pagingEnabled
    if `super` != nil { `super`!.addSubview(scrollView) }
    return scrollView
}

// MARK: - UITableView Create
func ctableView(delegate: Any?, dataSource: Any?, super: UIView?) -> UITableView {
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    tableView.delegate = delegate as? UITableViewDelegate
    tableView.dataSource = dataSource as? UITableViewDataSource
    if `super` != nil { `super`!.addSubview(tableView) }
    return tableView
}

func ctableView_group(delegate: Any?, dataSource: Any?, super: UIView?) -> UITableView {
    let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    tableView.delegate = delegate as? UITableViewDelegate
    tableView.dataSource = dataSource as? UITableViewDataSource
    if `super` != nil { `super`!.addSubview(tableView) }
    return tableView
}

// MARK: - UICollectionView Create
func ccollectionViwe(delegate: Any?, dataSource: Any?, super: UIView?) -> UICollectionView {
    return ccollectionView(delegate: delegate, dataSource: dataSource, layout: UICollectionViewFlowLayout(), super: `super`)
}

func ccollectionView(delegate: Any?, dataSource: Any?, layout: UICollectionViewLayout, super: UIView?) -> UICollectionView {
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
    collectionView.delegate = delegate as? UICollectionViewDelegate
    collectionView.dataSource = dataSource as? UICollectionViewDataSource
    if `super` != nil { `super`!.addSubview(collectionView) }
    return collectionView
}

// MARK: - UIWebView Create
func cwebView(delegate: Any?, super: UIView?) -> UIWebView {
    let webView = UIWebView(frame: CGRect.zero)
    webView.delegate = delegate as? UIWebViewDelegate
    if `super` != nil { `super`!.addSubview(webView) }
    return webView
}

// MARK: - CVPickerView Create
func cpickerView(delegate: CVPickerViewDelegate, dataSource: CVPickerViewDataSource, super: UIView?) -> CVPickerView {
    let pickerView = CVPickerView(frame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))
    pickerView.delegate = delegate
    pickerView.dataSource = dataSource
    if `super` != nil { `super`!.addSubview(pickerView) }
    return pickerView
}
