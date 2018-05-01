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
    var switchValue: Bool = true
    
    init(title: String, cellType: UITableViewCell.Type = SwitchActionCell.self, switchValue: Bool, action: ((SettingRow)->())?) {
        super.init(title: title, cellType: cellType, action: action)
        self.switchValue = switchValue
    }
}

class TimeRow: SettingRow {
    var date: Date = Date()
    
    init(title: String, cellType: UITableViewCell.Type = TapActionCell.self, date: Date, action: ((SettingRow)->())?) {
        super.init(title: title, cellType: cellType, action: action)
        self.date = date
    }
}


