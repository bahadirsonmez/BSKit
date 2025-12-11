//
//  MovieListSupporter.swift
//  DemoProject
//
//  Created by Bahadir Sonmez on 23.12.2025.
//

import Foundation
import BSUIKit
import DemoLocalization

// MARK: - Analytics Events

enum MovieListAnalyticsEvent {
    case screenViewed
    case movieSelected(id: Int)
}

struct MovieListSupporter: BaseSupporterProtocol {
    typealias TextKey = String
    typealias AnalyticsEvent = MovieListAnalyticsEvent
    
    var screenTitle: String {
        LocalizationHelper.string(for: "movieList.title")
    }
    
    func text(for key: String) -> String {
        LocalizationHelper.string(for: key)
    }
    
    func trackEvent(_ event: MovieListAnalyticsEvent) {
        #if DEBUG
        switch event {
        case .screenViewed:
            print("[Analytics] MovieList - Screen Viewed")
        case .movieSelected(let id):
            print("[Analytics] MovieList - Movie Selected: \(id)")
        }
        #endif
    }
}
