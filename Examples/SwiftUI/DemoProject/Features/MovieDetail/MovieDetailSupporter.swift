//
//  MovieDetailSupporter.swift
//  DemoProject
//
//  Created by Bahadir Sonmez on 13.12.2025.
//

import Foundation
import BSSwiftUI
import DemoLocalization

// MARK: - Text Keys

enum MovieDetailTextKey {
    case overview
    case information
    case status
    case originalTitle
    case originalLanguage
    case budget
    case revenue
    case retry
    
    // Accessibility
    case backdropImageLabel(String)
    case ratingLabel(String)
    case releaseDateLabel(String)
}

// MARK: - Analytics Events

enum MovieDetailAnalyticsEvent {
    case screenViewed(movieId: Int)
}

// MARK: - Supporter

struct MovieDetailSupporter: BaseSupporterProtocol {
    
    typealias TextKey = MovieDetailTextKey
    typealias AnalyticsEvent = MovieDetailAnalyticsEvent
    
    var screenTitle: String {
        ""
    }
    
    func text(for key: MovieDetailTextKey) -> String {
        switch key {
        case .overview:
            return LocalizationHelper.string(for: "movieDetail.overview")
        case .information:
            return LocalizationHelper.string(for: "movieDetail.information")
        case .status:
            return LocalizationHelper.string(for: "movieDetail.status")
        case .originalTitle:
            return LocalizationHelper.string(for: "movieDetail.originalTitle")
        case .originalLanguage:
            return LocalizationHelper.string(for: "movieDetail.originalLanguage")
        case .budget:
            return LocalizationHelper.string(for: "movieDetail.budget")
        case .revenue:
            return LocalizationHelper.string(for: "movieDetail.revenue")
        case .retry:
            return LocalizationHelper.string(for: "movieDetail.retry")
            
        // Accessibility
        case .backdropImageLabel(let title):
            return LocalizationHelper.string(for: "movieDetail.accessibility.backdropImage", title)
        case .ratingLabel(let rating):
            return LocalizationHelper.string(for: "movieDetail.accessibility.rating", rating)
        case .releaseDateLabel(let date):
            return LocalizationHelper.string(for: "movieDetail.accessibility.releaseDate", date)
        }
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
