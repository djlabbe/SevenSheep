//
//  User.swift
//  SevenSheep
//
//  Created by Douglas Labbe on 10/25/18.
//  Copyright © 2018 Oh Baby Consulting, LLC. All rights reserved.
//

import Foundation
import Firebase

struct User {
    var firstName: String
    var lastName: String
    var email: String
    
    var dictionary: [String: Any] {
  
        return [
            "firstName": firstName,
            "lastName": lastName,
            "email": email
        ]
    }
}

extension User: DocumentSerializable {
    
    init?(dictionary: [String : Any]) {
        guard let firstName = dictionary["firstName"] as? String,
            let lastName = dictionary["lastName"] as? String,
            let email = dictionary["email"] as? String else { return nil }
        
        self.init(firstName: firstName, lastName: lastName, email: email)
    }
    

}
