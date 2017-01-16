//
//  String+Ext.swift
//  Spider
//
//  Created by 童星 on 16/6/28.
//  Copyright © 2016年 oOatuo. All rights reserved.
//

import UIKit


extension String{
    
    var OCString:NSString{
        
        get{
            
            return self as NSString
        }
    }
    
    var lengths:Int{
        
        get{
            
            return self.characters.count
        }
    }
    
    func stringByAppendingPathComponent(pathConmonent:String) -> String
    {
        return self.OCString.appendingPathComponent(pathConmonent) as String
    }
    
    var stringByDeletingPathExtension: String {
    
        get{
        
            return self.OCString.deletingPathExtension
        }
    }
    
    var pathExtension:String{
    
        get{
        
            return self.OCString.pathExtension
        }
    }
    
    var lastPathComponent:String{
        
        get{
            
            return self.OCString.lastPathComponent
        }
    }
    
    func isAllDigit() -> Bool {
        let scanner = Scanner (string: self)
        var val: Int = 0
        return scanner.scanInt(&val) && scanner.isAtEnd
    }
    
}
