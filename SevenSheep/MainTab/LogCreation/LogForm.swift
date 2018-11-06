//
//  LogFormViewController.swift
//  SevenSheep
//
//  Created by Douglas Labbe on 10/28/18.
//  Copyright © 2018 Oh Baby Consulting, LLC. All rights reserved.
//

import UIKit
import Eureka
import Firebase

protocol LogForm {
    var childData: [(id: String, name: String)]? {get set}
    var timeLocale: String {get}
    func renderForm()
}

extension LogForm {
    
    func getChildId(fromName name: String) -> String? {
        for datum in childData! {
            if datum.name == name {
                return datum.id
            }
        }
        return nil
    }
}
