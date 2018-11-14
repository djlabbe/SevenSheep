//
//  Log.swift
//  SevenSheep
//
//  Created by Douglas Labbe on 11/13/18.
//  Copyright © 2018 Oh Baby Consulting, LLC. All rights reserved.
//

import Foundation

class Log {
    var childId: String
    var childName: String
    var date:  Date
    var notes:  String
    
    init(childId: String, childName: String, date: Date, notes: String) {
        self.childId = childId
        self.childName = childName
        self.date = date
        self.notes = notes
    }
    
}
