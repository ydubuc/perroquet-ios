//
//  String.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/28/24.
//

import Foundation
import SwiftUI

extension String {
    func attributed(highlight: String) -> AttributedString {
        var attributedString = AttributedString(self)

        if let range = attributedString.range(of: highlight) {
            attributedString[range].foregroundColor = .yellow
        }

        return attributedString
    }
    
    func findDates() -> [Date] {
        var dates: [Date] = []
        
        // Create NSDataDetector instance for date detection
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.date.rawValue)
        
        // Enumerate matches in the text
        detector.enumerateMatches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) { match, _, _ in
            if let date = match?.date {
                dates.append(date)
            }
        }
        
        // Detect relative timeframes like "in 15 minutes"
        let relativeDates = self.detectRelativeDates()
        dates.append(contentsOf: relativeDates)
        
        return dates
    }
    
    func detectRelativeDates() -> [Date] {
        var dates: [Date] = []
        
        // Regular expression pattern to match relative timeframes like "in 15 minutes"
        let pattern = "\\bin\\s+(\\d+)\\s+(m|mins|minutes?|h|hours?|d|days?|w|weeks?|mo|months?|y|years?)\\b"
        
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
            
            for match in matches {
                // Extract the quantity and unit of time from the match
                if let range = Range(match.range, in: self) {
                    let matchString = String(self[range])
                    let components = matchString.components(separatedBy: .whitespaces)
                    if components.count == 3, let quantity = Int(components[1]) {
                        let unit = components[2].singularized()
                        guard let dateComponent = unit.dateComponent else {
                            throw AppError("no date component")
                        }
                        if let date = Calendar.current.date(byAdding: dateComponent, value: quantity, to: Date()) {
                            dates.append(date)
                        }
                    }
                }
            }
        } catch {
            print("Error creating regular expression: \(error)")
        }
        
        return dates
    }
    
    var dateComponent: Calendar.Component? {
        switch self {
        case "m", "min", "mins", "minute", "minutes":
            return .minute
        case "h", "hour", "hours":
            return .hour
        case "d", "day", "days":
            return .day
        case "w", "week", "weeks":
            return .weekOfYear
        case "mo", "month", "months":
            return .month
        case "y", "year", "years":
            return .year
        default:
            return nil
        }
    }
    
    func singularized() -> String {
        if self.hasSuffix("s") {
            return String(self.dropLast())
        }
        return self
    }
}
