//
//  CVPickerView.swift
//  Project
//
//  Created by caven on 2018/5/21.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import UIKit

private let height_tool: CGFloat     =      40
private let height_picker: CGFloat   =      216
private let height_cell: CGFloat     =      40

class CVPickerView: UIView {
    
    var dataSource: CVPickerViewDataSource?
    var delegate: CVPickerViewDelegate?
    
    var placeholder: String? { didSet {self.placeholderLabel.text = self.placeholder} }
    var placeholderColor: UIColor? { didSet {self.placeholderLabel.textColor = self.placeholderColor} }
    var placeholderFont: UIFont? { didSet {self.placeholderLabel.font = self.placeholderFont} }
    
    var cancelTitle: String = LS(key: "Cancel", comment: "取消") { didSet {self.layoutSubviews()} }
    var cancelTitleFont: UIFont = UIFont.font_15 { didSet {self.layoutSubviews()} }
    var cancelTitleColor: UIColor = UIColor.black
    
    var doneTitle: String = LS(key: "Done", comment: "确定") { didSet {self.layoutSubviews()} }
    var doneTitleFont: UIFont = UIFont.font_15 { didSet {self.layoutSubviews()} }
    var doneTitleColor: UIColor = UIColor.black
    
    var showsSelectionIndicator = true { didSet {self.maskingView.isHidden = !self.showsSelectionIndicator} }      // 显示选中的框
    
    private var contentView: UIView!
    private var pickerView: CVPick!
    private var components: Int = 0
    private var maskingView: UIView!
    private var toolBar: UIView!
    private var cancelBtn: UIButton!
    private var doneBtn: UIButton!
    lazy private var placeholderLabel: UILabel = {
        let label = cv_label(font: self.placeholderFont ?? UIFont.font_13, text: self.placeholder ?? "", super: self.toolBar)
        label.textColor = self.placeholderColor ?? UIColor.black
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        self.contentView = cv_view(frame: CGRectMake(0, 0, SCREEN_WIDTH, height_picker + height_tool + cv_safeAreaInsets.bottom), color: UIColor.white, super: self)
        self.pickerView = CVPick.init(frame: CGRectMake(0, height_tool, SCREEN_WIDTH, height_picker))
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.contentView.addSubview(self.pickerView)
//        self.maskingView = cview(frame: self.pickerView.bounds, color: UIColor.clear, super: self.pickerView)
//        self.maskingView.border(width: 0.5, color: UIColor.grayColor_cc)
        // 工具栏
        self.setupToolBar()
        
        // 添加一个tap事件
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(hidenPickerView))
        self.addGestureRecognizer(tapGes)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupToolBar() {
        self.toolBar = cv_view(frame: CGRectMake(0, 0, self.cv_width, height_tool), color: UIColor.white, super: self.contentView)
        self.cancelBtn = cv_button(bg: UIColor.white, title: self.cancelTitle, super: self.toolBar)
        self.cancelBtn.cv_titleFont = self.cancelTitleFont
        self.cancelBtn.cv_normalTitleColor = self.cancelTitleColor
        self.cancelBtn.addTarget(self, action: #selector(onCancelAction), for: .touchUpInside)
        
        self.doneBtn = cv_button(bg: UIColor.white, title: self.doneTitle, super: self.toolBar)
        self.doneBtn.cv_titleFont = self.doneTitleFont
        self.doneBtn.cv_normalTitleColor = self.doneTitleColor
        self.doneBtn.addTarget(self, action: #selector(onDoneAction), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
//        super.layoutSubviews()
        self.contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height_picker + height_tool + cv_safeAreaInsets.bottom)
      //  self.contentView.cv_bottom(0, fixHeight: true);
        self.contentView.cv_bottomEqualTo(0)
        self.pickerView.frame = CGRectMake(0, height_tool, SCREEN_WIDTH, height_picker)
//        self.maskingView.frame = self.pickerView.bounds
//        self.maskingView.frame = CGRectMake(0, (self.pickerView.height - height_cell) / 2, self.pickerView.width, height_cell)

        self.toolBar.frame = CGRectMake(0, 0, self.cv_width, height_tool)
        
        var width = self.cancelTitle.autoWidth(font: self.cancelTitleFont, fixedHeight: self.toolBar.cv_height)
        self.cancelBtn.frame = CGRectMake(5, 0, width, self.toolBar.cv_height)
        width = self.doneTitle.autoWidth(font: self.doneTitleFont, fixedHeight: self.toolBar.cv_height)
        self.doneBtn.frame = CGRectMake(self.cv_width - width - 5, 0, width, self.toolBar.cv_height)
        
        if self.placeholder != nil || self.placeholderColor != nil || self.placeholderFont != nil {
            self.placeholderLabel.frame = CGRectMake(self.cancelBtn.cv_right , 0, self.toolBar.cv_width - self.cancelBtn.cv_right - self.doneBtn.cv_left, self.toolBar.cv_height)
        }
    }
    
    /// 返回有多少列，前提是delegate和dataSource都不为空
    var numberOfComponents: Int {
        return self.components
    }
    
    /// 返回某一列有多少行
    func numberOfRows(inComponent component: Int) -> Int {
        return self.pickerView.numberOfRows(inComponent: component)
    }
    
    func rowSize(forComponent component: Int) -> CGSize {
        return self.pickerView.rowSize(forComponent: component)
    }
    
    /// 获取当前的view
    func view(forRow row: Int, forComponent component: Int) -> CVPickerViewReusingView? {
        return self.pickerView.view(forRow: row, forComponent: component) as? CVPickerViewReusingView
    }
    
    /// 刷新所有的component
    func reloadAllComponents() {
        self.pickerView.reloadAllComponents()
    }
    
    /// 刷新某一个component
    func reloadComponent(_ component: Int) {
        self.pickerView.reloadComponent(component)
    }
    
    /// 手动选中某个row
    func selectRow(_ row: Int, inComponent component: Int, animated: Bool) {
        self.pickerView.selectRow(row, inComponent: component, animated: animated)
    }
    
    /// 返回选择的行号，如果选择的行号，返回-1
    func selectedRow(inComponent component: Int) -> Int {
        return self.pickerView.selectedRow(inComponent: component)
    }
    
    
    /// Gesture
    @objc func hidenPickerView() {
        self.isHidden = true
        self.delegate?.cv_dismiss?(self)
    }
    
    // MARK: - Actions
    @objc func onCancelAction() {
        self.hidenPickerView()
        self.delegate?.cv_cancel?(self)
    }
    
    @objc func onDoneAction() {
        self.hidenPickerView()
        self.delegate?.cv_done?(self)
    }
}

extension CVPickerView: UIPickerViewDataSource , UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        if let dataSource = self.dataSource {
            self.components = dataSource.cv_numberOfComponents(in: self)
        }
        
        return self.components
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.dataSource!.cv_pickerView(self, numberOfRowsInComponent: component)
    }

    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {

        let width = self.delegate?.cv_pickerView?(self, widthForComponent: component)
        return width ?? SCREEN_WIDTH / (self.components == 0 ? SCREEN_WIDTH : CGFloat(self.components))
    }

    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        let rowHeight = self.delegate?.cv_pickerView?(self, rowHeightForComponent: component)
        return rowHeight ?? height_cell
    }

    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let cell = self.dataSource!.cv_pickerView(self, viewForRow: row, forComponent: component, reusing: view as? CVPickerViewReusingView)
        
        return cell
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.delegate?.cv_pickerView?(self, didSelectRow: row, inComponent: component)
    }
}

private class CVPick : UIPickerView {
    var selectedView: UIView?
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

