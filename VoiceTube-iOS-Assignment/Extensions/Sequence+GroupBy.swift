//
//  Sequence+GroupBy.swift
//  KK-Assignment
//
//  Created by 廖慶麟 on 2018/4/10.
//  Copyright © 2018年 廖慶麟. All rights reserved.
//

import Foundation

extension Sequence {
    func group<U: Hashable>(by key: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
        return Dictionary.init(grouping: self, by: key)
    }
}
