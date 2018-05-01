//
//  SwitchActionCell.swift
//  VoiceTube-iOS-Assignment
//
//  Created by 廖慶麟 on 2018/4/30.
//  Copyright © 2018年 廖慶麟. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyUserDefaults

internal final class SwitchActionCell: UITableViewCell, SettingCellType {

    // MARK: - View Components
    let titleLabel: UILabel = UILabel()
    let switchButton: UISwitch = UISwitch()
    
    public var switchValue: Bool = true {
        didSet {
            delegate?.settingCellValueChanged(cell: self)
        }
    }
    
    // MARK: - Delegate
    weak var delegate: SettingCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        configureTitleLabel()
        configureSwitchButton()
    }

    // MARK: - View Configuration
    private func configureTitleLabel() {
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    private func configureSwitchButton() {
        addSubview(switchButton)
        
        switchButton.onTintColor = tintColor
        switchButton.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        
        switchButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    public func set(title: String, isOn: Bool) {
        titleLabel.text = title
        switchButton.isOn = isOn
    }
    
    // MARK: - Handler
    @objc func switchValueChanged() {
        switchValue = switchButton.isOn
    }
}
