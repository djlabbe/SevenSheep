//
//  LoginViewController.swift
//  SevenSheep
//
//  Created by Douglas Labbe on 10/23/18.
//  Copyright © 2018 Oh Baby Consulting, LLC. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.becomeFirstResponder();
    }
    
    @IBAction func touchedForgotPassword(_ sender: UIButton) {
        // TODO: Implement forgot password via Firebase
    }
    
    
    @IBAction func touchedLogin(_ sender: UIButton) {
        SVProgressHUD.show()
        
        Firebase.Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            SVProgressHUD.dismiss()
            if (error != nil) {
                let errorCode = AuthErrorCode(rawValue: error!._code);
                self.displayAlert(title: "Error", message: errorCode!.errorMessage, buttonLabel: "Dismiss")
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func touchedClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
