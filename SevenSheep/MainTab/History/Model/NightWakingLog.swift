//
//  NightWakingLog.swift
//  SevenSheep
//
//  Created by Douglas Labbe on 11/13/18.
//  Copyright © 2018 Oh Baby Consulting, LLC. All rights reserved.
//

import Foundation
import Firebase

struct NightWakingLog : Log {
    
    static let nightWakingType = "Night Waking"
    static let color = UIColor.init(named: "night-color")
    
    let type = nightWakingType
    
    var childId: String
    var childName: String
    var date: Date
    var notes: String
    var wakeTime: Date
    var asleepTime:  Date
    
    init (childId id: String, childName name:String, date:Date, wakeTime:Date, asleepTime:Date, notes:String) {
        self.childId = id
        self.childName = name
        self.date = date
        self.notes = notes
        self.wakeTime = wakeTime
        self.asleepTime = asleepTime
    }
    
    var dictionary: [String: Any] {
        
        return [
            "type": type,
            "childId": childId,
            "childName": childName,
            "date": date,
            "notes": notes,
            "wakeTime": wakeTime,
            "asleepTime": asleepTime
        ]
    }
}

extension NightWakingLog: DocumentSerializable {
    
    init?(dictionary: [String : Any]) {
        guard let childId = dictionary["childId"] as? String,
            let childName = dictionary["childName"] as? String,
            let date = dictionary["date"] as? Timestamp,
            let notes = dictionary["notes"] as? String,
            let wakeTime = dictionary["wakeTime"] as? Timestamp,
            let asleepTime = dictionary["asleepTime"] as? Timestamp
            else { return nil }
        
        
        self.init(childId: childId,
                  childName: childName,
                  date: date.dateValue(),
                  wakeTime: wakeTime.dateValue(),
                  asleepTime: asleepTime.dateValue(),
                  notes: notes)
    }
}
