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
func cv_view(frame: CGRect = CGRect.zero, color: UIColor = UIColor.white, super: UIView?) -> UIView {
    let view = UIView(frame: frame)
    view.backgroundColor = color
    if `super` != nil { `super`!.addSubview(view) }
    return view
}

// MARK: - UILabel Create
func cv_label(font: UIFont, text: String?, textColor: UIColor = UIColor.black, super: UIView?) -> UILabel {
    let label = UILabel(frame: CGRect.zero)
    label.font = font
    label.text = text
    label.textColor = textColor
    if `super` != nil { `super`!.addSubview(label) }
    return label
}

func cv_label_mul(font: UIFont, text: String?, textColor: UIColor = UIColor.black, super: UIView?) -> UILabel {
    let label = cv_label(font: font, text: text, textColor: textColor, super: `super`)
    label.numberOfLines = 0
    return label
}

// MARK: - UITextField Create
func cv_textField(font: UIFont, placeholder: String?, delegate: Any? = nil, super: UIView?) -> UITextField {
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
func cv_textView(font: UIFont, placeholder: String?, delegate: Any? = nil, super: UIView?) -> CVPlaceholderTextView {
    let textView = CVPlaceholderTextView(frame: CGRect.zero)
    textView.textView.font = font
    textView.placeholder = placeholder ?? ""
    textView.textView.delegate = delegate as? UITextViewDelegate
    if `super` != nil { `super`!.addSubview(textView) }
    return textView
}

// MARK: - UIImageView Create
func cv_imageView(image: UIImage?, highlightImage: UIImage? = nil, super: UIView?) -> UIImageView {
    let imageView = UIImageView(frame: CGRect.zero)
    imageView.image = image
    imageView.highlightedImage = highlightImage ?? image
    imageView.contentMode = .scaleAspectFit
    if `super` != nil { `super`!.addSubview(imageView) }
    return imageView
}


// MARK: - UIButton Create
func cv_button(bg: UIColor?, title: String?, color: UIColor? = UIColor.blue, super: UIView?) -> UIButton {
    let button = UIButton(type: UIButtonType.custom)
    button.backgroundColor = bg
    button.cv_setTitle(title, color: color, state: .normal)
    if `super` != nil { `super`!.addSubview(button) }
    return button
}

func cv_button(bg: UIColor?, image: UIImage?, super: UIView?) -> UIButton {
    let button = cv_button(bg: bg, title: nil, color: nil, super: `super`)
    button.setImage(image, for: .normal)
    return button
}

// MARK: - UIScrollView Create
func cv_scrollView(delegate: Any?, pagingEnabled: Bool = false, super: UIView?) -> UIScrollView {
    let scrollView = UIScrollView(frame: CGRect.zero)
    scrollView.delegate = delegate as? UIScrollViewDelegate
    scrollView.isPagingEnabled = pagingEnabled
    if `super` != nil { `super`!.addSubview(scrollView) }
    return scrollView
}

// MARK: - UITableView Create
func cv_tableView(delegate: Any?, dataSource: Any?, super: UIView?) -> UITableView {
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    tableView.delegate = delegate as? UITableViewDelegate
    tableView.dataSource = dataSource as? UITableViewDataSource
    if `super` != nil { `super`!.addSubview(tableView) }
    return tableView
}

func cv_tableView_group(delegate: Any?, dataSource: Any?, super: UIView?) -> UITableView {
    let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    tableView.delegate = delegate as? UITableViewDelegate
    tableView.dataSource = dataSource as? UITableViewDataSource
    if `super` != nil { `super`!.addSubview(tableView) }
    return tableView
}

// MARK: - UICollectionView Create
func cv_collectionViwe(delegate: Any?, dataSource: Any?, super: UIView?) -> UICollectionView {
    return cv_collectionView(delegate: delegate, dataSource: dataSource, layout: UICollectionViewFlowLayout(), super: `super`)
}

func cv_collectionView(delegate: Any?, dataSource: Any?, layout: UICollectionViewLayout, super: UIView?) -> UICollectionView {
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
    collectionView.delegate = delegate as? UICollectionViewDelegate
    collectionView.dataSource = dataSource as? UICollectionViewDataSource
    if `super` != nil { `super`!.addSubview(collectionView) }
    return collectionView
}

// MARK: - UIWebView Create
func cv_webView(delegate: Any?, super: UIView?) -> UIWebView {
    let webView = UIWebView(frame: CGRect.zero)
    webView.delegate = delegate as? UIWebViewDelegate
    if `super` != nil { `super`!.addSubview(webView) }
    return webView
}

// MARK: - CVPickerView Create
func cv_cpickerView(delegate: CVPickerViewDelegate, dataSource: CVPickerViewDataSource, super: UIView?) -> CVPickerView {
    let pickerView = CVPickerView(frame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))
    pickerView.delegate = delegate
    pickerView.dataSource = dataSource
    if `super` != nil { `super`!.addSubview(pickerView) }
    return pickerView
}
