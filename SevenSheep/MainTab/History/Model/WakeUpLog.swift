//
//  WakeUpLog.swift
//  SevenSheep
//
//  Created by Douglas Labbe on 11/13/18.
//  Copyright © 2018 Oh Baby Consulting, LLC. All rights reserved.
//

import Foundation
import Firebase

struct WakeUpLog : Log {
    
    static let wakeUptype = "Wake-up"
    static let color = UIColor.init(named: "morning-color")
    
    let type = wakeUptype
    
    var childId: String
    var childName: String
    var date: Date
    var notes: String
    var wakeTime: Date
    var outOfBedTime:  Date
    
    init (childId id: String, childName name:String, date:Date, wakeTime:Date, outOfBedTime:Date, notes:String){
        self.childId = id
        self.childName = name
        self.date = date
        self.notes = notes
        self.wakeTime = wakeTime
        self.outOfBedTime = outOfBedTime
    }
    
    var dictionary: [String: Any] {
        
        return [
            "type": type,
            "childId": childId,
            "childName": childName,
            "date": date,
            "notes": notes,
            "wakeTime": wakeTime,
            "outOfBedTime": outOfBedTime
        ]
    }
}

extension WakeUpLog: DocumentSerializable {
    
    init?(dictionary: [String : Any]) {
        guard let childId = dictionary["childId"] as? String,
            let childName = dictionary["childName"] as? String,
            let date = dictionary["date"] as? Timestamp,
            let notes = dictionary["notes"] as? String,
            let wakeTime = dictionary["wakeTime"] as? Timestamp,
            let outOfBedTime = dictionary["outOfBedTime"] as? Timestamp
            else { return nil }
        
        self.init(childId: childId,
                  childName: childName,
                  date: date.dateValue(),
                  wakeTime: wakeTime.dateValue(),
                  outOfBedTime: outOfBedTime.dateValue(),
                  notes: notes)
    }
}
