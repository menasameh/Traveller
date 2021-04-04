//
//  Date+Utils.swift
//  Traveller
//
//  Created by Mina Sameh on 2/4/21.
//

import Foundation

extension Date {
    func toString(format: String = "dd/MM/yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func toReadbleString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: self)
    }
    
    func add(days: Int) -> Date {
        let nextDate = Calendar.current.date(byAdding: .day, value: days, to: self)
        return nextDate ?? Date()
    }
    
    func isToday() -> Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    static func fromISO(string dateString: String) -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        // removing millis, as it's not supported by standered iso date formatter
        let trimmedIsoString = dateString.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)

        return dateFormatter.date(from: trimmedIsoString)
    }
}
