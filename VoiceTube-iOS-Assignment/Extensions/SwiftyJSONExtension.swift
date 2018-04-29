//
//  SwiftyJSONExtension.swift
//  KK-Assignment
//
//  Created by 廖慶麟 on 2018/4/10.
//  Copyright © 2018年 廖慶麟. All rights reserved.
//

import Foundation
import SwiftyJSON

extension JSON {
    /// Check if json is an array.
    var isArray: Bool {
        return self.type == SwiftyJSON.Type.array
    }
}
