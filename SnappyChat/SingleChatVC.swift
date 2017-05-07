//
//  SingleChatVC.swift
//  SnappyChat
//
//  Created by Isomi on 5/5/17.
//  Copyright © 2017 Humberto Espinola. All rights reserved.
//

import UIKit

class SingleChatVC: UIViewController {
    
    // MARK: - UI Elements
    @IBOutlet weak var backButton: UIButton!

    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - UI Actions
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
