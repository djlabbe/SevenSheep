//
//  MorningWakeUpViewController.swift
//  SevenSheep
//
//  Created by Douglas Labbe on 10/19/18.
//  Copyright © 2018 Oh Baby Consulting, LLC. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase
import Eureka

class MorningWakeUpViewController: FormViewController, LogForm {
    
    let db = Firestore.firestore()
    let timeLocale = "en_US"
    let notesPlaceholderText = "What did your child do between waking and getting out of crib/bed? Describe his/her mood upon waking?"
    var childData: [(id: String, name: String)]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.renderForm()
        self.tableView.separatorColor = UIColor(named: "peach")
    }
    
    func renderForm() {
        self.form
            +++ Section("Name & Date")
            <<< SegmentedRow<String>() {
                $0.options = childData!.map {$0.name}
                $0.tag = "activeChild"
                $0.value = childData!.count > 0 ? childData![0].name : nil
                }.cellUpdate { cell, row in
                    cell.tintColor = UIColor(named: "peach")
            }
            <<< DateInlineRow() {
                $0.title = "Date"
                $0.tag = "date"
                $0.value = Date()
                }.cellUpdate { cell, row in
                    cell.tintColor = UIColor(named: "peach")
            }
            +++ Section ("Morning")
            <<< TimeInlineRow() {
                $0.title = "Woke-up"
                $0.tag = "wakeTime"
                }.cellUpdate { cell, row in
                    cell.tintColor = UIColor(named: "peach")
            }
            <<< TimeInlineRow() {
                $0.title = "Out of crib/bed"
                $0.tag = "outOfBedTime"
                }.cellUpdate { cell, row in
                    cell.tintColor = UIColor(named: "peach")
            }
            +++ Section("Notes")
            <<< TextAreaRow(){
                $0.tag = "notes"
                $0.value = ""
                $0.placeholder = self.notesPlaceholderText
                }.cellUpdate { cell, row in
                    cell.tintColor = UIColor(named: "peach")
            }
            +++ Section()
            <<< ButtonRow(){
                $0.title = "Submit"
                }.onCellSelection() { cell, row in
                    
                    let values = self.form.values()
                    
                    guard let childName = values["activeChild"] as? String else {
                        self.displayAlert(title: "Error", message: "Please select a child.", buttonLabel: "Dismiss")
                        return
                    }
                    
                    guard let date = values["date"] as? Date else {
                        self.displayAlert(title: "Error", message: "Please enter a date.", buttonLabel: "Dismiss")
                        return
                    }
                    
                    guard let wakeTime = values["wakeTime"] as? Date else {
                        self.displayAlert(title: "Error", message: "Please enter the time your child woke up.", buttonLabel: "Dismiss")
                        return
                    }
                    
                    guard let outOfBedTime = values["outOfBedTime"] as? Date else {
                        self.displayAlert(title: "Error", message: "Please enter the time your child got out of bed.", buttonLabel: "Dismiss")
                        return
                    }
                    
                    if !(outOfBedTime > wakeTime) {
                        self.displayAlert(title: "Error", message: "Woops, it looks like your times are out of order. Please try again.", buttonLabel: "Dismiss")
                        return
                    }
                    
                    let notes = values["notes"] as? String
                    
                    let newLog = WakeUpLog(
                        childId: self.getChildId(fromName: childName)!,
                        childName: childName,
                        date: date,
                        wakeTime:  wakeTime,
                        outOfBedTime:  outOfBedTime,
                        notes: notes ?? ""
                    )
                    
                    if (Auth.auth().currentUser?.uid) != nil {
                        
                        SVProgressHUD.show()
                        self.db.collection("logs").addDocument(data: newLog.dictionary) { err in
                            SVProgressHUD.dismiss()
                            if err != nil {
                                self.displayAlert(title: "Error", message: "Error saving log. Please try again.", buttonLabel: "Dismiss")
                            } else {
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
                }.onCellSelection() { cell, row in
                    self.dismiss(animated: true, completion: nil)
        }
    }
}


