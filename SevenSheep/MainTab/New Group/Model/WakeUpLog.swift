//
//  WakeUpLog.swift
//  Sleepio
//
//  Created by Douglas Labbe on 10/27/18.
//  Copyright © 2018 Oh Baby Consulting, LLC. All rights reserved.
//

import Foundation
import Firebase

struct WakeUpLog: Log {
    
    static let typeStr = "Wake-up"
    
    let type = WakeUpLog.typeStr
    var childId: String
    var childName: String
    var date: Date
    var wakeTime: Date
    var outOfBedTime: Date
    var notes: String
    
    var dictionary: [String: Any] {
        return [
            "childId": childId,
            "childName": childName,
            "date": date,
            "wakeTime": wakeTime,
            "outOfBedTime": outOfBedTime,
            "notes": notes,
            "type": type
        ]
    }
}

extension WakeUpLog: DocumentSerializable {
    
    init?(dictionary: [String : Any]) {
        guard let childId = dictionary["childId"] as? String,
            let childName = dictionary["childName"] as? String,
            let date = dictionary["date"] as? Timestamp,
            let wakeTime = dictionary["wakeTime"] as? Timestamp,
            let outOfBedTime = dictionary["outOfBedTime"] as? Timestamp,
            let notes = dictionary["notes"] as? String else { return nil }
        
        self.init(childId: childId, childName: childName, date: date.dateValue(), wakeTime: wakeTime.dateValue(), outOfBedTime: outOfBedTime.dateValue(), notes: notes)
    }
    
}
