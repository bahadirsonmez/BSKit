//
//  MovieDetailViewModel.swift
//  DemoProject
//
//  Created by Bahadir Sonmez on 13.12.2025.
//

import Foundation
import BSSwiftUI
import DemoNetwork

// MARK: - Input

enum MovieDetailInput {
    case viewDidLoad
}

// MARK: - View State

enum MovieDetailViewState: Equatable {
    case idle
    case loaded(MovieDetailPresentationModel)
}

// MARK: - Presentation Model

struct MovieDetailPresentationModel: Equatable {
    let id: Int
    let title: String
    let overview: String
    let backdropURL: URL?
    let formattedRating: String?
    let formattedReleaseDate: String?
    let originalTitle: String?
    let originalLanguage: String?
    
    init(movie: Movie) {
        self.id = movie.id
        self.title = movie.title
        self.overview = movie.overview
        self.backdropURL = movie.backdropURL
        self.formattedRating = movie.formattedRating
        self.formattedReleaseDate = movie.formattedReleaseDate
        self.originalTitle = movie.originalTitle
        self.originalLanguage = movie.originalLanguage
    }
}

// MARK: - ViewModel

@MainActor
final class MovieDetailViewModel: BaseViewModel<MovieDetailInput, MovieDetailViewState, MovieDetailSupporter> {
    
    private let movie: Movie
    
    init(movie: Movie, supporter: MovieDetailSupporter) {
        self.movie = movie
        super.init(initialState: .idle, supporter: supporter)
    }
    
    override func trigger(_ input: MovieDetailInput) {
        switch input {
        case .viewDidLoad:
            state = .loaded(MovieDetailPresentationModel(movie: movie))
        }
    }
}
