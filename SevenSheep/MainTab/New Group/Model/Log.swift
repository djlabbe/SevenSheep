//
//  Log.swift
//  Sleepio
//
//  Created by Douglas Labbe on 10/30/18.
//  Copyright © 2018 Oh Baby Consulting, LLC. All rights reserved.
//

import Foundation

protocol Log: DocumentSerializable {
    var childId: String {get}
    var childName: String {get}
    var date: Date {get}
    var notes: String {get}
    var type: String {get}
}
