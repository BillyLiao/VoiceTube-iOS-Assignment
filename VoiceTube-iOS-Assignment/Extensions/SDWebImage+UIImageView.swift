//
//  SDWebImage+UIImageView.swift
//  VoiceTube-iOS-Assignment
//
//  Created by 廖慶麟 on 2018/4/30.
//  Copyright © 2018年 廖慶麟. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    public func sd_setImageWithURLWithFade(url: URL!, placeholderImage placeholder: UIImage!) {
        self.sd_setImage(with: url, placeholderImage: placeholder) { (image, error, cacheType, url) -> Void in
            if let downLoadedImage = image {
                self.alpha = 0
                UIView.transition(
                with: self,
                duration: 0.2,
                options: UIViewAnimationOptions.transitionCrossDissolve,
                animations: { () -> Void in
                    self.image = downLoadedImage
                    self.alpha = 1
                }, completion: nil)}
            else {  self.image = placeholder }
        }
    }
}
