//
//  RealmManager.swift
//  CryptoTicker
//
//  Created by 廖慶麟 on 2018/4/24.
//  Copyright © 2018年 廖慶麟. All rights reserved.
//

import Foundation
import RealmSwift

protocol RealmManagerType: class {
    associatedtype Object
    
    func add(object: Object, completionHandler: ((Bool) -> ())?) throws
    func remove(id: String, completionHandler: ((Bool) -> ())?) throws
    
    func query(id: String) -> Object?
    func query() throws -> [Object]
}

class RealmManager<T: RealmObject>: RealmManagerType {
    typealias Object = T

    // MARK: - Setter
    func add(object: Object, completionHandler: ((Bool) -> ())?) throws {
        object.save { (succeed) in
            completionHandler?(succeed)
        }
    }

    func remove(id: String, completionHandler: ((Bool) -> ())?) throws {
        guard let object = self.query(id: id) else { throw RealmError.noSuchData }
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.delete(object)
            try realm.commitWrite()

            completionHandler?(true)
        }catch {
            completionHandler?(false)
        }
    }
    
    // MARK: - Getter
    func query(id: String) -> Object? {
        do {
            let realm = try Realm()
            let object = realm.object(ofType: Object.self, forPrimaryKey: id)
            return object
        } catch let error {
            return nil
        }
    }
    
    func query() throws -> [Object] {
        let realm = try Realm()
        let objects: [Object] = realm.objects(Object.self).map { $0 }
        
        return objects
    }
}
