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
    var realmManager: RealmManager<ItemRealmObject> = RealmManager()

    public func loadData() {
        GetItemList().perform().then(execute: { [weak self] list -> Void in
            list.items.forEach{ ItemRealmObject($0).save(nil) }
            self?.items.value.append(contentsOf: list.items)
            return
        }).catch { [weak self] (e) in
            if let _ = self, let items = try? self!.realmManager.query().toItems() {
                self!.items.value.append(contentsOf: items)
            }
        }
    }
}
