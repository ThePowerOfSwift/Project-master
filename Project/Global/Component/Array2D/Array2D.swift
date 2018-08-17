//
//  Array2D.swift
//  Project
//
//  Created by caven on 2018/8/15.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import Foundation

/*
 使用方法：
 
 // 创建一个二维数组的实例
    var cookies = Array2D(columns: 9, rows: 7, initialValue: 0)
 
 // 运用下标==subscript==函数可以检索数组中的值
    let myCookie = cookies[column, row]
 
 // 可以改变数组中的某一个值
    cookies[column, row] = newCookie
 */


public struct Array2D<T> {
    public let columns: Int
    public let rows: Int
    fileprivate var array: [T]
    
    public init(columns: Int, rows: Int, initialValue: T) {
        self.columns = columns
        self.rows = rows
        array = .init(repeating: initialValue, count: rows*columns)
    }
    
    public subscript(column: Int, row: Int) -> T {
        get {
            precondition(column < columns, "Column \(column) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
            precondition(row < rows, "Row \(row) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
            return array[row*columns + column]
        }
        set {
            precondition(column < columns, "Column \(column) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
            precondition(row < rows, "Row \(row) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
            array[row*columns + column] = newValue
        }
    }
}

