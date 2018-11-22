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

class DetailViewController: UITableViewController {
    
    let db = Firestore.firestore()
    
    var childId: String?
    
    var allLogs:[Log] = []
    
    var tableData = [LogTableSection]()
    
    struct LogTableSection {
        var date : String!
        var logs : [Log]!
    }
    
    func dateExists(_ date: String) -> Bool {
        return tableData.contains(where: { $0.date == date })
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "log", for: indexPath)
        cell.textLabel!.text = tableData[indexPath.section].logs[indexPath.row].childName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableData[section].date
    }
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


