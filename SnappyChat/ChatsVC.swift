//
//  ChatsVC.swift
//  SnappySnap
//
//  Created by Isomi on 4/22/17.
//  Copyright © 2017 Humberto Espinola. All rights reserved.
//

import UIKit
import Panel
import Firebase

class ChatsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UI Elements
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newSnapButton: UIButton!
    @IBOutlet weak var noSnapsLabel: UILabel!
    
    // MARK: - Class Properties
    var panelDelegate: PanelViewControllerDelegate?
    private var snapsList = [String]()
    private var snapsSender = [String]()
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Setup TableView
        let tableImageView = UIImageView(image: UIImage(named: "bg"))
        tableImageView.contentMode = .scaleAspectFit
        tableView.backgroundView = tableImageView
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        
        snapsList.removeAll()
        snapsSender.removeAll()
        
        DataService.shared.snapsReference.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    
                    let dict = snap.value as! Dictionary<String, AnyObject>
                    let targets = dict["targets"] as! Dictionary<String, AnyObject>
                    
                    if targets[(FIRAuth.auth()?.currentUser?.uid)!] != nil {
                        if !self.snapsList.contains(snap.key) {
                            self.snapsList.append(snap.key)
                            self.snapsSender.append((dict["sender"]!["display_name"]! as! String))
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        })
    }
    
    // MARK: - Table View Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if snapsList.count < 1 {
            noSnapsLabel.isHidden = false
        } else {
            noSnapsLabel.isHidden = true
        }
        return snapsSender.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCell {
            cell.configure(name: snapsSender[indexPath.row])
            cell.imageView?.image = UIImage(named: "messagefilled3")
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    // MARK: - UI Actions
    @IBAction func newSnapButtonTapped(_ sender: Any) {
        panelDelegate?.PanelViewControllerAnimateTo(panel: .center)
    }
    
}
