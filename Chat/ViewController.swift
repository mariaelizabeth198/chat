//
//  ViewController.swift
//  chat
//
//  Created by Maria Elizabeth Da Silva Bezerra on 06/02/2019.
//  Copyright © 2019 Maria Elizabeth. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    }

    @objc fileprivate func handleLogout() {
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
}

