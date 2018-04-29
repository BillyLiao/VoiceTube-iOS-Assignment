//
//  CGFloat+Int+UIView.swift
//  KK-Assignment
//
//  Created by 廖慶麟 on 2018/4/11.
//  Copyright © 2018年 廖慶麟. All rights reserved.
//

import Foundation
import UIKit

extension Int {
    func point(below view: UIView) -> CGFloat {
        return view.frame.maxY + self.cgFloat
    }
    
    func pointRight(from view: UIView) -> CGFloat {
        return view.frame.maxX + self.cgFloat
    }
}

extension CGFloat {
    func point(below view: UIView) -> CGFloat {
        return view.frame.maxY + self
    }
}
