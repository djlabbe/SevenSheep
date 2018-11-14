//
//  WakeUpLog.swift
//  SevenSheep
//
//  Created by Douglas Labbe on 11/13/18.
//  Copyright © 2018 Oh Baby Consulting, LLC. All rights reserved.
//

import Foundation

class WakeUpLog : Log {
    var wakeTime: Date
    var outOfBedTime:  Date
    
    init (childId id: String, childName name:String, date:Date, wakeTime:Date, outOfBedTime:Date, notes:String) {
        self.wakeTime = wakeTime
        self.outOfBedTime = outOfBedTime
        super.init(childId: id, childName: name, date: date, notes: notes)
    }
    
    var dictionary: [String: Any] {
        
        return [
            "childId": childId,
            "childName": childName,
            "date": date,
            "notes": notes,
            "wakeTime": wakeTime,
            "outOfBedTime": outOfBedTime
        ]
    }
}
