//
//  BedtimeLog.swift
//  SevenSheep
//
//  Created by Douglas Labbe on 11/13/18.
//  Copyright © 2018 Oh Baby Consulting, LLC. All rights reserved.
//

import Foundation
import Firebase

struct BedtimeLog : Log {

    static let bedTimeType = "Bedtime"
    
    let type = bedTimeType
    
    var childId: String
    var childName: String
    var date: Date
    var notes: String
    var startTime: Date
    var inBedTime:  Date
    var asleepTime: Date
    
    init (childId id: String, childName name:String, date:Date, startTime:Date, inBedTime:Date, asleepTime: Date, notes:String) {
        
        self.childId = id
        self.childName = name
        self.date = date
        self.notes = notes
        self.startTime = startTime
        self.inBedTime = inBedTime
        self.asleepTime = asleepTime
    }
    
    var dictionary: [String: Any] {
        
        return [
            "type": type,
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

extension BedtimeLog: DocumentSerializable {
    
    init?(dictionary: [String : Any]) {
        guard let childId = dictionary["childId"] as? String,
            let childName = dictionary["childName"] as? String,
            let date = dictionary["date"] as? Timestamp,
            let notes = dictionary["notes"] as? String,
            let startTime = dictionary["startTime"] as? Timestamp,
            let inBedTime = dictionary["inBedTime"] as? Timestamp,
            let asleepTime = dictionary["asleepTime"] as? Timestamp
            else { return nil }
        
        
        self.init(childId: childId,
                  childName: childName,
                  date: date.dateValue(),
                  startTime: startTime.dateValue(),
                  inBedTime: inBedTime.dateValue(),
                  asleepTime: asleepTime.dateValue(),
                  notes: notes)
    }
}
