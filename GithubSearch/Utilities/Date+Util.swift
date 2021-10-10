//
//  Date+Util.swift
//  GithubSearch
//
//  Created by Shruti Chhibber on 10/10/21.
//

import Foundation

extension Date {
    
    static func stringFrom(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        dateFormatter.timeZone = TimeZone.current
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    static func dateFrom(dateString: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: dateString) else {
            return nil
        }
        return date
    }
}
