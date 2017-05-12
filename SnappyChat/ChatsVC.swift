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
    private var snapToSend = Dictionary<String, AnyObject>()
    
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
                    
                    if let targets = dict["targets"] as? Dictionary<String, AnyObject> {
                        if targets[(FIRAuth.auth()?.currentUser?.uid)!] != nil {
                            if !self.snapsList.contains(snap.key) {
                                self.snapsList.append(snap.key)
                                self.snapsSender.append((dict["sender"]!["display_name"]! as! String))
                                self.tableView.reloadData()
                            }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        addLoadingAnimation()
        DataService.shared.snapsReference.child(snapsList[indexPath.row]).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapData = snapshot.value as? Dictionary<String, AnyObject> {
                let counter = snapData["counter"] as! Int
                let imageRef = snapData["image"] as! String
                
                self.snapToSend["snapId"] = self.snapsList[indexPath.row] as AnyObject
                self.snapToSend["snapRef"] = DataService.shared.databaseReference.child(self.snapsList[indexPath.row])
                self.snapToSend["counter"] = counter as AnyObject
                
                DataService.shared.storage.reference(forURL: imageRef).data(withMaxSize: DataService.shared.MAX_DOWNLOAD_SIZE, completion: { (data, error) in
                    if let error = error {
                        print("DONKEY: Error trying to Download Data from Firebase - \(error.localizedDescription)")
                        self.removeLoadingAnimation(shouldPerformSegue: false)
                        let errorTryingToDownload = UIAlertController(title: "Oops!", message: "There was an error trying to download the snap. Try again", preferredStyle: .alert)
                        errorTryingToDownload.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(errorTryingToDownload, animated: true, completion: nil)
                    } else {
                        let image = UIImage(data: data!)
                        self.snapToSend["imageRef"] = DataService.shared.storage.reference(forURL: imageRef)
                        self.snapToSend["image"] = image!
                        self.removeLoadingAnimation(shouldPerformSegue: true)
                    }
                })
            }
        })
    }
    
    // MARK: - Class Methods
    func addLoadingAnimation() {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = .gray
        loadingIndicator.startAnimating()
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func removeLoadingAnimation(shouldPerformSegue: Bool) {
        dismiss(animated: true, completion: {
            if shouldPerformSegue {
                self.performSegue(withIdentifier: "ViewSnapVC", sender: self.snapToSend)
            }
        })
    }
    
    // MARK: - UI Actions
    @IBAction func newSnapButtonTapped(_ sender: Any) {
        panelDelegate?.PanelViewControllerAnimateTo(panel: .center)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewSnapVC" {
            if let vc = segue.destination as? ViewSnapVC {
                if let object = sender as? Dictionary<String, AnyObject> {
                    vc.counter = object["counter"] as! Int
                    vc.image = object["image"] as! UIImage
                    vc.snapId = object["snapId"] as! String
                    vc.imageReference = object["imageRef"] as! FIRStorageReference
                    vc.snapRef = object["snapRef"] as! FIRDatabaseReference
                }
            }
        }
    }
}
