//
//  Item.swift
//  VoiceTube-iOS-Assignment
//
//  Created by 廖慶麟 on 2018/4/29.
//  Copyright © 2018年 廖慶麟. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct Item: JSONDecodable {
    let title: String
    let imageURL: URL
    
    public init(decodeUsing json: JSON) throws {
        guard
            let title = json["title"].string,
            let imageURLPath = json["img"].string,
            let imageURL = URL(string: imageURLPath)
        else { throw JSONDecodableError.parseError }
    
        self.title = title
        self.imageURL = imageURL
    }
}
