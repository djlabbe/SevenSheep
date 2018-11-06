//
//  StringToDate.swift
//  SevenSheep
//
//  Created by Douglas Labbe on 10/26/18.
//  Copyright © 2018 Oh Baby Consulting, LLC. All rights reserved.
//

import Foundation

extension String {
    func toDate(forLocale localeId: String, withDateStyle dateStyle: DateFormatter.Style, withTimeStyle timeStyle: DateFormatter.Style) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: localeId)
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        return dateFormatter.date(from: self)
    }
    
    func toUSDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter.date(from: self)
    }
}

extension Date {
    func toFormattedString(forLocale localeId: String, withDateStyle dateStyle: DateFormatter.Style, withTimeStyle timeStyle: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: localeId)
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        return dateFormatter.string(from: self)
    }
    
    func toShortUSTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }
    
    func toUSDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: self)
    }
}


