//
//  MovieDetailSupporter.swift
//  DemoProject
//
//  Created by Bahadir Sonmez on 23.12.2025.
//

import Foundation
import BSUIKit
import DemoLocalization

// MARK: - Analytics Events

enum MovieDetailAnalyticsEvent {
    case screenViewed(movieId: Int)
}

struct MovieDetailSupporter: BaseSupporterProtocol {
    typealias TextKey = String
    typealias AnalyticsEvent = MovieDetailAnalyticsEvent
    
    var screenTitle: String {
        "" // Will be overridden by title in ViewController or set dynamically
    }
    
    func text(for key: String) -> String {
        LocalizationHelper.string(for: key)
    }
    
    func trackEvent(_ event: MovieDetailAnalyticsEvent) {
        #if DEBUG
        switch event {
        case .screenViewed(let movieId):
            print("[Analytics] MovieDetail - Screen Viewed: \(movieId)")
        }
        #endif
    }
}
