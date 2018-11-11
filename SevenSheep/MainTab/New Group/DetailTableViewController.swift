//
//  DetailTableViewController.swift
//  SevenSheep
//
//  Created by Douglas Labbe on 10/28/18.
//  Copyright © 2018 Oh Baby Consulting, LLC. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LogEntryTableViewCell: UITableViewCell {
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet var detailLabels: [UILabel]!
}

class DetailTableViewController: UITableViewController {
    
    let logsRef = Firestore.firestore().collection("logs")
    
    var logs = [Log]() {
        didSet {
            tableData.removeAll()
            var mappedLogs = [String:[Log]]()
            
            logs.forEach { mappedLogs[$0.date.toUSDate()] == nil ? mappedLogs[$0.date.toUSDate()] = [$0] : mappedLogs[$0.date.toUSDate()]!.append($0) }
            
            for (key, value) in mappedLogs {
                tableData.append(LogTableData(sectionName: key, date: key.toUSDate()!, sectionItems: value))
            }

            tableData = tableData.sorted(by: { $0.date > $1.date })
        }
    }
    
    var tableData = [LogTableData]()
    struct LogTableData {
        var sectionName: String
        var date: Date
        var sectionItems: [Log]
    }
    
    var childId:String? {
        didSet {
            configureView()
        }
    }
    
    var childName:String? {
        didSet {
            if childName != nil {
                self.title = childName
            }
        }
    }
    
    func configureView() {
        logs.removeAll()
        
        if let id = childId {
            SVProgressHUD.show()
            let query = logsRef.whereField("childId", isEqualTo: id).order(by: "date")
            query.addSnapshotListener { snapshot, error in
                SVProgressHUD.dismiss()
                guard (snapshot?.documents) != nil else {
                    print("Error getting logs for \(id): \(error!)")
                    return
                }
                self.logs.removeAll()
                for document in snapshot!.documents {
                    let rawData = document.data()
                    
                    if let logType = rawData["type"] as? String {
                        
                        switch logType {
                        case WakeUpLog.typeStr:
                            if let log = WakeUpLog(dictionary: rawData) {
                                self.logs.append(log)
                            }
                        case NapLog.typeStr:
                            if let log = NapLog(dictionary: rawData) {
                                self.logs.append(log)
                            }
                        case BedtimeLog.typeStr:
                            if let log = BedtimeLog(dictionary: rawData) {
                                self.logs.append(log)
                            }
                        case NightWakingLog.typeStr:
                            if let log = NightWakingLog(dictionary: rawData) {
                                self.logs.append(log)
                            }
                        default:
                            break
                        }
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "logCell", for: indexPath) as! LogEntryTableViewCell
        
        let log = tableData[indexPath.section].sectionItems[indexPath.row]
        
        switch log.type {
        case WakeUpLog.typeStr:
            let wakeLog = log as! WakeUpLog
            cell.colorView.backgroundColor = UIColor(named: "morning-color")
            cell.detailLabels[0].text = "Wake: \(wakeLog.wakeTime.toShortUSTimeString())"
            cell.detailLabels[1].text = "Out of Bed: \(wakeLog.wakeTime.toShortUSTimeString())"
            cell.detailLabels[2].text = ""
        case NapLog.typeStr:
            let napLog = log as! NapLog
            cell.colorView.backgroundColor = UIColor(named: "afternoon-color")
            cell.detailLabels[0].text = "In bed: \(napLog.inBedTime.toShortUSTimeString())"
            cell.detailLabels[1].text = "Asleep: \(napLog.asleepTime.toShortUSTimeString())"
            cell.detailLabels[2].text = "Wake: \(napLog.wakeTime.toShortUSTimeString())"
        case BedtimeLog.typeStr:
            let bedtimeLog = log as! BedtimeLog
            cell.colorView.backgroundColor = UIColor(named: "evening-color")
            cell.detailLabels[0].text = "Start: \(bedtimeLog.startTime.toShortUSTimeString())"
            cell.detailLabels[1].text = "In bed: \(bedtimeLog.inBedTime.toShortUSTimeString())"
            cell.detailLabels[2].text = "Asleep: \(bedtimeLog.asleepTime.toShortUSTimeString())"
        case NightWakingLog.typeStr:
            let nightWakingLog = log as! NightWakingLog
            cell.colorView.backgroundColor = UIColor(named: "night-color")
            cell.detailLabels[0].text = "Wake: \(nightWakingLog.wakeTime.toShortUSTimeString())"
            cell.detailLabels[1].text = "Asleep: \(nightWakingLog.asleepTime.toShortUSTimeString())"
            cell.detailLabels[2].text = ""
        default:
            cell.detailLabels.forEach { $0.text = "" }
        }
        
        cell.mainLabel!.text = log.type
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableData[section].sectionName
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section].sectionItems.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = UIColor.darkGray
            headerView.textLabel?.textColor = .white
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let log = tableData[indexPath.section].sectionItems[indexPath.row]
        let message = log.notes == "" ? "No notes" : log.notes
        self.displayAlert(title: "Notes", message: message, buttonLabel: "Dismiss")
    }
}
