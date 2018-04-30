//
//  CustomNavigationBar.swift
//
//
//  Created by David on 2016/5/21.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit
import SnapKit

@objc public protocol ColorgyNavigationBarDelegate: class {
	@objc optional func colorgyNavigationBarBackButtonClicked()
    @objc optional func colorgyNavigationBarRightTitleButtonClicked()
    @objc optional func colorgyNavigationBarLeftTitleButtonClicked()
    @objc optional func colorgyNavigationBarSettingsButtonClicked()
}

public enum ColorgyNavigationBarButtonType {
    case back
    case settings
    
    var data: (image: UIImage, selector: Selector) {
        switch self {
        case .back : return (#imageLiteral(resourceName: "back"), #selector(ColorgyNavigationBar.backButtonClicked))
        case .settings : return (#imageLiteral(resourceName: "settings"), #selector(ColorgyNavigationBar.settingsButtonClicked))
        }
    }
}

/// This is customized navigation bar for colorgy.
open class ColorgyNavigationBar: UIView {

    // MARK: - Delegate
	open weak var delegate: ColorgyNavigationBarDelegate?
	
    // MARK: - View Components
    open fileprivate(set) var titleLabel: UILabel!
    open fileprivate(set) var bottomLine: UIView = UIView()
    
    open var title: String? {
        didSet {
            Queue.main {
                self.titleLabel?.text = self.title
                self.updateUI()
            }
        }
    }

	// MARK: - Buttons
	open fileprivate(set) var leftButton: UIButton!
	open fileprivate(set) var rightButton: UIButton!
	
	// MARK: - Getter
	fileprivate var centerY: CGFloat {
		get {
			return (bounds.height - 20) / 2 + 20
		}
	}
    public enum ColorgyNavigationBarButtonPosition {
        case right
        case left
    }

	// MARK: - Init
	public init() {
		super.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.main.bounds.width, height: 64)))
		backgroundColor = UIColor.white
        titleLabel = getTitleLabel()
        
        addSubview(titleLabel)
        
        configureBottomLine()
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(8)
        }
        
        self.layer.zPosition = 1
	}
    
    public convenience init(with backgroundColor: UIColor) {
        self.init()
        
        self.backgroundColor = backgroundColor
    }
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
    
    open override func didMoveToSuperview() {
        guard let _ = superview else { return }
        self.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(64)
        }
    }
    
	// MARK: - Configuration
    fileprivate func getTitleLabel() -> UILabel {
        let label = UILabel()
        label.frame.size = CGSize(width: 0.6 * bounds.width, height: 21)
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.sizeToFit()
        
        center(label: label)
        
        return label
    }
    
    private func configureBottomLine() {
        bottomLine.backgroundColor = UIColor.darkGray
        
        addSubview(bottomLine)
        
        bottomLine.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    fileprivate func center(label: UILabel) {
        label.center.x = bounds.midX
        label.center.y = centerY
    }

	// MARK: - Configure Buttons
	// MARK: - Left
    open func setButton(at position: ColorgyNavigationBarButtonPosition, type: ColorgyNavigationBarButtonType) {
        switch position {
        case .left:
            leftButton = getBarButton(image: type.data.image, position: .left)
            addSubview(leftButton)
            leftButton.addTarget(self, action: type.data.selector, for: .touchUpInside)
        case .right:
            rightButton = getBarButton(image: type.data.image, position: .right)
            addSubview(rightButton)
            rightButton.addTarget(self, action: type.data.selector, for: .touchUpInside)
        }
    }
    
    open func setButton(at position: ColorgyNavigationBarButtonPosition, title: String) {
        switch position {
        case .left:
            leftButton = getBarButton(title: title, position: position)
            addSubview(leftButton)
            leftButton.addTarget(self, action: #selector(ColorgyNavigationBar.leftTitleButtonClicked), for: .touchUpInside)
        case .right:
            rightButton = getBarButton(title: title, position: position)
            addSubview(rightButton)
            rightButton.addTarget(self, action: #selector(ColorgyNavigationBar.rightTitleButtonClicked), for: .touchUpInside)
        }
    }
    
	// MARK: - View Getter
    fileprivate func getBarButton(image: UIImage, position: ColorgyNavigationBarButtonPosition) -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.contentMode = .scaleAspectFill
        button.adjustsImageWhenHighlighted = false

        button.frame.size = CGSize(width: 40, height: 30)
        button.center.y = centerY
        
        switch position {
        case .right:
            button.frame.origin.x = bounds.width - button.bounds.width - 6
            button.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
        case .left:
            button.frame.origin.x = 6
            button.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
        }
        
        return button
    }

    fileprivate func getBarButton(title: String, position: ColorgyNavigationBarButtonPosition) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: UIControlState())
        button.contentMode = .scaleAspectFill
        button.tintColor = UIColor.white
        
        button.frame.size = CGSize(width: 20, height: 20)
        button.sizeToFit()
        button.center.y = centerY
        
        switch position {
        case .right:
            button.frame.origin.x = bounds.width - button.bounds.width - 16
        case .left:
            button.frame.origin.x = 16
        }
        
        return button
    }
	
	// MARK: - Button Methods
    @objc fileprivate func leftTitleButtonClicked() {
        delegate?.colorgyNavigationBarLeftTitleButtonClicked?()
    }
    
    @objc fileprivate func rightTitleButtonClicked() {
        delegate?.colorgyNavigationBarRightTitleButtonClicked?()
    }
    
	@objc fileprivate func backButtonClicked() {
		delegate?.colorgyNavigationBarBackButtonClicked?()
	}
    
    @objc fileprivate func settingsButtonClicked() {
        delegate?.colorgyNavigationBarSettingsButtonClicked?()
    }
	
	// MARK: - Methods
	open func transparentBar() {
		backgroundColor = UIColor.clear
	}
	
	open func nontransparentBar() {
		backgroundColor = UIColor.white
	}
    
    // MARK: - Hide & Show
    open func hideRightButton() {
        rightButton.isHidden = true
    }
    
    open func showRightButton() {
        rightButton.isHidden = false
    }
    
    // MARK: - Update UI
    fileprivate func updateUI() {
        guard titleLabel != nil else { return }
        
        titleLabel?.sizeToFit()
        center(label: titleLabel)
    }
}
