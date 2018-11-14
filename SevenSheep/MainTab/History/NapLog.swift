//
//  NapLog.swift
//  SevenSheep
//
//  Created by Douglas Labbe on 11/13/18.
//  Copyright © 2018 Oh Baby Consulting, LLC. All rights reserved.
//

import Foundation

class NapLog : Log  {

    var inBedTime: Date
    var asleepTime:  Date
    var wakeTime: Date
    
    init (childId id: String, childName name:String, date:Date, inBedTime:Date, asleepTime:Date, wakeTime:Date, notes:String) {
        self.inBedTime = inBedTime
        self.asleepTime = asleepTime
        self.wakeTime = wakeTime
        super.init(childId: id, childName: name, date: date, notes: notes)
    }
    
    var dictionary: [String: Any] {
        
        return [
            "childId": childId,
            "childName": childName,
            "date": date,
            "notes": notes,
            "inBedTime": inBedTime,
            "asleepTime": asleepTime,
            "wakeTime": wakeTime
        ]
    }

}
