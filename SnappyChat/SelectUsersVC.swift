//
//  SelectUsersVC.swift
//  SnappySnap
//
//  Created by Isomi on 5/7/17.
//  Copyright © 2017 Humberto Espinola. All rights reserved.
//

import UIKit
import Firebase

class SelectUsersVC: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UI Elements
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    
    // MARK: - Class Properties
    var imageToSend: UIImage!
    private var usersList = [String]()
    private var usersNames = [String]()
    private var selectedCells = [UITableViewCell]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        // Setup TableView
        tableView.tableFooterView = UIView(frame: .zero)
        
        // Hide Keyboard on Screen Tapped
        let screenTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        screenTap.cancelsTouchesInView = false
        view.addGestureRecognizer(screenTap)
        
        // Send Button Styling
        setSendButtonSelected(enabled: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        
        usersList.removeAll()
        usersNames.removeAll()
        
        DataService.shared.usersReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    self.usersList.append(snap.key)
                    let dict = snap.value as! Dictionary<String, AnyObject>
                    self.usersNames.append(dict["display_name"] as! String)
                    
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }

    // MARK: - UI Actions
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        print(selectedCells.debugDescription)
        performSegue(withIdentifier: "MainVC", sender: self)
    }
    
    // MARK: - TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        /// TODO:
        /// - Add user filtering using searchbar
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        /// TODO:
        /// - Add user filtering using searchbar
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    // MARK: - Table View Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCell {
            cell.configure(name: usersNames[indexPath.row], id: usersList[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? UserCell else { return }
        
        cell.selectedStatus.image = UIImage(named: "messagefilled1")
        selectedCells.append(cell)
        
        if selectedCells.count == 1 {
            setSendButtonSelected(enabled: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? UserCell else { return }
        
        cell.selectedStatus.image = UIImage(named: "messageindicator1")
        selectedCells.remove(at: selectedCells.index(of: cell)!)
        
        if selectedCells.count < 1 {
            setSendButtonSelected(enabled: false)
        }
    }
    
    
    // MARK: - Class Methods
    func dismissKeyboard() {
        view.endEditing(true)
    }

    func setSendButtonSelected(enabled: Bool) {
        sendButton.isEnabled = enabled
        if enabled {
            UIView.animate(withDuration: 0.3, animations: {
                self.sendButton.backgroundColor = UIColor(red: 0, green: 162 / 255, blue: 52 / 255, alpha: 1)
                self.sendButton.layer.borderWidth = 0
                self.sendButton.layer.borderColor = UIColor.clear.cgColor
                self.sendButton.setTitleColor(UIColor.white , for: .normal)
                self.sendButton.layoutIfNeeded()
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.sendButton.backgroundColor = UIColor.clear
                self.sendButton.layer.borderWidth = 1
                self.sendButton.layer.borderColor = UIColor.gray.cgColor
                self.sendButton.setTitleColor(UIColor.gray, for: .disabled)
                self.sendButton.layoutIfNeeded()
            })
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
