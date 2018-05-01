//
//  SettingRow.swift
//  VoiceTube-iOS-Assignment
//
//  Created by 廖慶麟 on 2018/5/1.
//  Copyright © 2018年 廖慶麟. All rights reserved.
//

import Foundation
import UIKit

internal class SettingRow {
    
    let title: String
    let action: ((SettingRow)->())?
    let cellType: UITableViewCell.Type
    
    init(title: String, cellType: UITableViewCell.Type, action: ((SettingRow)->())?) {
        self.title = title
        self.action = action
        self.cellType = cellType
    }
}

class SwitchRow: SettingRow {
    typealias T = Bool
    var data: T = true
    
    init(title: String, cellType: UITableViewCell.Type = SwitchActionCell.self, data: T, action: ((SettingRow)->())?) {
        super.init(title: title, cellType: cellType, action: action)
        self.data = data
    }
}

class TimeRow: SettingRow {
    typealias T = Date
    var data: T = Date()
    
    init(title: String, cellType: UITableViewCell.Type = TimeSettingCell.self, data: T, action: ((SettingRow)->())?) {
        super.init(title: title, cellType: cellType, action: action)
        self.data = data
    }
}


