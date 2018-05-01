//
//  SettingCellType.swift
//  VoiceTube-iOS-Assignment
//
//  Created by 廖慶麟 on 2018/5/1.
//  Copyright © 2018年 廖慶麟. All rights reserved.
//

import Foundation
import UIKit

protocol SettingCellDelegate: class {
    func settingCellValueChanged(cell: UITableViewCell)
}

protocol SettingCellType: class {
    weak var delegate: SettingCellDelegate? { get set }
}
