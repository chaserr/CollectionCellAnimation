//
//  NSObject+Ext.swift
//  Spider
//
//  Created by 童星 on 16/7/12.
//  Copyright © 2016年 oOatuo. All rights reserved.
//

import UIKit

public extension NSObject{

    public class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
    public var nameOfClass: String {
        return NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
    }
    
    // 同上面效果类似
    public var className: String {
        return type(of: self).className
    }
    
    public static var className: String {
        return String(describing: self)
    }
}
