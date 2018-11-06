//
//  PasswordViewController.swift
//  SevenSheep
//
//  Created by Douglas Labbe on 10/24/18.
//  Copyright © 2018 Oh Baby Consulting, LLC. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class PasswordViewController: UIViewController {
    
    var email:String?
    
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.becomeFirstResponder();
    }
    
    @IBAction func touchedContinue(_ sender: UIButton) {
        
        let userPassword = passwordTextField.text!.trim()
        
        SVProgressHUD.show()
        
        Firebase.Auth.auth().createUser(withEmail: email ?? "", password: userPassword) { (user, error) in
            if (error != nil) {
                SVProgressHUD.dismiss()
                let errorCode = AuthErrorCode(rawValue: error!._code);
                self.displayAlert(title: "Error", message: errorCode!.errorMessage, buttonLabel: "Dismiss")
            } else {
                self.performSegue(withIdentifier: "toName", sender: self)
            }
        }
    }

    @IBAction func touchedBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is NameViewController
        {
            let vc = segue.destination as? NameViewController
            vc?.email = email
        }
    }
}
