//
//  ExpandButtonTapArea.swift
//  SnappySnap
//
//  Created by Isomi on 4/27/17.
//  Copyright © 2017 Humberto Espinola. All rights reserved.
//

import UIKit

extension UIButton {
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // If the button is hidden/disabled/transparent it can't be hit
        if self.isHidden || !self.isUserInteractionEnabled || self.alpha < 0.01 { return nil }
        
        // Increase the hit frame
        let newFrame = self.bounds.insetBy(dx: -8, dy: -8)
        
        // Perform hit test on larger frame
        return (newFrame.contains(point)) ? self : nil
    }
}
