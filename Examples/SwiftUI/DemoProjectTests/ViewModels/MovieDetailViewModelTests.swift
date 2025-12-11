//
//  MovieDetailViewModelTests.swift
//  DemoProjectTests
//
//  Created by Bahadir Sonmez on 17.12.2025.
//

import XCTest
import BSSwiftUI
@testable import DemoProject
import DemoNetwork

@MainActor
final class MovieDetailViewModelTests: XCTestCase {
    
    private var sut: MovieDetailViewModel!
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Initial State Tests
    
    func testInitialState_isIdle() {
        // Given
        givenViewModel(with: Movie.mock())
        
        // Then
        XCTAssertEqual(sut.state, .idle)
    }
    
    // MARK: - View Did Load Tests
    
    func testViewDidLoad_loadsMovieDetails() {
        // Given
        givenViewModel(with: Movie.mock(
            id: 123,
            title: "Test Movie",
            overview: "Test overview",
            voteAverage: 8.5,
            originalLanguage: "en",
            originalTitle: "Original Title"
        ))
        
        // When
        whenViewDidLoad()
        
        // Then
        assertLoadedState { model in
            XCTAssertEqual(model.id, 123)
            XCTAssertEqual(model.title, "Test Movie")
            XCTAssertEqual(model.overview, "Test overview")
            XCTAssertEqual(model.originalTitle, "Original Title")
            XCTAssertEqual(model.originalLanguage, "en")
        }
    }
    
    func testViewDidLoad_withMinimalData_loadsCorrectly() {
        // Given
        givenViewModel(with: Movie.mock(
            id: 1,
            title: "Minimal Movie",
            overview: "",
            posterPath: nil,
            backdropPath: nil,
            releaseDate: nil,
            voteAverage: 0,
            originalLanguage: nil,
            originalTitle: nil
        ))
        
        // When
        whenViewDidLoad()
        
        // Then
        assertLoadedState { model in
            XCTAssertEqual(model.id, 1)
            XCTAssertEqual(model.title, "Minimal Movie")
            XCTAssertTrue(model.overview.isEmpty)
            XCTAssertNil(model.backdropURL)
            XCTAssertNil(model.originalTitle)
            XCTAssertNil(model.originalLanguage)
        }
    }
    
    // MARK: - Presentation Model Tests
    
    func testPresentationModel_formatsRatingCorrectly() {
        // Given
        givenViewModel(with: Movie.mock(voteAverage: 7.5))
        
        // When
        whenViewDidLoad()
        
        // Then
        assertLoadedState { model in
            XCTAssertNotNil(model.formattedRating)
        }
    }
    
    func testPresentationModel_formatsReleaseDateCorrectly() {
        // Given
        givenViewModel(with: Movie.mock(releaseDate: "2025-01-15"))
        
        // When
        whenViewDidLoad()
        
        // Then
        assertLoadedState { model in
            XCTAssertNotNil(model.formattedReleaseDate)
        }
    }
    
    func testPresentationModel_withZeroRating_returnsNilFormattedRating() {
        // Given
        givenViewModel(with: Movie.mock(voteAverage: 0))
        
        // When
        whenViewDidLoad()
        
        // Then
        assertLoadedState { model in
            XCTAssertNil(model.formattedRating)
        }
    }
    
    func testPresentationModel_withNilReleaseDate_returnsNilFormattedDate() {
        // Given
        givenViewModel(with: Movie.mock(releaseDate: nil))
        
        // When
        whenViewDidLoad()
        
        // Then
        assertLoadedState { model in
            XCTAssertNil(model.formattedReleaseDate)
        }
    }
    
    // MARK: - Given Helpers
    
    private func givenViewModel(with movie: Movie) {
        sut = MovieDetailViewModel(movie: movie, supporter: MovieDetailSupporter())
    }
    
    // MARK: - When Helpers
    
    private func whenViewDidLoad() {
        sut.trigger(.viewDidLoad)
    }
    
    // MARK: - Then Helpers
    
    private func assertLoadedState(_ assertions: (MovieDetailPresentationModel) -> Void) {
        if case .loaded(let model) = sut.state {
            assertions(model)
        } else {
            XCTFail("Expected loaded state, got \(sut.state)")
        }
    }
}
