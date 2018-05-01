//
//  SettingsViewController.swift
//  VoiceTube-iOS-Assignment
//
//  Created by 廖慶麟 on 2018/4/30.
//  Copyright © 2018年 廖慶麟. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

internal final class SettingsViewController: UIViewController, Navigable {

    // MARK: - View Components
    var navigationBar: ColorgyNavigationBar = ColorgyNavigationBar()
    let tableView: UITableView = UITableView()
    
    let tableContent: [SettingRow] =
    [SwitchRow.init(title: "自動播放", switchValue: Defaults[.autoPlay], action: { (row) in Defaults[.autoPlay] = (row as! SwitchRow).switchValue }),
     SwitchRow.init(title: "字幕同步", switchValue: Defaults[.subtitleEnabled], action: { row in Defaults[.subtitleEnabled] = (row as! SwitchRow).switchValue }),
     SwitchRow.init(title: "查詢影片時暫停播放", switchValue: Defaults[.stopWhileQuerying], action: { row in Defaults[.stopWhileQuerying] = (row as! SwitchRow).switchValue }),
     SwitchRow.init(title: "推薦影片提醒", switchValue: Defaults[.recommendationNotifiable], action: { row in Defaults[.recommendationNotifiable] = (row as! SwitchRow).switchValue }),
     TimeRow.init(title: "學習通知", date: Defaults[.dailyRemindTime]!, action: { row in Defaults[.dailyRemindTime] = (row as! TimeRow).date })]
    
    // MARK: - Delegate
    var navigationTransitionDelegate: ColorgyNavigationTransitioningDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.isUserInteractionEnabled = true

        // Do any additional setup after loading the view.
        configureNavigationBar()
        configureTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - View Configuration
    func configureNavigationBar() {
        view.addSubview(navigationBar)
        navigationBar.setButton(at: .left, type: .back)
        navigationBar.title = "Settings"
        navigationBar.delegate = self
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(with: SwitchActionCell.self)
        tableView.register(with: TapActionCell.self)
        tableView.tableFooterView = UIView()
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(navigationBar.snp.bottom)
        }
    }
}

extension SettingsViewController: ColorgyNavigationBarDelegate {
    func colorgyNavigationBarBackButtonClicked() {
        asyncDismiss(true)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableContent.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = tableContent[indexPath.row]
        let cell = tableView.dequeueReusableCell(of: row.cellType, for: indexPath)!
        (cell as? SwitchActionCell)?.set(title: row.title, isOn: (row as? SwitchRow)?.switchValue ?? true)
        (cell as? TapActionCell)?.set(title: row.title, date: (row as? TimeRow)?.date ?? Date())
        (cell as? SettingCellType)?.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        (tableView.cellForRow(at: indexPath) as? TapActionCell)?.becomeFirstResponder()
    }
}
extension SettingsViewController: SettingCellDelegate {
    func settingCellValueChanged(cell: UITableViewCell) {
        guard let rowIndex = tableView.indexPath(for: cell)?.row else { return }
        let row = tableContent[rowIndex]
        (row as? SwitchRow)?.switchValue = (cell as? SwitchActionCell)?.switchValue ?? true
        (row as? TimeRow)?.date = (cell as? TapActionCell)?.dateValue ?? Date()
        row.action?(row)
    }
}
