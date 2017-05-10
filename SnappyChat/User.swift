//
//  User.swift
//  SnappySnap
//
//  Created by Isomi on 4/27/17.
//  Copyright © 2017 Humberto Espinola. All rights reserved.
//

import Foundation

class User {
    
    // MARK: - Class Properties
    private var _displayName: String
    
    var displayName: String {
        return _displayName
    }
    
    // MARL: - Class Methods
    init(displayName: String) {
        _displayName = displayName
    }
}
