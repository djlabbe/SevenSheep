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
        self.tableView.separatorColor = UIColor(named: "peach")
        self.renderForm()
    }
    
    func renderForm() {
        self.form
            +++ Section("Add Child")
            <<< TextRow(){
                $0.title = "Name or Nick Name"
                $0.tag = "name"
                }.cellUpdate { cell, row in
                    cell.tintColor = UIColor(named: "peach")
            }
            <<< DateInlineRow() {
                $0.title = "Date of Birth"
                $0.tag = "dob"
                }.cellUpdate { cell, row in
                    cell.tintColor = UIColor(named: "peach")
            }
            <<< SegmentedRow<String>() {
                $0.options = ["Boy", "Girl"]
                $0.tag = "gender"
                }.cellUpdate { cell, row in
                    cell.tintColor = UIColor(named: "peach")
            }
            +++ Section()
            <<< ButtonRow(){
                $0.title = "Submit"
                }.onCellSelection() { cell, row in

                    guard var childName = self.form.values()["name"] as? String else {
                        self.displayAlert(title: "Error", message: "Please enter a name.", buttonLabel: "Dismiss")
                        return
                    }
                    childName = childName.trim()
                    if (childName.count < 1) {
                        self.displayAlert(title: "Error", message: "Please enter a name.", buttonLabel: "Dismiss")
                        return
                    }
                    
                    guard let dob = self.form.values()["dob"] as? Date else {
                        self.displayAlert(title: "Error", message: "Please enter date of birth.", buttonLabel: "Dismiss")
                        return
                    }
                    
                    guard let gender = self.form.values()["gender"] as? String else {
                        self.displayAlert(title: "Error", message: "Please select a gender", buttonLabel: "Dismiss")
                        return
                    }
                    
                    let parents = [Auth.auth().currentUser!.uid]
                    
                    let child = Child(name: childName.trim(),
                                      dob: dob,
                                      gender: gender,
                                      parents: parents)
                    if let delegate = self.delegate {
                        SVProgressHUD.show()
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



