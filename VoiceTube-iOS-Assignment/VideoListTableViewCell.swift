//
//  VideoListTableViewCell.swift
//  VoiceTube-iOS-Assignment
//
//  Created by 廖慶麟 on 2018/4/30.
//  Copyright © 2018年 廖慶麟. All rights reserved.
//

import UIKit
import SDWebImage

internal final class VideoListTableViewCell: UITableViewCell {
    
    // MARK: - View Components
    private let mainView: UIView = UIView()
    private let mainImageView: UIImageView = UIImageView()
    private let titleLabel: UILabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        configureMainView()
        configureMainImageView()
        configureTitleLabel()
    }
    
    // MARK: - View Configuration
    private func configureMainView() {
        addSubview(mainView)
        
        mainView.layer.cornerRadius = 5.0
        mainView.clipsToBounds = true
        
        mainView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(4)
        }
    }
    
    private func configureMainImageView() {
        mainView.addSubview(mainImageView)
        
        mainImageView.contentMode = .scaleAspectFill
        mainImageView.clipsToBounds = true
        
        mainImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureTitleLabel() {
        mainView.addSubview(titleLabel)
        
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 25)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview().inset(8)
            make.height.equalTo(32)
        }
    }
    
    public func configure(with item: Item) {
        mainImageView.sd_setImageWithURLWithFade(url: item.imageURL, placeholderImage: #imageLiteral(resourceName: "defaultImage"))
        titleLabel.text = item.title
    }
}
