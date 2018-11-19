//
//  NightWakingViewController.swift
//  SevenSheep
//
//  Created by Douglas Labbe on 10/19/18.
//  Copyright © 2018 Oh Baby Consulting, LLC. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase
import Eureka

class NightWakingViewController: FormViewController, LogForm {
    
    let db = Firestore.firestore()
    let timeLocale = "en_US"
    let notesPlaceholderText = "Describe what happened during the period your child was awake. What did you do get them back to sleep?"
    var childData: [(id: String, name: String)]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorColor = UIColor(named: "peach")
        self.renderForm()
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
            +++ Section ("Night Waking")
            <<< TimeInlineRow() {
                $0.title = "Awoke"
                $0.tag = "wakeTime"
                }.cellUpdate { cell, row in
                    cell.tintColor = UIColor(named: "peach")
            }
            <<< TimeInlineRow() {
                $0.title = "Back asleep"
                $0.tag = "asleepTime"
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
                    
                    var values = self.form.values()
                    
                    guard let childName = values["activeChild"] as? String else {
                        self.displayAlert(title: "Error", message: "Please select a child.", buttonLabel: "Dismiss")
                        return
                    }
                    
                    guard let date = values["date"] as? Date else {
                        self.displayAlert(title: "Error", message: "Please enter a date.", buttonLabel: "Dismiss")
                        return
                    }
                    
                    guard let wakeTime = values["wakeTime"] as? Date else {
                        self.displayAlert(title: "Error", message: "Please enter the time your woke up.", buttonLabel: "Dismiss")
                        return
                    }
                    
                    guard let asleepTime = values["asleepTime"] as? Date else {
                        self.displayAlert(title: "Error", message: "Please enter the time your child fell back asleep.", buttonLabel: "Dismiss")
                        return
                    }
                    
                    
                    if !( asleepTime > wakeTime) {
                        self.displayAlert(title: "Error", message: "Woops, it looks like your times are out of order. Please try again.", buttonLabel: "Dismiss")
                        return
                    }
                    
                    let notes = values["notes"] as? String
                    
                    let newLog = NightWakingLog(
                        childId: self.getChildId(fromName: childName)!,
                        childName: childName,
                        date:  date,
                        wakeTime: wakeTime,
                        asleepTime:  asleepTime,
                        notes:  notes ?? ""
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
                }
                .onCellSelection() { cell, row in
                    self.dismiss(animated: true, completion: nil)
        }
    }
}

