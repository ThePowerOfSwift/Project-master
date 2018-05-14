//
//  SelfAware.swift
//  Project
//
//  Created by caven on 2018/3/15.
//  Copyright © 2018年 com.caven. All rights reserved.
//

import Foundation
import UIKit

/*
 第一步：定义协议
 
 定义下面的swift代码，包含一个protocal 和 class。目的是为所有类提供一个简单的入口点来达到类似initialize的效果。你可以自定义一个类
 来实现SelfAware协议。SelfAware协议内有一个awake方法，该方法是初始化代码的核心方法。
 */
public protocol SelfAware: class { // 定义SelfAware协议
    static func awake()
}

class NothingToSeeHere {
    static func harmlessFunction() {
        let typeCount = Int(objc_getClassList(nil, 0))
        let types = UnsafeMutablePointer<AnyClass?>.allocate(capacity: typeCount)
        let autoreleaseintTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
        objc_getClassList(autoreleaseintTypes, Int32(typeCount)) // 获取所有的类
        for index in 0 ..< typeCount {
            (types[index] as? SelfAware.Type)?.awake() // 如果该类实现了SelfAware协议，那么调用awake方法
        }
        types.deallocate(capacity: typeCount)
    }
}


/*
 第二步：让APP启动时只执行一次harmlessFunction方法
 
 有了上面的代码，现在还有一种重要的事情，就是让APP启动的时侯运行NothingToSeeHere.harmlessFunction方法。先前，这个一般最好使用Objc来
 实现这个功能，但是在这在里只能使用Swift，参考以下代码
 */
extension UIApplication {
    private static let runOnce: Void = { // 使用静态属性以保证只调用一次(该属性是个方法)
        NothingToSeeHere.harmlessFunction()
    }()
    
    open override var next: UIResponder? { // 重写next属性
        UIApplication.runOnce
        return super.next
    }
}

/*
 使用：
 第三步：自定义类实现SelfAware协议，重写awake方法
 
 接下来的事情就很简单了，现在我们在App启动的时侯有了入口点，还有在启动过程中勾住启动点的类，剩下你只要自定义一个类实现SelfAware即可
 */
class ProjectStart: SelfAware {
    static func awake() {
       // your code
    }
}
