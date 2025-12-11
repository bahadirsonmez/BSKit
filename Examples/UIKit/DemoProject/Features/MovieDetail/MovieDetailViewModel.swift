//
//  MovieDetailViewModel.swift
//  DemoProject
//
//  Created by Bahadir Sonmez on 23.12.2025.
//

import Foundation
import BSUIKit
import DemoNetwork

// MARK: - Input

enum MovieDetailInput {
    case viewDidLoad
}

// MARK: - View State

enum MovieDetailViewState: Equatable {
    case idle
}

// MARK: - ViewModel

@MainActor
final class MovieDetailViewModel: BaseViewModel<MovieDetailInput, MovieDetailViewState, MovieDetailSupporter> {
    
    let movie: Movie
    
    init(movie: Movie, supporter: MovieDetailSupporter) {
        self.movie = movie
        super.init(initialState: .idle, supporter: supporter)
    }
    
    override func trigger(_ input: MovieDetailInput) {
        switch input {
        case .viewDidLoad:
            trackEvent(.screenViewed(movieId: movie.id))
        }
    }
}
