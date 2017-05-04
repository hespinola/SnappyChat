/*
	Copyright (C) 2016 Apple Inc. All Rights Reserved.
	See LICENSE.txt for this sample’s licensing information
	
	Abstract:
	View controller for camera interface.
*/

import UIKit
import Firebase
import Panel

class MainVC: PanelViewController, PanelViewControllerDataSource {
    
    // MARK: - Class Properties
    var isStatusBarHidden = true
    
    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
	// MARK: - View Controller Life Cycle
    override func viewDidLoad() {
		super.viewDidLoad()
		
        // Do any additional setup after loading the view.
        setNeedsStatusBarAppearanceUpdate()
        dataSource = self
        self.moveTo(panel: .center)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if FIRAuth.auth()?.currentUser == nil {
            performSegue(withIdentifier: "LoginVC", sender: nil)
        }
    }
	
    // MARK: - Panel View Data Source
    func PanelViewDidSetViewControllers() -> [UIViewController] {
        let chatsVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatsVC") as! ChatsVC
        chatsVC.panelDelegate = self
        
        let cameraVC = self.storyboard?.instantiateViewController(withIdentifier: "CameraVC") as! CameraVC
        
        let settingsVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        settingsVC.panelDelegate = self
        
        return [chatsVC, cameraVC, settingsVC]
    }
    
    func PanelViewControllerDidScroll(offSet: CGFloat) {
        // Determine if Panel is centered on Left or Right, and animate the status bar
        
        if (offSet == -1.0 || offSet == 1.0) && isStatusBarHidden == true {
            isStatusBarHidden = false
            
            UIView.animate(withDuration: 0.35, animations: {
                self.setNeedsStatusBarAppearanceUpdate()
            })
        } else /*Hide status bar */ {
            isStatusBarHidden = true
            
            UIView.animate(withDuration: 0.35, animations: {
                self.setNeedsStatusBarAppearanceUpdate()
            })
        }
    }
}
