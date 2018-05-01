//
//  TimeSettingCell.swift
//  VoiceTube-iOS-Assignment
//
//  Created by 廖慶麟 on 2018/5/1.
//  Copyright © 2018年 廖慶麟. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyUserDefaults

internal final class TimeSettingCell: UITableViewCell, SettingCellType {
    
    // MARK: - View Components
    override var inputView: UIView? {
        datePicker.setDate(Defaults[.dailyRemindTime]!, animated: false)
        return datePicker
    }
    override var inputAccessoryView: UIView? {
        let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        toolBar.barTintColor = UIColor.white
        toolBar.tintColor = self.tintColor
        let spaceButton = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(done))
        toolBar.setItems([spaceButton, doneButton], animated: false)
        return toolBar
    }
    let datePicker: UIDatePicker = UIDatePicker()
    let titleLabel: UILabel = UILabel()
    let detailLabel: UILabel = UILabel()
    
    let dateFormatter: DateFormatter = DateFormatter()
    
    // MARK: - Delegate
    weak var delegate: SettingCellDelegate?
    
    // MARK: - Key Datasource
    public private(set) var dateValue: Date = Date() {
        didSet {
            delegate?.settingCellValueChanged(cell: self)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        dateFormatter.dateFormat = "HH:mm a"
        
        configureTitleLabel()
        configureDetailLabel()
        configureDatePicker()
    }
    
    // MARK: - View Configuration
    private func configureTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    private func configureDetailLabel() {
        addSubview(detailLabel)
        
        detailLabel.textColor = tintColor
        
        detailLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    private func configureDatePicker() {
        datePicker.datePickerMode = .time
        datePicker.backgroundColor = UIColor.white
    }
    
    public func set(title: String, date: Date) {
        titleLabel.text = title
        detailLabel.text = dateFormatter.string(from: date)
    }
    
    // MARK: - Input View Handler
    @objc func done() {
        detailLabel.text = dateFormatter.string(from: datePicker.date)
        dateValue = datePicker.date
        
        self.resignFirstResponder()
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
}

