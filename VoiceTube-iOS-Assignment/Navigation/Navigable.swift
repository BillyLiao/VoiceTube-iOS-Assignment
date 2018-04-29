//
//  Navigable.swift
//  KK-Assignment
//
//  Created by 廖慶麟 on 2018/4/11.
//  Copyright © 2018年 廖慶麟. All rights reserved.
//

import UIKit

protocol Navigable {
    var navigationBar: ColorgyNavigationBar { get }
    var navigationTransitionDelegate: ColorgyNavigationTransitioningDelegate? { get }

    func configureNavigationBar()
}
