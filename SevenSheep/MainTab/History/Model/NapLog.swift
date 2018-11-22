//
//  NapLog.swift
//  SevenSheep
//
//  Created by Douglas Labbe on 11/13/18.
//  Copyright © 2018 Oh Baby Consulting, LLC. All rights reserved.
//

import Foundation
import Firebase

struct NapLog : Log  {
    
    static let napType = "Nap"
    
    let type = napType
    
    var childId: String
    var childName: String
    var date: Date
    var notes: String
    var inBedTime: Date
    var asleepTime:  Date
    var wakeTime: Date
    
    init (childId id: String, childName name:String, date:Date, inBedTime:Date, asleepTime:Date, wakeTime:Date, notes:String) {
        self.childId = id
        self.childName = name
        self.date = date
        self.notes = notes
        self.inBedTime = inBedTime
        self.asleepTime = asleepTime
        self.wakeTime = wakeTime
    }
    
    var dictionary: [String: Any] {
        
        return [
            "type": type,
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

extension NapLog: DocumentSerializable {
    
    init?(dictionary: [String : Any]) {
        guard let childId = dictionary["childId"] as? String,
            let childName = dictionary["childName"] as? String,
            let date = dictionary["date"] as? Timestamp,
            let notes = dictionary["notes"] as? String,
            let inBedTime = dictionary["inBedTime"] as? Timestamp,
            let asleepTime = dictionary["inBedTime"] as? Timestamp,
            let wakeTime = dictionary["wakeTime"] as? Timestamp
            else { return nil }
        
        
        self.init(childId: childId,
                  childName: childName,
                  date: date.dateValue(),
                  inBedTime: inBedTime.dateValue(),
                  asleepTime: asleepTime.dateValue(),
                  wakeTime: wakeTime.dateValue(),
                  notes: notes)
    }
}
