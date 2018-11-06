//
//  BedTimeLog.swift
//  Sleepio
//
//  Created by Douglas Labbe on 10/27/18.
//  Copyright © 2018 Oh Baby Consulting, LLC. All rights reserved.
//

import Foundation
import Firebase

struct BedtimeLog: Log {
    
    static let typeStr = "Bedtime"
    
    let type = BedtimeLog.typeStr
    var childId: String
    var childName: String
    var date: Date
    var startTime: Date
    var inBedTime: Date
    var asleepTime: Date
    var notes: String
    
    var dictionary: [String: Any] {
        return [
            "type": type,
            "childId": childId,
            "childName": childName,
            "date": date,
            "startTime": startTime,
            "inBedTime": inBedTime,
            "asleepTime": asleepTime,
            "notes": notes
        ]
    }
}

extension BedtimeLog: DocumentSerializable {
    
    init?(dictionary: [String : Any]) {
        guard
            let childId = dictionary["childId"] as? String,
            let childName = dictionary["childName"] as? String,
            let date = dictionary["date"] as? Timestamp,
            let startTime = dictionary["startTime"] as? Timestamp,
            let inBedTime = dictionary["inBedTime"] as? Timestamp,
            let asleepTime = dictionary["asleepTime"] as? Timestamp,
            let notes = dictionary["notes"] as? String else { return nil }
        
        self.init(childId: childId, childName: childName, date: date.dateValue(), startTime: startTime.dateValue(), inBedTime: inBedTime.dateValue(), asleepTime: asleepTime.dateValue(), notes: notes)
    }
}
