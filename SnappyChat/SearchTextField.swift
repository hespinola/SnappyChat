//
//  SearchTextField.swift
//  SnappySnap
//
//  Created by Isomi on 4/25/17.
//  Copyright © 2017 Humberto Espinola. All rights reserved.
//

import UIKit

@IBDesignable
class SearchTextField: UITextField {
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += leftViewLeftPadding
        return rect
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 0, left: textRectLeftPadding, bottom: 0, right: textRectRightPadding))
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 0, left: textRectLeftPadding, bottom: 0, right: textRectRightPadding))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 0, left: textRectLeftPadding, bottom: 0, right: textRectRightPadding))
    }
    
    @IBInspectable var leftViewLeftPadding: CGFloat = 0.0
    @IBInspectable var textRectLeftPadding: CGFloat = 0.0
    @IBInspectable var textRectRightPadding: CGFloat = 0.0
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            if let image = leftImage {
                leftViewMode = .always
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
                imageView.image = image
                leftView = imageView
            } else {
                leftViewMode = .never
                leftView = nil
            }
        }
    }
}
