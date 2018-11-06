//
//  ChildrenNamesViewController.swift
//  SevenSheep
//
//  Created by Douglas Labbe on 10/24/18.
//  Copyright © 2018 Oh Baby Consulting, LLC. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

protocol ChildCreationDelegate {
    func addChild(child:Child)
}

class ChildrenViewController: UIViewController, ChildCreationDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var childrenTable: UITableView!
    
    var email:String?
    var firstName:String?
    var lastName:String?
    var userId:String?
    
    var userChildren:[Child] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        childrenTable.delegate = self
        childrenTable.dataSource = self
        userId = Auth.auth().currentUser?.uid
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        childrenTable.reloadData()
    }
    
    @IBAction func touchedAddChild(_ sender: UIButton) {
        let presentedVC = AddChildViewController();
        presentedVC.delegate = self
        present(presentedVC, animated: true, completion: nil)
    }
    
    
    @IBAction func touchedSubmit(_ sender: UIButton) {
        if !(userChildren.count > 0) {
            self.displayAlert(title: "Error", message: "You must add atleast one child.", buttonLabel: "Ok")
        } else {
            SVProgressHUD.show()
            let user = User(firstName: firstName!, lastName: lastName!, email: email! )
            self.db.collection("users").addDocument(data: user.dictionary) { err in
                SVProgressHUD.dismiss()
                if err != nil {
                    let errorCode = AuthErrorCode(rawValue: err!._code)
                    self.displayAlert(title: "Error", message: errorCode!.errorMessage, buttonLabel: "Dismiss")
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func touchedBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userChildren.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "child")
        cell.textLabel?.text = userChildren[indexPath.row].name
        return cell
    }
    
    // MARK: - ChildCreation
    
    func addChild(child:Child) {
        userChildren.append(child)
    }
    
}
