//
//  NapViewController.swift
//  SevenSheep
//
//  Created by Douglas Labbe on 10/19/18.
//  Copyright © 2018 Oh Baby Consulting, LLC. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase
import Eureka

class NapViewController: FormViewController, LogForm {
    
    let db = Firestore.firestore()
    let timeLocale = "en_US"
    let notesPlaceholderText = "Describe the process of getting ready for the nap and falling asleep."
    var childData: [(id: String, name: String)]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.renderForm()
    }
    
    func renderForm() {
        self.form
            +++ Section("Name & Date")
            <<< SegmentedRow<String>() {
                $0.options = childData!.map {$0.name}
                $0.tag = "activeChild"
                $0.value = childData!.count > 0 ? childData![0].name : nil
            }
            <<< DateRow() {
                $0.title = "Date"
                $0.tag = "date"
                $0.value = Date()
            }
            +++ Section ("Nap")
            <<< TimeRow() {
                $0.title = "Got in crib/bed"
                $0.tag = "inBedTime"
                $0.value = Date()
            }
            <<< TimeRow() {
                $0.title = "Fell asleep"
                $0.tag = "asleepTime"
                $0.value = Date()
            }
            <<< TimeRow() {
                $0.title = "Woke up"
                $0.tag = "wakeTime"
                $0.value = Date()
            }
            +++ Section("Notes")
            <<< TextAreaRow(){
                $0.tag = "notes"
                $0.value = ""
                $0.placeholder = self.notesPlaceholderText
            }
            +++ Section()
            <<< ButtonRow(){
                $0.title = "Submit"
                }.onCellSelection() { cell, row in
                    SVProgressHUD.show()
                    if (Auth.auth().currentUser?.uid) != nil {
                        var logEntry = self.form.values()
                        
                        let newLog = NapLog(
                            childId: self.getChildId(fromName: logEntry["activeChild"] as! String)!,
                            childName: logEntry["activeChild"] as! String,
                            date:  logEntry["date"] as! Date,
                            inBedTime: logEntry["inBedTime"] as! Date,
                            asleepTime:  logEntry["asleepTime"] as! Date,
                            wakeTime:  logEntry["wakeTime"] as! Date,
                            notes:  logEntry["notes"] as! String
                        )
                        
                        self.db.collection("logs").addDocument(data: newLog.dictionary) { err in
                            SVProgressHUD.dismiss()
                            if err != nil {
                                self.displayAlert(title: "Error", message: "Error saving log. Please try again.", buttonLabel: "Dismiss")
                            } else {
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
            }
            +++ Section()
            <<< ButtonRow(){
                $0.title = "Cancel"
                }.cellUpdate { cell, row in
                    cell.textLabel?.textColor = UIColor.red
                }.onCellSelection() { cell, row in
                    self.dismiss(animated: true, completion: nil)
        }
    }
}
