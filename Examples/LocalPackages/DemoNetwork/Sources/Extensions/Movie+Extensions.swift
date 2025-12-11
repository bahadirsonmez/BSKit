//
//  Movie+Extensions.swift
//  DemoProject
//
//  Created by Bahadir Sonmez on 13.12.2025.
//

import Foundation

public extension Movie {
    var posterURL: URL? {
        TMDBConfiguration.imageURL(path: posterPath, size: .poster(.w500))
    }
    
    var backdropURL: URL? {
        TMDBConfiguration.imageURL(path: backdropPath, size: .backdrop(.w780))
    }
    
    var formattedReleaseDate: String? {
        guard let releaseDate = releaseDate, !releaseDate.isEmpty,
              let date = DateFormatter.tmdbDateFormatter.date(from: releaseDate) else {
            return nil
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    var formattedRating: String? {
        guard let voteAverage = voteAverage, voteAverage > 0 else { return nil }
        return String(format: "%.1f", voteAverage)
    }
}
