//
//  NightWakingLog.swift
//  SevenSheep
//
//  Created by Douglas Labbe on 11/13/18.
//  Copyright © 2018 Oh Baby Consulting, LLC. All rights reserved.
//

import Foundation

class NightWakingLog : Log {
    var wakeTime: Date
    var asleepTime:  Date
    
    init (childId id: String, childName name:String, date:Date, wakeTime:Date, asleepTime:Date, notes:String) {
        self.wakeTime = wakeTime
        self.asleepTime = asleepTime
        super.init(childId: id, childName: name, date: date, notes: notes)
    }
    
    var dictionary: [String: Any] {
        
        return [
            "childId": childId,
            "childName": childName,
            "date": date,
            "notes": notes,
            "wakeTime": wakeTime,
            "asleepTime": asleepTime
        ]
    }
}
