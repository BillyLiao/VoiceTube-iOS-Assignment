//
//  ItemRealmObject.swift
//  VoiceTube-iOS-Assignment
//
//  Created by 廖慶麟 on 2018/5/1.
//  Copyright © 2018年 廖慶麟. All rights reserved.
//

import Foundation

internal final class ItemRealmObject: RealmObject {
    @objc dynamic var imageURLString: String = ""
    @objc dynamic var title: String = ""
    
    convenience init(_ item: Item) {
        self.init()
        
        self.id = item.title // take title as id for now
        self.imageURLString = item.imageURL.absoluteString
        self.title = item.title
    }
}

extension Sequence where Iterator.Element == ItemRealmObject {
    func toItems() -> [Item] {
        return self.map{ Item.init(with: $0) }
    }
}
