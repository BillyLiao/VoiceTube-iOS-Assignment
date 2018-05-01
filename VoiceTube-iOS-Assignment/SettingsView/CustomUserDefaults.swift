//
//  CustomUserDefaults.swift
//  VoiceTube-iOS-Assignment
//
//  Created by 廖慶麟 on 2018/4/30.
//  Copyright © 2018年 廖慶麟. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    static let autoPlay = DefaultsKey<Bool>("autoPlay")
    static let subtitleEnabled = DefaultsKey<Bool>("subtitleEnabled")
    static let stopWhileQuerying = DefaultsKey<Bool>("stopWhileQuerying")
    static let recommendationNotifiable = DefaultsKey<Bool>("recommendationNotifiable")
    static let notificationTime = DefaultsKey<Date>("notificationTime")
}
