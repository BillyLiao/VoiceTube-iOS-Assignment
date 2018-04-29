//
//  ColorgyNavigationTransitioningDelegate.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/15.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class ColorgyNavigationTransitioningDelegate: UIPercentDrivenInteractiveTransition {
	fileprivate var isPresenting: Bool = false
    
	
	public var presentingViewController: UIViewController! {
		didSet {
            presentingViewController.transitioningDelegate = self
		}
	}
}

extension ColorgyNavigationTransitioningDelegate : UIViewControllerTransitioningDelegate {
	public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		isPresenting = true
		return self
	}
	
	public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		isPresenting = false
		return self
	}
}

extension ColorgyNavigationTransitioningDelegate {
	fileprivate func offStagePresentingVC() {
		presentingViewController.view.transform = CGAffineTransform(translationX: presentingViewController.view.bounds.width, y: 0)
	}
	
	fileprivate func onStagePresentingVC() {
		presentingViewController.view.transform = CGAffineTransform.identity
	}
	
	fileprivate func offStageMainVC(_ viewController: UIViewController) {
		let mainOffset: CGFloat = 150
		let move = CGAffineTransform(translationX: -mainOffset, y: 0)
		viewController.view.transform = move.scaledBy(x: 1, y: 1)
	}
	
	fileprivate func onStageMainVC(_ viewController: UIViewController) {
		viewController.view.transform = CGAffineTransform.identity
	}
	
	fileprivate func onPrepareStageNavigationBar(_ bar: ColorgyNavigationBar?) {
		guard let bar = bar else { return }
		bar.titleLabel.transform = CGAffineTransform(translationX: bar.bounds.width * -(0.55 + 0.5), y: 0)
		bar.transform = CGAffineTransform(translationX: bar.bounds.width, y: 0)
		bar.leftButton?.alpha = 0
		bar.rightButton?.alpha = 0
		bar.alpha = 0.0
	}
	
	fileprivate func onStageNavigationBar(_ bar: ColorgyNavigationBar?) {
		guard let bar = bar else { return }
		bar.titleLabel.transform = CGAffineTransform.identity
		bar.transform = CGAffineTransform.identity
		bar.leftButton?.alpha = 1
		bar.rightButton?.alpha = 1
		bar.alpha = 1.0
	}
	
	fileprivate func offStageNavigationBar(_ bar: ColorgyNavigationBar?) {
		guard let bar = bar else { return }
		bar.titleLabel.transform = CGAffineTransform(translationX: bar.bounds.width * 0.4, y: 0)
		bar.transform = CGAffineTransform(translationX: -bar.bounds.width, y: 0)
		bar.leftButton?.alpha = 0
		bar.rightButton?.alpha = 0
		bar.alpha = 0
	}
}

extension ColorgyNavigationTransitioningDelegate : UIViewControllerAnimatedTransitioning {
	public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return 0.25
	}
	
	// Animation code
	public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		
		let container = transitionContext.containerView
		let screen: (from: UIViewController, to: UIViewController) =
			(transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!,
			 transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!)
		
		let mainVC = isPresenting ? screen.from : screen.to
		let presentingVC = isPresenting ? screen.to : screen.from
		
//		let mainVCSnapshot = mainVC.view.resizableSnapshotViewFromRect(UIScreen.mainScreen().bounds, afterScreenUpdates: true, withCapInsets: UIEdgeInsetsZero)
		let presentingVCSnapshot = presentingVC.view.resizableSnapshotView(from: UIScreen.main.bounds, afterScreenUpdates: true, withCapInsets: UIEdgeInsets.zero)
		
		let duration = transitionDuration(using: transitionContext)
		
		container.addSubview(mainVC.view)
		container.addSubview(presentingVC.view)
		
		// Start animation
		// initial state
		if isPresenting {
			offStagePresentingVC()
		} else {
			offStageMainVC(mainVC)
		}
		
		print("fucking shit")
		let mainBar: ColorgyNavigationBar? = mainVC.getNavigationBar()
		let presentBar: ColorgyNavigationBar? = presentingVC.getNavigationBar()
		print("main gets navigation bar \(mainBar != nil)")
		print("presenting view gets navigation bar \(presentBar != nil)")
		
		if isPresenting {
			offStageNavigationBar(presentBar)
			onStageNavigationBar(mainBar)
		} else {
			onStageNavigationBar(presentBar)
			onPrepareStageNavigationBar(mainBar)
		}
		
		
		let fakeMainBar = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.main.bounds.width, height: 64)))
		fakeMainBar.backgroundColor = mainBar?.backgroundColor
		let fakePresentBar = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.main.bounds.width, height: 64)))
		fakePresentBar.backgroundColor = presentBar?.backgroundColor
		if let mainBar = mainBar {
			mainVC.view.insertSubview(fakeMainBar, belowSubview: mainBar)
		}
		if let presentBar = presentBar {
			presentingVC.view.insertSubview(fakePresentBar, belowSubview: presentBar)
		}
		
		presentingVC.hideKeyboard()
		mainVC.hideKeyboard()
		
		// animation part
		UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
			if self.isPresenting {
				// presenting view enter from right to left
				self.onStagePresentingVC()
				// main view move a bit to left
				self.offStageMainVC(mainVC)
				self.onStageNavigationBar(presentBar)
				self.onPrepareStageNavigationBar(mainBar)
			} else {
				// get back main view
				self.onStageMainVC(mainVC)
				// dismiss presenting view
				self.offStagePresentingVC()
				self.offStageNavigationBar(presentBar)
				self.onStageNavigationBar(mainBar)
			}
			}, completion: { (finished) in
				if transitionContext.transitionWasCancelled {
					// transition was cancelled, not completing the transition
					transitionContext.completeTransition(false)
					// from view is still in presenting
					presentingVCSnapshot!.removeFromSuperview()
					screen.from.view.transform = CGAffineTransform.identity
					UIApplication.shared.keyWindow?.addSubview(screen.from.view)
				} else {
					// transition completed
					transitionContext.completeTransition(true)
					screen.to.view.transform = CGAffineTransform.identity
					UIApplication.shared.keyWindow?.addSubview(screen.to.view)
				}
				// clean up
				fakeMainBar.removeFromSuperview()
				fakePresentBar.removeFromSuperview()
		})
		
	}
}
