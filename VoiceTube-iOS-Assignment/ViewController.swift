//
//  ViewController.swift
//  VoiceTube-iOS-Assignment
//
//  Created by 廖慶麟 on 2018/4/29.
//  Copyright © 2018年 廖慶麟. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

internal final class ViewController: UIViewController, Navigable {
    
    // MARK: - View Components
    var navigationBar: ColorgyNavigationBar = ColorgyNavigationBar()
    private let tableView: UITableView = UITableView()
    
    // MARK: - View Model
    var viewModel: MainViewModel = MainViewModel()
    
    // MARK: - Delegate
    var navigationTransitionDelegate: ColorgyNavigationTransitioningDelegate?
    
    // MARK: - DisposeBag
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureTableView()
        
        bind()
        
        viewModel.loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Bind
    private func bind() {
        viewModel.items
        .asObservable()
        .bind(to: tableView.rx.items(cellIdentifier: "VideoListTableViewCell", cellType: VideoListTableViewCell.self)) { (row, item, cell) in
            cell.configure(with: item)
        }.disposed(by: disposeBag)
    }
    
    // MARK: - View Configuration
    func configureNavigationBar() {
        view.addSubview(navigationBar)
        
        navigationBar.setButton(at: .right, type: .settings)
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.register(with: VideoListTableViewCell.self)
        tableView.rowHeight = 160
        tableView.separatorStyle = .none
        tableView.delegate = self
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(navigationBar.snp.bottom)
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.items.value.count - 1 {
            // which means need to load more
            viewModel.loadData()
        }
    }
}

