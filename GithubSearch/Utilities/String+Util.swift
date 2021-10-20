//
//  File.swift
//  GithubSearch
//
//  Created by Ratul Chhibber on 20/10/21.
//

import Foundation

extension String {
    
    var toDate: Date? {
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: self) else {
            return nil
        }
        return date
    }
}
