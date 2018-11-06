//
//  NapLog.swift
//  Sleepio
//
//  Created by Douglas Labbe on 10/27/18.
//  Copyright © 2018 Oh Baby Consulting, LLC. All rights reserved.
//

import Foundation
import Firebase

struct NapLog: Log {
    
    static let typeStr = "Nap"
    
    let type = NapLog.typeStr
    var childId: String
    var childName: String
    var date: Date
    var inBedTime: Date
    var asleepTime: Date
    var wakeTime: Date
    var notes: String
    
    var dictionary: [String: Any] {
        return [
            "type": type,
            "childId": childId,
            "childName": childName,
            "date": date,
            "inBedTime": inBedTime,
            "asleepTime": asleepTime,
            "wakeTime": wakeTime,
            "notes": notes
        ]
    }
}

extension NapLog: DocumentSerializable {
    
    init?(dictionary: [String : Any]) {
        guard
            let childId = dictionary["childId"] as? String,
            let childName = dictionary["childName"] as? String,
            let date = dictionary["date"] as? Timestamp,
            let inBedTime = dictionary["inBedTime"] as? Timestamp,
            let asleepTime = dictionary["asleepTime"] as? Timestamp,
            let wakeTime = dictionary["wakeTime"] as? Timestamp,
            let notes = dictionary["notes"] as? String else { return nil }
        
        self.init(childId: childId, childName: childName, date: date.dateValue(), inBedTime: inBedTime.dateValue(), asleepTime: asleepTime.dateValue(), wakeTime: wakeTime.dateValue(), notes: notes)
    }
}
