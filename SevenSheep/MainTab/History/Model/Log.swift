//
//  Log.swift
//  SevenSheep
//
//  Created by Douglas Labbe on 11/13/18.
//  Copyright © 2018 Oh Baby Consulting, LLC. All rights reserved.
//

import Foundation
import Firebase

protocol Log : DocumentSerializable {
    
    var type: String { get }
    var childId: String { get set }
    var childName: String { get set }
    var date:  Date { get set }
    var notes:  String { get set }
    var dictionary: [String: Any] { get }
}
