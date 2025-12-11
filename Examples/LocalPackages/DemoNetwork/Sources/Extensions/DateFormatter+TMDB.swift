//
//  DateFormatter+TMDB.swift
//  DemoNetwork
//
//  Created by Bahadir Sonmez on 15.12.2025.
//

import Foundation

public extension DateFormatter {
    
    static var tmdbDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }
}
