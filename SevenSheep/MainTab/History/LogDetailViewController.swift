//
//  LogDetailViewController.swift
//  SevenSheep
//
//  Created by Douglas Labbe on 11/24/18.
//  Copyright © 2018 Oh Baby Consulting, LLC. All rights reserved.
//

import UIKit

class LogDetailViewController: UIViewController {

    var log: Log?
    @IBOutlet weak var notesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesLabel.text = log?.notes == "" ? "No notes recorded" : log?.notes
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
