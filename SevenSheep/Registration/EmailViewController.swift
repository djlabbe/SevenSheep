//
//  RegistrationViewController.swift
//  SevenSheep
//
//  Created by Douglas Labbe on 10/23/18.
//  Copyright © 2018 Oh Baby Consulting, LLC. All rights reserved.
//

import UIKit

class EmailViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.becomeFirstResponder();
    }
    
    @IBAction func touchedContinue(_ sender: UIButton) {
        performSegue(withIdentifier: "toPassword", sender: self)
    }
    
    @IBAction func touchedClose(_ sender: UIButton) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is PasswordViewController
        {
            let vc = segue.destination as? PasswordViewController
            vc?.email = emailTextField.text!.trim()
        }
    }
    
}
