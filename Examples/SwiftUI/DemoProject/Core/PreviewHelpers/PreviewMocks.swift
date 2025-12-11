//
//  PreviewMocks.swift
//  DemoProject
//
//  Created by Bahadir Sonmez on 21.12.2025.
//

import Foundation
import DemoNetwork

// MARK: - Preview Mocks

enum PreviewMocks {
    
    // MARK: - Movies
    
    static var movie: Movie {
        Movie(
            id: 1,
            title: "The Dark Knight",
            overview: "When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.",
            posterPath: "/qJ2tW6WMUDux911r6m7haRef0WH.jpg",
            backdropPath: "/nMKdUUepR0i5zn0y1T4CsSB5chy.jpg",
            releaseDate: "2008-07-16",
            voteAverage: 8.5,
            originalLanguage: "en",
            originalTitle: "The Dark Knight"
        )
    }
    
    static var movies: [Movie] {
        [
            movie,
            Movie(
                id: 2,
                title: "Inception",
                overview: "A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O.",
                posterPath: "/9gk7adHYeDvHkCSEqAvQNLV5Ber.jpg",
                backdropPath: "/s3TBrRGB1iav7gFOCNx3H31MoES.jpg",
                releaseDate: "2010-07-15",
                voteAverage: 8.4,
                originalLanguage: "en",
                originalTitle: "Inception"
            ),
            Movie(
                id: 3,
                title: "Interstellar",
                overview: "A team of explorers travel through a wormhole in space in an attempt to ensure humanity's survival.",
                posterPath: "/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg",
                backdropPath: "/xJHokMbljvjADYdit5fK5VQsXEG.jpg",
                releaseDate: "2014-11-05",
                voteAverage: 8.4,
                originalLanguage: "en",
                originalTitle: "Interstellar"
            )
        ]
    }
    
    // MARK: - Presentation Models
    
    static var movieRow: MovieRowPresentationModel {
        MovieRowPresentationModel(movie: movie)
    }
    
    static var movieRows: [MovieRowPresentationModel] {
        movies.map { MovieRowPresentationModel(movie: $0) }
    }
    
    static var movieDetail: MovieDetailPresentationModel {
        MovieDetailPresentationModel(movie: movie)
    }
}
