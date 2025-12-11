//
//  MovieListSupporter.swift
//  DemoProject
//
//  Created by Bahadir Sonmez on 13.12.2025.
//

import Foundation
import BSSwiftUI
import DemoLocalization

// MARK: - Text Keys

enum MovieListTextKey {
    case title
    case searchPlaceholder
    case noResults
    case noResultsMessage(String)
    case retry
    
    // Accessibility
    case movieRowHint
    case movieRowLabel(title: String, rating: String?, releaseDate: String?)
    case noResultsAccessibilityLabel(String)
    case ratingLabel(String)
}

// MARK: - Analytics Events

enum MovieListAnalyticsEvent {
    case screenViewed
    case movieSelected(id: Int)
}

// MARK: - Supporter

struct MovieListSupporter: BaseSupporterProtocol {
    
    typealias TextKey = MovieListTextKey
    typealias AnalyticsEvent = MovieListAnalyticsEvent
    
    var screenTitle: String {
        text(for: .title)
    }
    
    func text(for key: MovieListTextKey) -> String {
        switch key {
        case .title:
            return LocalizationHelper.string(for: "movieList.title")
        case .searchPlaceholder:
            return LocalizationHelper.string(for: "movieList.searchPlaceholder")
        case .noResults:
            return LocalizationHelper.string(for: "movieList.noResults")
        case .noResultsMessage(let query):
            return LocalizationHelper.string(for: "movieList.noResultsMessage", query)
        case .retry:
            return LocalizationHelper.string(for: "movieList.retry")
            
        // Accessibility
        case .movieRowHint:
            return LocalizationHelper.string(for: "accessibility.movieRow.hint")
        case .movieRowLabel(let title, let rating, let releaseDate):
            return LocalizationHelper.string(for: "accessibility.movieRow.label", title, rating ?? "", releaseDate ?? "")
        case .noResultsAccessibilityLabel(let query):
            return LocalizationHelper.string(for: "movieList.accessibility.noResults", query)
        case .ratingLabel(let rating):
            return LocalizationHelper.string(for: "movieList.accessibility.ratingLabel", rating)
        }
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
