//
//  ItemList.swift
//  VoiceTube-iOS-Assignment
//
//  Created by 廖慶麟 on 2018/4/29.
//  Copyright © 2018年 廖慶麟. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct ItemList: JSONDecodable {
    let items: [Item]
    
    public init(decodeUsing json: JSON) throws {
        guard
            let itemArray = json["videos"].array
        else { throw JSONDecodableError.parseError }
        
        do {
            items = try itemArray.map { (json) -> Item in
                do { return try Item.init(decodeUsing: json) }
                catch { throw JSONDecodableError.parseError }}}
        catch { throw JSONDecodableError.parseError }
    }
}
