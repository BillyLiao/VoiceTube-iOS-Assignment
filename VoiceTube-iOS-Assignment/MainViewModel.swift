//
//  MainViewModel.swift
//  VoiceTube-iOS-Assignment
//
//  Created by 廖慶麟 on 2018/4/29.
//  Copyright © 2018年 廖慶麟. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public class MainViewModel {
    let items: Variable<[Item]> = Variable([])

    public func loadData() {
        GetItemList().perform().then(execute: { [weak self] list in
            self?.items.value.append(contentsOf: list.items)
        })
    }
}
