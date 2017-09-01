//
//  NSDateISO8601.swift
//
//  Created by Justin Makaila on 8/11/14.
//  Copyright (c) 2014 Present, Inc. All rights reserved.
//

import Foundation
import MapKit

extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
}
extension Date {
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
}

extension String {
    var dateFromISO8601: Date? {
        return Formatter.iso8601.date(from: self)
    }
}

public extension Date {
    public static func ISOStringFromDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        return dateFormatter.string(from: date) + "Z"
    }
    
    public static func dateFromISOString(_ string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        return dateFormatter.date(from: string)!
    }
    
    public static func offsetFrom(_ date: Date) -> String {
        
        let yearmonthdayHourMinuteSecond: NSCalendar.Unit = [.year, .month, .day, .hour, .minute, .second]
        let difference = (Calendar.current as NSCalendar).components(yearmonthdayHourMinuteSecond, from: date, to: Date(), options: [])
        
        let seconds = "\(difference.second!)s"
        let minutes = "\(difference.minute!)m" + " " + seconds
        let hours = "\(difference.hour!)h" + " " + minutes
        let days = "\(difference.day!)d" + " " + hours
        let months = "\(difference.month!)M" + " " + days
        let years = "\(difference.year!)Y" + " " + months
        
        if difference.year!		> 0 { return years }
        if difference.month!		> 0 { return months }
        if difference.day!			> 0 { return days }
        if difference.hour!		> 0 { return hours }
        if difference.minute!	> 0 { return minutes }
        if difference.second!	> 0 { return seconds }
        return ""
    }
}
