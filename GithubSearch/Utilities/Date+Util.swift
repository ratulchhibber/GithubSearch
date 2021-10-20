//
//  Date+Util.swift
//  GithubSearch
//
//  Created by Ratul Chhibber on 20/10/21.
//

import Foundation

extension Date {
    
    func toString(with dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone.current
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
}
