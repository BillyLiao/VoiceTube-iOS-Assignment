//
//  RealmObject.swift
//  CryptoTicker
//
//  Created by 廖慶麟 on 2018/4/24.
//  Copyright © 2018年 廖慶麟. All rights reserved.
//

import Foundation
import RealmSwift

protocol RealmObjectType: class where Self: Object {
    var id: String { get set }
    
    func save(_ completionHandler: ((_ succeed: Bool) -> Void)?)
}

class RealmObject: Object, RealmObjectType {
    @objc dynamic var id: String = ""
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
    func save(_ completionHandler: ((Bool) -> Void)?) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(self, update: true)
            try realm.commitWrite()
            
            completionHandler?(true)
        } catch let error {
            print("Failed to save realm object with error: \(error)")
            completionHandler?(false)
        }
    }
}
