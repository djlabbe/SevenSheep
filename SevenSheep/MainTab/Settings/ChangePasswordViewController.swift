//
//  ChangePasswordViewController.swift
//  SevenSheep
//
//  Created by Douglas Labbe on 11/10/18.
//  Copyright © 2018 Oh Baby Consulting, LLC. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var currentPasswordTextField: UITextField!
    
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    @IBOutlet weak var confirmationTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func touchedSubmit(_ sender: UIButton) {
        let user = Auth.auth().currentUser
        
        // Prompt the user to re-provide their sign-in credentials
        let email = user!.email!
        let currentPassword = currentPasswordTextField.text!
        let newPassword1 = newPasswordTextField.text!
        let newPassword2 = confirmationTextField.text!
        
        if !(newPassword1 == newPassword2) {
            self.displayAlert(title: "Dismiss", message: "New password fields do not match.", buttonLabel: "Dismiss")
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        
        user?.reauthenticate(with: credential) { error in
            if error != nil {
                let errorCode = AuthErrorCode(rawValue: error!._code);
                self.displayAlert(title: "Error", message: errorCode!.errorMessage, buttonLabel: "Dismiss")
            } else {
                SVProgressHUD.show()
                Auth.auth().currentUser?.updatePassword(to: newPassword1) { (error) in
                    SVProgressHUD.dismiss()
                    if error != nil {
                        let errorCode = AuthErrorCode(rawValue: error!._code);
                        self.displayAlert(title: "Error", message: errorCode!.errorMessage, buttonLabel: "Dismiss")
                    } else {
                        let alert = UIAlertController(title: "Success", message: "Password changed.", preferredStyle: .alert)
                        let action = UIAlertAction(title: "Dismiss", style: .default, handler: { (UIAlertAction) in
                            // Dismiss the ChangePasswordVC when user dismisses alert dialog
                            self.dismiss(animated: true, completion: nil)
                        })
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
        
    }
    
    
    
    @IBAction func touchedCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

