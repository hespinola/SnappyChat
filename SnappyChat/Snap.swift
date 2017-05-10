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
    private var _senderName: String
    private var _senderId: String
    
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
    
    var senderName: String {
        return _senderName
    }
    
    var senderId: String {
        return _senderId
    }
    
    var sender: Dictionary<String, String> {
        return ["display_name": _senderName, "id": _senderId]
    }
    
    // MARK: - Class Methods
    init(counter: Int, image: String, targets: [String], senderName: String, senderId: String) {
        self._counter = counter
        self._image = image
        self._targets = targets
        self._senderName = senderName
        self._senderId = senderId
    }
}
