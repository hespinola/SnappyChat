//
//  UserCell.swift
//  SnappySnap
//
//  Created by Isomi on 4/25/17.
//  Copyright © 2017 Humberto Espinola. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    // MARK: - UI Elements
    @IBOutlet weak var selectedStatus: UIImageView!
    @IBOutlet weak var username: UILabel!
    
    // MARK: - Class Properties
    var userId: String!
    
    // MARK: - View Controller Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    // MARK: - Class Methods
    func configure(name: String, id: String) {
        username.text = name
        userId = id
    }
    
    func configure(name: String) {
        username.text = name
        userId = "NA"
    }
}
