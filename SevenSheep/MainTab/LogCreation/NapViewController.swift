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
            +++ Section ("Nap")
            <<< TimeInlineRow() {
                $0.title = "Got in crib/bed"
                $0.tag = "inBedTime"
                }.cellUpdate { cell, row in
                    cell.tintColor = UIColor(named: "peach")
            }
            <<< TimeInlineRow() {
                $0.title = "Fell asleep"
                $0.tag = "asleepTime"
                }.cellUpdate { cell, row in
                    cell.tintColor = UIColor(named: "peach")
            }
            <<< TimeInlineRow() {
                $0.title = "Woke up"
                $0.tag = "wakeTime"
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
                    
                    guard let inBedTime = values["inBedTime"] as? Date else {
                        self.displayAlert(title: "Error", message: "Please enter the time your child got in bed.", buttonLabel: "Dismiss")
                        return
                    }
                    
                    guard let asleepTime = values["asleepTime"] as? Date else {
                        self.displayAlert(title: "Error", message: "Please enter the time your child fell asleep.", buttonLabel: "Dismiss")
                        return
                    }
                    
                    guard let wakeTime = values["wakeTime"] as? Date else {
                        self.displayAlert(title: "Error", message: "Please enter the time your child woke up.", buttonLabel: "Dismiss")
                        return
                    }
                    
                    if !( asleepTime > inBedTime && wakeTime > asleepTime) {
                        self.displayAlert(title: "Error", message: "Woops, it looks like your times are out of order. Please try again.", buttonLabel: "Dismiss")
                        return
                    }
                    
                    let notes = values["notes"] as? String
                    
                    let newLog = NapLog(
                        childId: self.getChildId(fromName: childName)!,
                        childName: childName,
                        date: date,
                        inBedTime: inBedTime,
                        asleepTime:  asleepTime,
                        wakeTime:  wakeTime,
                        notes:  notes ?? ""
                    )
                    
                    SVProgressHUD.show()
                    if (Auth.auth().currentUser?.uid) != nil {
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
