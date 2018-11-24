//
//  DetailViewController.swift
//  SevenSheep
//
//  Created by Douglas Labbe on 11/19/18.
//  Copyright © 2018 Oh Baby Consulting, LLC. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LogCell: UITableViewCell {
    @IBOutlet weak var borderImage: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var time1Label: UILabel!
    @IBOutlet weak var time2Label: UILabel!
    @IBOutlet weak var time3Label: UILabel!
}

class DetailViewController: UITableViewController {
    
    let db = Firestore.firestore()
    
    var childId: String?
    
    var allLogs:[Log] = []
    var selectedLog: Log?
    
    var tableData = [LogTableSection]()
    
    struct LogTableSection {
        var date : String!
        var logs : [Log]!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (Auth.auth().currentUser?.uid) != nil {
            SVProgressHUD.show()
            db.collection("logs").whereField("childId", isEqualTo: childId!)
                .addSnapshotListener { querySnapshot, error in
                    SVProgressHUD.dismiss()
                    guard let documents = querySnapshot?.documents else {
                        print("Error fetching logs for \(self.childId ?? "nil"): \(error!)")
                        return
                    }
                    
                    self.allLogs.removeAll()
                    self.tableData.removeAll()
                    
                    for doc in documents {
                        let logData = doc.data()
                        var log: Log?
                        switch logData["type"] as! String {
                        case NapLog.napType:
                            log = NapLog(dictionary: logData)
                        case WakeUpLog.wakeUptype:
                            log = WakeUpLog(dictionary: logData)
                        case BedtimeLog.bedTimeType:
                            log = BedtimeLog(dictionary: logData)
                        case NightWakingLog.nightWakingType:
                            log = NightWakingLog(dictionary: logData)
                        default:
                            log = nil
                        }
                        self.allLogs.append(log!)
                    }
                    
                    let data = Dictionary(grouping: self.allLogs, by: {$0.date.toUSDate()})
                 
                    for (key, value) in data {
                        self.tableData.append(LogTableSection(date: key, logs: value))
                    }
                    
                    self.tableView.reloadData()
                    
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section].logs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "log", for: indexPath) as! LogCell
        
        let log = tableData[indexPath.section].logs[indexPath.row]
        cell.borderImage.backgroundColor = getColorForType(log.type)
        cell.typeLabel.text = log.type
        setTimeLabelsForCell(cell: cell, log: log)
        return cell
    }
    
    func setTimeLabelsForCell(cell: LogCell, log: Log) {
        switch log.type {
        case NapLog.napType:
            let napLog = log as! NapLog
            cell.time1Label.text = "In bed - \(napLog.inBedTime.toShortUSTimeString())"
            cell.time2Label.text = "Asleep - \(napLog.asleepTime.toShortUSTimeString())"
            cell.time3Label.text = "Awake - \(napLog.wakeTime.toShortUSTimeString())"
        case WakeUpLog.wakeUptype:
            let wakeUpLog = log as! WakeUpLog
            cell.time1Label.text = "Awake - \(wakeUpLog.wakeTime.toShortUSTimeString())"
            cell.time2Label.text = "Out of bed - \(wakeUpLog.outOfBedTime.toShortUSTimeString())"
            cell.time3Label.text = ""
        case BedtimeLog.bedTimeType:
            let bedtimeLog = log as! BedtimeLog
            cell.time1Label.text = "Start - \(bedtimeLog.startTime.toShortUSTimeString())"
            cell.time2Label.text = "In bed - \(bedtimeLog.inBedTime.toShortUSTimeString())"
            cell.time3Label.text = "Asleep - \(bedtimeLog.asleepTime.toShortUSTimeString())"
        case NightWakingLog.nightWakingType:
            let nightWakingLog = log as! NightWakingLog
            cell.time1Label.text = "Awake - \(nightWakingLog.wakeTime.toShortUSTimeString())"
            cell.time2Label.text = "Back to sleep - \(nightWakingLog.asleepTime.toShortUSTimeString())"
            cell.time3Label.text = ""
        default:
            cell.time1Label.text = ""
            cell.time2Label.text = ""
            cell.time3Label.text = ""
        }
    }
    
    func getColorForType(_ type: String) -> UIColor {
        switch type {
        case NapLog.napType:
            return NapLog.color ?? .white
        case WakeUpLog.wakeUptype:
            return WakeUpLog.color ?? .white
        case BedtimeLog.bedTimeType:
            return BedtimeLog.color ?? .white
        case NightWakingLog.nightWakingType:
            return NightWakingLog.color ?? .white
        default:
            return .white
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableData[section].date
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedLog = tableData[indexPath.section].logs[indexPath.row]
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? LogDetailViewController{
            destination.log = selectedLog
        }
     }
    
}


