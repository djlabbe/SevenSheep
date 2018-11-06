//
//  RootViewController.swift
//  SevenSheep
//
//  Created by Douglas Labbe on 10/23/18.
//  Copyright © 2018 Oh Baby Consulting, LLC. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase

class RootViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SVProgressHUD.show()
        Firebase.Auth.auth().addStateDidChangeListener {
            auth, user in
            SVProgressHUD.dismiss()
            if user != nil {
                self.performSegue(withIdentifier: "toMain", sender: self)
            }
        }
    }
}
