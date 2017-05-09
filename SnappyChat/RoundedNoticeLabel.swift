//
//  RoundedNoticeLabel.swift
//  SnappyChat
//
//  Created by Isomi on 5/7/17.
//  Copyright © 2017 Humberto Espinola. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedNoticeLabel: UILabel {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
}
