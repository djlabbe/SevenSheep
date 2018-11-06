//
//  Child.swift
//  Sleepio
//
//  Created by Douglas Labbe on 10/27/18.
//  Copyright © 2018 Oh Baby Consulting, LLC. All rights reserved.
//

import Foundation
import Firebase

struct Child {
    var name: String
    var dob: Date
    var gender: String
    var parents: [String]
    
    var dictionary: [String: Any] {
        return [
            "name": name,
            "dob": dob,
            "gender": gender,
            "parents": parents
        ]
    }
}

extension Child: DocumentSerializable {
    
    init?(dictionary: [String : Any]) {
        guard let name = dictionary["name"] as? String,
            let dob = dictionary["dob"] as? Timestamp,
            let gender = dictionary["gender"] as? String,
            let parents = dictionary["parents"] as? [String] else { return nil }
        
        
        self.init(name: name, dob: dob.dateValue(), gender: gender, parents: parents)
    }
    
}
