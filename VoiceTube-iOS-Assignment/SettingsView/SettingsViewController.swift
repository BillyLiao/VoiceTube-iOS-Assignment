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
    
    let tableContent: [(title: String, type: UITableViewCell.Type)] =
        [(title: "自動播放", SwitchActionCell.self),
         (title: "字幕同步",  SwitchActionCell.self),
         (title: "查詢單字時暫停播放", SwitchActionCell.self),
         (title: "推薦影片提醒", SwitchActionCell.self),
         (title: "學習通知", TapActionCell.self)]
    
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
        let cell = tableView.dequeueReusableCell(of: tableContent[indexPath.row].type, for: indexPath)!
        (cell as? SwitchActionCell)?.set(title: tableContent[indexPath.row].title, isOn: true)
        (cell as? SwitchActionCell)?.delegate = self
        (cell as? TapActionCell)?.set(title: tableContent[indexPath.row].title, detail: "10:00 AM")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        (tableView.cellForRow(at: indexPath) as? TapActionCell)?.becomeFirstResponder()
    }
}

extension SettingsViewController: SwitchActionCellDelegate {
    func switchActionCellSwitch(cell: SwitchActionCell, isOn: Bool) {
        guard let title = cell.titleLabel.text else { return }
        switch title {
        case "自動播放": Defaults[.autoPlay] = isOn
        case "字幕同步": Defaults[.subtitleEnabled] = isOn
        case "查詢單字時暫停播放": Defaults[.stopWhileQuerying] = isOn
        case "推薦影片提醒": Defaults[.recommendationNotifiable] = isOn
        default: break
        }
    }
}

