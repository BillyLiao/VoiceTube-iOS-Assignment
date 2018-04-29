//
//  NumberExtension.swift
//  KK-Assignment
//
//  Created by 廖慶麟 on 2018/4/11.
//  Copyright © 2018年 廖慶麟. All rights reserved.
//

import Foundation
import UIKit

extension CGFloat {
    var double: Double {
        return Double(self)
    }
    
    var int: Int {
        return Int(self)
    }
}

extension Double {
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
    
    var radianValue: Double {
        return (M_PI * self / 180.0)
    }
}

extension Int {
    var double: Double {
        return Double(self)
    }
    
    var string: String {
        return String(self)
    }
    
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
    
    func times(_ block: @escaping (_ index: Int) -> Void) {
        guard self >= 0 else { return }
        for index in 0..<self {
            autoreleasepool {
                block(index)
            }
        }
    }
    
    var int32: Int32 {
        return Int32(self)
    }
    
    var roundedToMultipleOf5: Int {
        return self - self % 5
    }
    
    /// Will transform minute number to string
    /// eg 5 -> 05
    func toMinuteString() -> String {
        let minute = self >= 10 ? "\(self)" : "0\(self)"
        return minute
    }
    
    static func random() -> Int {
        return Int(arc4random() / 2)
    }
}

extension Int32 {
    var int: Int {
        return Int(self)
    }
}
