//
//  NameViewController.swift
//  SevenSheep
//
//  Created by Douglas Labbe on 10/24/18.
//  Copyright © 2018 Oh Baby Consulting, LLC. All rights reserved.
//

import UIKit

class NameViewController: UIViewController {
    
    var email:String?
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTextField.becomeFirstResponder();
        
    }
    
    @IBAction func touchedContinue(_ sender: UIButton) {
        performSegue(withIdentifier: "toChildrenNames", sender: self)
    }
    
    @IBAction func touchedBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "toChildrenNames":
                if let vc = segue.destination as? ChildrenViewController {
                    vc.email = email
                    vc.firstName = firstNameTextField.text!.trim()
                    vc.lastName = lastNameTextField.text!.trim()
                }
            default:  break
            }
        }
    }
    
}

