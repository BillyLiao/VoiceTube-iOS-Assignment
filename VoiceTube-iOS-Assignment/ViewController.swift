//
//  ViewController.swift
//  VoiceTube-iOS-Assignment
//
//  Created by 廖慶麟 on 2018/4/29.
//  Copyright © 2018年 廖慶麟. All rights reserved.
//

import UIKit

internal final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        GetItemList().perform().then { (list) in
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

