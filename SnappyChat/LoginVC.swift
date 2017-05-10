//
//  LoginVC.swift
//  SnappySnap
//
//  Created by Isomi on 4/20/17.
//  Copyright © 2017 Humberto Espinola. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit

class LoginVC: UIViewController {

    // MARK: - Class Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK - Class Methods
    func loginToFirebase(with credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if let error = error {
                print("DONKEY: Error trying to authenticate with Firebase: \(error.localizedDescription)")
            } else {
            DataService.shared.usersReference.child((FIRAuth.auth()?.currentUser?.uid)!).child("display_name").setValue(FIRAuth.auth()?.currentUser?.displayName)
                
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    // MARK: - UI Actions
    @IBAction func loginBtnTapped(_ sender: Any) {
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["public_profile"], from: self, handler: { (result, error) in
            if let error = error {
                print("DONKEY: Couldn't authenticate with Facebook\(error.localizedDescription)")
            } else if (result?.isCancelled)! {
                print("DONKEY: Facebook login cancelled by the user.")
            } else {
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: (result?.token.tokenString)!)
                
                self.loginToFirebase(with: credential)
            }
        })
    }

}
