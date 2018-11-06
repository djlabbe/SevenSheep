//
//  ErrorAlert.swift
//  SevenSheep
//
//  Created by Douglas Labbe on 10/26/18.
//  Copyright © 2018 Oh Baby Consulting, LLC. All rights reserved.
//

import UIKit
import Foundation

extension  UIViewController {
    func displayAlert(title: String, message: String, buttonLabel: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: buttonLabel, style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
    }
}
