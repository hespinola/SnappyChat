//
//  ViewSnapVC.swift
//  SnappyChat
//
//  Created by Isomi on 5/10/17.
//  Copyright © 2017 Humberto Espinola. All rights reserved.
//

import UIKit
import Firebase

class ViewSnapVC: UIViewController {

    // MARK: - UI Elements
    @IBOutlet weak var snapImageView: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    
    // MARK: - Class Properties
    var counter: Int!
    var image: UIImage!
    var snapId: String!
    var snapRef: FIRDatabaseReference!
    var imageReference: FIRStorageReference!
    private var timer = Timer()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(snapImageViewTapped))
        snapImageView.isUserInteractionEnabled = true
        snapImageView.addGestureRecognizer(imageTap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        snapImageView.image = image
        timerLabel.text = "\(counter!)"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countSecond), userInfo: nil, repeats: true)
    }
    
    // MARK: - Class Methods
    func snapImageViewTapped() {
        close()
    }
    
    func close() {
        DataService.shared.snapsReference.child(snapId).child("targets").child((FIRAuth.auth()?.currentUser?.uid)!).removeValue(completionBlock: { (error, reference) in
            if let error = error {
                print("DONKEY: Error trying to delete snap from database - \(error.localizedDescription)")
            } else {
                DataService.shared.snapsReference.child(self.snapId).observeSingleEvent(of: .value, with: { (snapshot) in
                    if !snapshot.hasChild("targets") {
                        self.imageReference.delete(completion: nil)
                        DataService.shared.snapsReference.child(self.snapId).removeValue()
                    }
                })
            }
        })
        
        dismiss(animated: true, completion: nil)
    }
    
    func countSecond() {
        if counter == 0 {
            close()
            return
        } else {
            counter = counter - 1
            timerLabel.text = "\(counter!)"
        }
    }
}
