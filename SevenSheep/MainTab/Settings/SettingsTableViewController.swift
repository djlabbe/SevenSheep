//
//  ControlPanelTableViewController.swift
//  SevenSheep
//
//  Created by Douglas Labbe on 10/20/18.
//  Copyright © 2018 Oh Baby Consulting, LLC. All rights reserved.
//

import UIKit
import Firebase

class SettingsTableViewController: UITableViewController, ChildCreationDelegate {
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let presentedVC = AddChildViewController();
            presentedVC.delegate = self
            present(presentedVC, animated: true, completion: nil)
        case 1:
            do {
                try Firebase.Auth.auth().signOut()
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            }
            catch {
                self.displayAlert(title: "Error", message: "Unable to log out. Please try again soon.", buttonLabel: "Dismiss")
            }
        default:
            print ("User selected a control panel row that doesn't exist")
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // Don't care. New child will be reflected in other views.
    func addChild(child: Child) {
        return
    }

}
