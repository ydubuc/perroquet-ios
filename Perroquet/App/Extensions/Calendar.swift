//
//  Calendar.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/29/24.
//

import Foundation

extension Calendar {
    static func endOfDayTimestamp() -> Int {
        let calendar = Calendar.current
        let now = Date()
        
        // Get the end of the current day
        let endOfDay = calendar.startOfDay(for: now).addingTimeInterval(24 * 60 * 60 - 1)
        
        // Convert the end of the day to a timestamp
        let timestamp = endOfDay.timeIntervalSince1970
        
        return timestamp.milliseconds
    }
    
    static func endOfDayTimestampAfterSevenDays() -> Int {
        let calendar = Calendar.current
        
        // Get the date 7 days from now
        if let endDate = calendar.date(byAdding: .day, value: 7, to: Date()) {
            // Get the end of the day for that date
            if let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: endDate) {
                // Convert the end of the day to a timestamp
                let timestamp = endOfDay.timeIntervalSince1970
                return timestamp.milliseconds
            }
        }
        
        return 0
    }
}
