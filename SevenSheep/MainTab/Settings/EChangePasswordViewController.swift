//
//  EChangePasswordViewController.swift
//  SevenSheep
//
//  Created by Douglas Labbe on 11/20/18.
//  Copyright © 2018 Oh Baby Consulting, LLC. All rights reserved.
//

import Foundation
import Eureka
import Firebase
import SVProgressHUD

class EChangePasswordViewController: FormViewController {
    
    let db = Firestore.firestore()
    let timeLocale = "en_US"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorColor = UIColor(named: "peach")
        self.renderForm()
    }
    
    func renderForm() {
        self.form
            +++ Section("Change Password")
            <<< PasswordRow(){
                $0.tag = "current"
                $0.title = "Current password"
                $0.value = ""
                }.cellUpdate { cell, row in
                    cell.tintColor = UIColor(named: "peach")
            }
            <<< PasswordRow(){
                $0.tag = "new1"
                $0.title = "New password"
                $0.value = ""
                }.cellUpdate { cell, row in
                    cell.tintColor = UIColor(named: "peach")
            }
            <<< PasswordRow(){
                $0.tag = "new2"
                $0.title = "New password"
                $0.value = ""
                }.cellUpdate { cell, row in
                    cell.tintColor = UIColor(named: "peach")
            }
            +++ Section()
            
            <<< ButtonRow(){
                $0.title = "Submit"
                }.onCellSelection() { cell, row in
                    let user = Auth.auth().currentUser
                    
                    // Prompt the user to re-provide their sign-in credentials
                    let email = user!.email!
                    let currentPassword = self.form.values()["current"] as! String
                    let newPassword1 = self.form.values()["new1"] as! String
                    let newPassword2 = self.form.values()["new2"] as! String
                    
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
                    
                }.cellUpdate { cell, row in
                    cell.backgroundColor = UIColor(named: "peach")
                    cell.textLabel?.textColor = .white
            }
            +++ Section()
            <<< ButtonRow(){
                $0.title = "Cancel"
                }.cellUpdate { cell, row in
                    cell.backgroundColor = .white
                    cell.textLabel?.textColor = UIColor(named: "peach")
                }
                .onCellSelection() { cell, row in
                    self.dismiss(animated: true, completion: nil)
        }
    }
}
