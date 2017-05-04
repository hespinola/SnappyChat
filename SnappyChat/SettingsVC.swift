//
//  FriendsVC.swift
//  SnappySnap
//
//  Created by Isomi on 4/22/17.
//  Copyright © 2017 Humberto Espinola. All rights reserved.
//

import UIKit
import Panel
import Firebase
import FBSDKLoginKit

class SettingsVC: UIViewController {
    
    // MARK: - UI Elements
    @IBOutlet weak var newSnapButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var profileImage: RoundedImageView!
    @IBOutlet weak var profileFirstName: UILabel!
    @IBOutlet weak var profileLastName: UILabel!
    
    // MARK: - Class Properties
    var panelDelegate: PanelViewControllerDelegate?
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - UI Actions
    @IBAction func logoutButtonTapped(_ sender: Any) {
        do {
            try FIRAuth.auth()?.signOut()
            FBSDKLoginManager().logOut()
            performSegue(withIdentifier: "LoginVC", sender: nil)
        } catch let error as NSError {
            print("DONKEY: Error trying to sign out from Firebase: \(error.description)")
        }
    }
    
    @IBAction func newSnapButtonTapped(_ sender: Any) {
        panelDelegate?.PanelViewControllerAnimateTo(panel: .center)
    }

}
