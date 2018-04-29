//
//  UITableViewExtension.swift
//  KK-Assignment
//
//  Created by 廖慶麟 on 2018/4/10.
//  Copyright © 2018年 廖慶麟. All rights reserved.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(with aCellClass: T.Type) {
        guard let cellClassName = "\(aCellClass)".components(separatedBy: ".").first else { return }
        self.register(UINib(nibName: cellClassName, bundle: nil), forCellReuseIdentifier: cellClassName)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(of aCellClass: T.Type, for indexPath: IndexPath) -> T? {
        guard let cellClassName = "\(aCellClass)".components(separatedBy: ".").first else { return nil }
        
        return self.dequeueReusableCell(withIdentifier: cellClassName, for: indexPath) as! T
    }
}
