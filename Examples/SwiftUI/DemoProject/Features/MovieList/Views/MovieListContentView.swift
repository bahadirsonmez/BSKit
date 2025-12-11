//
//  MovieListContentView.swift
//  DemoProject
//
//  Created by Bahadir Sonmez on 21.12.2025.
//

import SwiftUI
import DemoDesignSystem

// MARK: - Movie List Content View

struct MovieListContentView<Model: Identifiable & Equatable>: View where Model.ID: Equatable {
    
    let movies: [Model]
    let hasMorePages: Bool
    let onMovieSelected: (Model) -> Void
    let onLoadMore: ((Model) -> Void)?
    let rowContent: (Model) -> MovieRowView
    
    init(
        movies: [Model],
        hasMorePages: Bool = false,
        onMovieSelected: @escaping (Model) -> Void,
        onLoadMore: ((Model) -> Void)? = nil,
        @ViewBuilder rowContent: @escaping (Model) -> MovieRowView
    ) {
        self.movies = movies
        self.hasMorePages = hasMorePages
        self.onMovieSelected = onMovieSelected
        self.onLoadMore = onLoadMore
        self.rowContent = rowContent
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: DSSpacing.md) {
                ForEach(movies) { movie in
                    movieButton(for: movie)
                }
                
                if hasMorePages {
                    ProgressView()
                        .padding()
                }
            }
            .padding()
        }
    }
    
    // MARK: - Private Views
    
    private func movieButton(for movie: Model) -> some View {
        Button {
            onMovieSelected(movie)
        } label: {
            rowContent(movie)
        }
        .buttonStyle(.plain)
        .onAppear {
            handleLoadMoreIfNeeded(for: movie)
        }
        .accessibilityElement(children: .combine)
    }
    
    private func handleLoadMoreIfNeeded(for movie: Model) {
        guard let onLoadMore = onLoadMore else { return }
        
        let thresholdIndex = movies.index(
            movies.endIndex,
            offsetBy: -5,
            limitedBy: movies.startIndex
        ) ?? movies.startIndex
        
        if let currentIndex = movies.firstIndex(where: { $0.id == movie.id }),
           currentIndex >= thresholdIndex {
            onLoadMore(movie)
        }
    }
}

// MARK: - Preview

#Preview {
    MovieListContentView(
        movies: PreviewMocks.movieRows,
        hasMorePages: true,
        onMovieSelected: { _ in },
        onLoadMore: { _ in },
        rowContent: { model in
            MovieRowView(model: model)
        }
    )
}
