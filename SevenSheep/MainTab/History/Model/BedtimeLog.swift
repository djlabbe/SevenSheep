//
//  BedtimeLog.swift
//  SevenSheep
//
//  Created by Douglas Labbe on 11/13/18.
//  Copyright © 2018 Oh Baby Consulting, LLC. All rights reserved.
//

import Foundation

class BedtimeLog : Log {
    
    var startTime: Date
    var inBedTime:  Date
    var asleepTime: Date
    
    init (childId id: String, childName name:String, date:Date, startTime:Date, inBedTime:Date, asleepTime: Date, notes:String) {
        self.startTime = startTime
        self.inBedTime = inBedTime
        self.asleepTime = asleepTime
        super.init(childId: id, childName: name, date: date, notes: notes)
    }
    
    var dictionary: [String: Any] {
        
        return [
            "childId": childId,
            "childName": childName,
            "date": date,
            "notes": notes,
            "startTime": startTime,
            "inBedTime": inBedTime,
            "asleepTime": asleepTime
        ]
    }
}
