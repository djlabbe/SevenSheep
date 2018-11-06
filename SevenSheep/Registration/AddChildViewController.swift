//
//  AddChildViewController.swift
//  SevenSheep
//
//  Created by Douglas Labbe on 10/19/18.
//  Copyright © 2018 Oh Baby Consulting, LLC. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase
import Eureka

class AddChildViewController: FormViewController {
    
    var delegate:ChildCreationDelegate?
    
    let timeLocale = "en_US"
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.renderForm()
    }
    
    func renderForm() {
        self.form
            +++ Section("Add Child")
            <<< TextRow(){ row in
                row.title = "Name or Nick Name"
                row.tag = "name"
                row.placeholder = "Stella"
            }
            <<< DateRow() {
                $0.title = "Date of Birth"
                $0.tag = "dob"
                $0.value = Date()
            }
            <<< SegmentedRow<String>() {
                $0.options = ["Boy", "Girl"]
                $0.tag = "gender"
                }.cellUpdate { cell, row in
                    cell.segmentedControl.tintColor = UIColor(named: "peach")
            }
            +++ Section()
            <<< ButtonRow(){
                $0.title = "Submit"
                }.onCellSelection() { cell, row in
                    SVProgressHUD.show()
                    let values = self.form.values()
                    let parents = [Auth.auth().currentUser!.uid]
                    let child = Child(name: values["name"] as! String,
                                      dob: values["dob"] as! Date,
                                      gender: values["gender"] as! String,
                                      parents: parents)
                    if let delegate = self.delegate {
                        self.db.collection("children").addDocument(data: child.dictionary) { err in
                            SVProgressHUD.dismiss()
                            if err != nil {
                                self.displayAlert(title: "Error", message: "Unable to add child.", buttonLabel: "Dismiss")
                            } else {
                                delegate.addChild(child: child)
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                }.cellUpdate { cell, row in
                cell.textLabel?.textColor = UIColor(named: "peach")
            }
            +++ Section()
            <<< ButtonRow(){
                $0.title = "Cancel"
                }.cellUpdate { cell, row in
                    cell.textLabel?.textColor = UIColor.red
                }
                .onCellSelection() { cell, row in
                     self.dismiss(animated: true, completion: nil)
        }
    }
    
}
