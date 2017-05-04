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
import FBSDKCoreKit
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
    
    override func viewDidAppear(_ animated: Bool) {
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "first_name, last_name"], httpMethod: "GET").start(completionHandler: { (connection, result, error) in
            
            if let error = error {
                print("DONKEY: Error trying to get info from Facebook: \(error.localizedDescription)")
            } else if let resultDictionary = result as? Dictionary<String, AnyObject> {
                
                self.profileFirstName.text = resultDictionary["first_name"] as? String
                self.profileLastName.text = resultDictionary["last_name"] as? String
            }
        })
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
