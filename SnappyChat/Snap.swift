//
//  Snap.swift
//  SnappySnap
//
//  Created by Isomi on 4/27/17.
//  Copyright © 2017 Humberto Espinola. All rights reserved.
//

import Foundation

class Snap {
    
    // MARK: - Class Properties
    private var _counter: Int
    private var _image: String
    private var _targets: [String]
    
    var counter: Int {
        return _counter
    }

    var image: String {
        return _image
    }
    
    var targets: [String] {
        return _targets
    }
    
    var targetsDict: Dictionary<String, Bool> {
        var dict = Dictionary<String, Bool>()
        
        for target in _targets {
            dict[target] = true
        }
        
        return dict
    }
    
    // MARK: - Class Methods
    init(counter: Int, image: String, targets: [String]) {
        self._counter = counter
        self._image = image
        self._targets = targets
    }
}
