//
//  ResetPasswordViewController.swift
//  SevenSheep
//
//  Created by Douglas Labbe on 11/1/18.
//  Copyright © 2018 Oh Baby Consulting, LLC. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func touchedBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func touchedReset(_ sender: UIButton) {
        let email = emailTextField.text!.trim()
        SVProgressHUD.show()
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            SVProgressHUD.dismiss()
            if (error != nil) {
                self.displayAlert(title: "Error", message: "Unable to process request.", buttonLabel: "Dismiss")
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
