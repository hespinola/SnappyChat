//
//  ChatsVC.swift
//  SnappySnap
//
//  Created by Isomi on 4/22/17.
//  Copyright © 2017 Humberto Espinola. All rights reserved.
//

import UIKit
import Panel

class ChatsVC: UIViewController, UITextFieldDelegate {
    
    // MARK: - UI Elements
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newChatButton: UIButton!
    @IBOutlet weak var newSnapButton: UIButton!
    
    // MARK: - Class Properties
    var panelDelegate: PanelViewControllerDelegate?
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchField.delegate = self
        
        // Setup TableView
        let tableImageView = UIImageView(image: UIImage(named: "bg"))
        tableImageView.contentMode = .scaleAspectFit
        tableView.backgroundView = tableImageView
        tableView.tableFooterView = UIView(frame: .zero)
        
        // Hide Keyboard on Screen Tapped
        let screenTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        screenTap.cancelsTouchesInView = false
        view.addGestureRecognizer(screenTap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DataService.shared.listUsers()
    }
    
    // MARK: - TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Class Methods
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - UI Actions
    @IBAction func newChatButtonTapped(_ sender: Any) {
        // TODO: Add Chat System
        //performSegue(withIdentifier: "SingleChatVC", sender: nil)
    }
    
    @IBAction func newSnapButtonTapped(_ sender: Any) {
        panelDelegate?.PanelViewControllerAnimateTo(panel: .center)
    }
    
}
