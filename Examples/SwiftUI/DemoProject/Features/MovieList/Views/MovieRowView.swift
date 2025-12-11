//
//  MovieRowView.swift
//  DemoProject
//
//  Created by Bahadir Sonmez on 13.12.2025.
//

import SwiftUI
import BSSwiftUI
import DemoDesignSystem
import DemoNetwork

// MARK: - Presentation Model

struct MovieRowPresentationModel: Identifiable, Equatable {
    let id: Int
    let title: String
    let overview: String
    let posterURL: URL?
    let formattedRating: String?
    let formattedReleaseDate: String?
    
    init(movie: Movie) {
        self.id = movie.id
        self.title = movie.title
        self.overview = movie.overview
        self.posterURL = movie.posterURL
        self.formattedRating = movie.formattedRating
        self.formattedReleaseDate = movie.formattedReleaseDate
    }
}

// MARK: - View

struct MovieRowView: View {
    
    let model: MovieRowPresentationModel
    private let supporter = MovieListSupporter()
    
    var body: some View {
        HStack(alignment: .top, spacing: DSSpacing.sm) {
            posterImage
            movieInfo
            Spacer()
        }
        .cardStyle()
        .accessibilityElement(children: .combine)
        .accessibilityLabel(supporter.text(for: .movieRowLabel(
            title: model.title,
            rating: model.formattedRating,
            releaseDate: model.formattedReleaseDate
        )))
        .accessibilityHint(supporter.text(for: .movieRowHint))
    }
    
    private var posterImage: some View {
        CachedAsyncImage(url: model.posterURL) { image in
            image
                .resizable()
                .scaledToFill()
        }
        .posterStyle()
    }
    
    private var movieInfo: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            Text(model.title)
                .headlineStyle()
                .lineLimit(1)
            
            if let releaseDate = model.formattedReleaseDate {
                Text(releaseDate)
                    .secondaryStyle()
            }
            
            if let rating = model.formattedRating {
                StatItemView(
                    icon: "star.fill",
                    value: rating,
                    color: DSColor.rating,
                    accessibilityLabel: supporter.text(for: .ratingLabel(rating))
                )
            }
            
            Text(model.overview)
                .captionStyle()
                .lineLimit(3)
        }
        .padding(.vertical, DSSpacing.xs)
    }
}

// MARK: - Preview

#Preview {
    MovieRowView(model: PreviewMocks.movieRow)
        .padding()
}
