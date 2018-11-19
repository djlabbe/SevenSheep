//
//  LogSelectViewController.swift
//  SevenSheep
//
//  Created by Douglas Labbe on 10/26/18.
//  Copyright © 2018 Oh Baby Consulting, LLC. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase

class LogSelectViewController: UIViewController {
    
//    var childData:[(id: String, name: String)] = []
//
//    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        if let userId = Auth.auth().currentUser?.uid {
//            db.collection("children").whereField("parents", arrayContains: userId)
//                .addSnapshotListener { querySnapshot, error in
//                    guard let documents = querySnapshot?.documents else {
//                        print("Error fetching children for \(userId): \(error!)")
//                        return
//                    }
//                    self.childData = documents.map { ($0.documentID, $0["name"] as! String) }
//            }
//        }
    }
    
    // MARK: - Navigation
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.destination is LogForm {
//            var vc = segue.destination as? LogForm
//            vc?.childData = childData
//        }
//    }
}
