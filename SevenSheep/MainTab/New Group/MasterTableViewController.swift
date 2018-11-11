//
//  MasterTableViewController.swift
//  SevenSheep
//
//  Created by Douglas Labbe on 10/28/18.
//  Copyright © 2018 Oh Baby Consulting, LLC. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ChildTableViewCell: UITableViewCell {
    @IBOutlet weak var childLabel: UILabel!
    @IBOutlet weak var childImageView: UIImageView!
}

class MasterTableViewController: UITableViewController, UISplitViewControllerDelegate {
    
    var detailTableViewController: DetailTableViewController? = nil
    var userChildren:[Child] = []
    var childIds: [String] = []
    let db = Firestore.firestore()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        splitViewController?.delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if let cvc = secondaryViewController as? DetailTableViewController {
            if cvc.childId == nil {
                return true
            }
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userId = Auth.auth().currentUser?.uid {
            let query = db.collection("children").whereField("parents", arrayContains: userId)
            SVProgressHUD.show()
            query.addSnapshotListener() {(snapshot, err) in
                SVProgressHUD.dismiss()
                self.userChildren.removeAll()
                self.childIds.removeAll()
                if let err = err {
                    print("Error getting children docs: \(err)")
                } else {
                    for document in snapshot!.documents {
                        if let child = Child.init(dictionary: document.data()) {
                            self.userChildren.append(child)
                            self.childIds.append(document.documentID)
                        }
                    }
                    
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let controller = segue.destination as! DetailTableViewController
        
            if let indexPath = tableView.indexPathForSelectedRow {
                controller.childId = childIds[indexPath.row]
                controller.childName = userChildren[indexPath.row].name
            }
            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userChildren.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ChildTableViewCell
        
        let thisChild = userChildren[indexPath.row]
        cell.childLabel!.text = thisChild.name
        let imageName = "baby-\(thisChild.gender)"
        cell.childImageView?.image = UIImage(named: imageName)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }
    
}

