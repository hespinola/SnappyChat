//
//  RoundedImageView.swift
//  SnappySnap
//
//  Created by Isomi on 4/25/17.
//  Copyright © 2017 Humberto Espinola. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedImageView: UIImageView {

    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
}
