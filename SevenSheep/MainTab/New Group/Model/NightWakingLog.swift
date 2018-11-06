//
//  NightWakingLog.swift
//  Sleepio
//
//  Created by Douglas Labbe on 10/27/18.
//  Copyright © 2018 Oh Baby Consulting, LLC. All rights reserved.
//

import Foundation
import Firebase

// TODO: Consider replacing asleep time with a duration selector combobox widget

struct NightWakingLog: Log {
    
    static let typeStr = "Night Waking"
    
    let type = NightWakingLog.typeStr
    var childId: String
    var childName: String
    var date: Date
    var wakeTime: Date
    var asleepTime: Date
    var notes: String
    
    var dictionary: [String: Any] {
        return [
            "type": type,
            "childId": childId,
            "childName": childName,
            "date": date,
            "wakeTime": wakeTime,
            "asleepTime": asleepTime,
            "notes": notes
        ]
    }
}

extension NightWakingLog: DocumentSerializable {
    
    init?(dictionary: [String : Any]) {
        guard
            let childId = dictionary["childId"] as? String,
            let childName = dictionary["childName"] as? String,
            let date = dictionary["date"] as? Timestamp,
            let wakeTime = dictionary["wakeTime"] as? Timestamp,
            let asleepTime = dictionary["asleepTime"] as? Timestamp,
            let notes = dictionary["notes"] as? String else { return nil }
        
        self.init(childId: childId, childName: childName, date: date.dateValue(), wakeTime: wakeTime.dateValue(), asleepTime: asleepTime.dateValue(), notes: notes)
    }
}
