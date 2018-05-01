//
//  GetItemList.swift
//  VoiceTube-iOS-Assignment
//
//  Created by 廖慶麟 on 2018/4/29.
//  Copyright © 2018年 廖慶麟. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire

public class GetItemList : NetworkRequest {
    public typealias ResponseType = ItemList
    
    public var endpoint: String { return "/thirdparty/test.php" }
    public var method: HTTPMethod { return .post }
    public var parameters: [String : Any]? { return ["key": "VoiceTube"] }
    public var encoding: ParameterEncoding { return URLEncoding.default }
    
    public func perform() -> Promise<ResponseType> {
        return networkClient.performRequest(self).then(execute: responseHandler)
    }
}
