//
//  UIViewControllerExtension.swift
//  CalendarApp
//
//  Created by David on 2016/7/19.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

public extension UIViewController {
	public func asyncPresent(_ viewControllerToPresent: UIViewController?, animated: Bool, completion: (() -> Void)? = nil) {
		Queue.main {
			if let viewControllerToPresent = viewControllerToPresent {
				self.present(viewControllerToPresent, animated: animated, completion: completion)
			}
		}
	}
	
	public func asyncDismiss(_ animated: Bool, completion: (() -> Void)? = nil) {
		Queue.main {
			self.dismiss(animated: animated, completion: {
				self.transitioningDelegate = nil
				completion?()
			})
		}
	}
    
    public func hideKeyboard() {
        view.endEditing(true)
    }
    
    public func getNavigationBar() -> ColorgyNavigationBar? {
        guard let vc = self as? Navigable else { return nil }
        return vc.navigationBar
    }
}
