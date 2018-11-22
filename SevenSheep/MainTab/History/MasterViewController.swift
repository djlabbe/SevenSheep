//
//  MasterViewController.swift
//  SevenSheep
//
//  Created by Douglas Labbe on 11/19/18.
//  Copyright © 2018 Oh Baby Consulting, LLC. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ChildTableCell: UITableViewCell {
    @IBOutlet weak var childImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
}

class MasterViewController: UITableViewController, UISplitViewControllerDelegate {
    
    var childData:[(id: String, name: String, gender: String)] = []
    var selectedChildId: String?
    let db = Firestore.firestore()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        splitViewController?.delegate = self
    }
    

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        
        if let detailNavController = secondaryViewController as? UINavigationController {
            if let detailVC = detailNavController.topViewController as? DetailViewController {
                return detailVC.childId == nil
            }
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let userId = Auth.auth().currentUser?.uid {
            SVProgressHUD.show()
            db.collection("children").whereField("parents", arrayContains: userId)
                .addSnapshotListener { querySnapshot, error in
                    SVProgressHUD.dismiss()
                    guard let documents = querySnapshot?.documents else {
                        print("Error fetching children for \(userId): \(error!)")
                        return
                    }
                    self.childData = documents.map { ($0.documentID, $0["name"] as! String, $0["gender"] as! String) }
                    self.tableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "child", for: indexPath) as! ChildTableCell
        
        let child = childData[indexPath.row]
        cell.childImage.image = child.gender == "Boy" ? UIImage(named: "baby-Boy") : UIImage(named: "baby-Girl")
        cell.nameLabel.text = child.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedChildId = childData[indexPath.row].id
        self.performSegue(withIdentifier: "showDetail", sender: self)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationNav = segue.destination as? UINavigationController
        
        if let vc = destinationNav!.topViewController as? DetailViewController {
            vc.childId = selectedChildId
        }
        
    }

}
