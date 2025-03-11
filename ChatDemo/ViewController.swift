//
//  ViewController.swift
//  ChatDemo
//
//  Created by Ritik on 28/02/25.
//

import UIKit
import RBChat

class ViewController: UIViewController {
    
    @IBOutlet var ChatButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func chatButtonAction(_ sender: UIButton) {
        let currentUser = ChatUser(senderId: "1", displayName: "Arpan")
        let vc = ChatViewController(currentUser: currentUser)
        navigationController?.pushViewController(vc, animated: true)
    }
}

