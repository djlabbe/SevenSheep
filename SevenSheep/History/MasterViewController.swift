//
//  ChildSelectTableViewController.swift
//  Sleepio
//
//  Created by Douglas Labbe on 10/28/18.
//  Copyright © 2018 Oh Baby Consulting, LLC. All rights reserved.
//

import UIKit
import Firebase

protocol ChildSelectionDelegate: class {
    func childSelected(withId id: String, withName name: String)
}

class ChildSelectViewController: UITableViewController {

    weak var selectionDelegate: ChildSelectionDelegate?
    
    var childrenDbRef: DatabaseReference?
    var childData:[(id: String, name: String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectionDelegate = self.splitViewController?.viewControllers.last as? ChildSelectionDelegate

        if let userId = Auth.auth().currentUser?.uid {
            childrenDbRef = Database.database().reference().child("users/\(userId)/children")
            childrenDbRef!.observe(.childAdded) { (snapshot) in
                self.childData.append((snapshot.key, snapshot.value as! String))
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: [IndexPath(row: self.childData.count-1, section: 0)], with: .automatic)
                self.tableView.endUpdates()
            }
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return childData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "child", for: indexPath)
        cell.textLabel!.text = childData[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedChildData = childData[indexPath.row]
        selectionDelegate?.childSelected(withId: selectedChildData.id, withName: selectedChildData.name)
        
        if let detailViewController = selectionDelegate as? DetailViewController {
            splitViewController?.showDetailViewController(detailViewController, sender: self)
        }
        
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
