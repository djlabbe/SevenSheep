//
//  MainTabBarViewController.swift
//  SevenSheep
//
//  Created by Douglas Labbe on 11/10/18.
//  Copyright © 2018 Oh Baby Consulting, LLC. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    var childData:[(id: String, name: String)] = []
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.tabBar.unselectedItemTintColor = UIColor(named: "peach")
        if let userId = Auth.auth().currentUser?.uid {
            SVProgressHUD.show()
            db.collection("children").whereField("parents", arrayContains: userId)
                .addSnapshotListener { querySnapshot, error in
                    SVProgressHUD.dismiss()
                    guard let documents = querySnapshot?.documents else {
                        print("Error fetching children for \(userId): \(error!)")
                        return
                    }
                    self.childData = documents.map { ($0.documentID, $0["name"] as! String) }
            }
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if tabBar.selectedItem == self.tabBar.items![1] {
            let alert = UIAlertController(title: "Create Log", message: nil, preferredStyle: .actionSheet)
            alert.view.tintColor = UIColor.init(named: "peach")
            alert.addAction(UIAlertAction(title: "Morning Wake-up", style: .default) { action -> Void in
                let logForm = MorningWakeUpViewController()
                logForm.childData = self.childData
                self.present(logForm, animated: true, completion: nil)
            })
            alert.addAction(UIAlertAction(title: "Nap", style: .default)  { action -> Void in
                let logForm = NapViewController()
                logForm.childData = self.childData
                self.present(logForm, animated: true, completion: nil)
            })
            alert.addAction(UIAlertAction(title: "Bedtime", style: .default)  { action -> Void in
                let logForm = BedtimeViewController()
                logForm.childData = self.childData
                self.present(logForm, animated: true, completion: nil)
            })
            alert.addAction(UIAlertAction(title: "Night Waking", style: .default)  { action -> Void in
                let logForm = NightWakingViewController()
                logForm.childData = self.childData
                self.present(logForm, animated: true, completion: nil)
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
            return false
        }
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is LogForm {
            var vc = segue.destination as? LogForm
            vc?.childData = childData
        }
    }
}


