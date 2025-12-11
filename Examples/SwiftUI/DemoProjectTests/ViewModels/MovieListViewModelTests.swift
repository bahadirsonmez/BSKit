//
//  MovieListViewModelTests.swift
//  DemoProjectTests
//
//  Created by Bahadir Sonmez on 17.12.2025.
//

import XCTest
import BSSwiftUI
@testable import DemoProject
import DemoNetwork

@MainActor
final class MovieListViewModelTests: XCTestCase {
    
    private var sut: MovieListViewModel!
    private var mockRepository: MockMovieRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockMovieRepository()
        sut = MovieListViewModel(repository: mockRepository, supporter: MovieListSupporter())
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    // MARK: - Initial State Tests
    
    func testInitialState_isIdle() {
        // Then
        XCTAssertEqual(sut.state, .idle)
    }
    
    // MARK: - Load Movies Tests
    
    func testViewDidLoad_loadsMovies() async {
        // Given
        givenSuccessfulLatestMovies(count: 3)
        
        // When
        await whenViewDidLoad()
        
        // Then
        assertLoadedState(movieCount: 3, hasMorePages: true)
        XCTAssertEqual(mockRepository.getLatestMoviesCallCount, 1)
        XCTAssertEqual(mockRepository.getLatestMoviesLastPage, 1)
    }
    
    func testViewDidLoad_withError_setsErrorState() async {
        // Given
        let error = NSError(domain: "Test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Network error"])
        mockRepository.latestMoviesResult = .failure(error)
        
        // When
        await whenViewDidLoad()
        
        // Then
        if case .error(let message) = sut.state {
            XCTAssertEqual(message, "Network error")
        } else {
            XCTFail("Expected error state, got \(sut.state)")
        }
    }
    
    // MARK: - Pagination Tests
    
    func testLoadMore_loadsNextPage() async {
        // Given
        givenSuccessfulLatestMovies(page: 1, count: 3)
        await whenViewDidLoad()
        givenSuccessfulLatestMovies(page: 2, movies: [Movie.mock(id: 10, title: "New Movie")])
        
        // When
        await whenLoadMore()
        
        // Then
        assertLoadedState(movieCount: 4)
        XCTAssertEqual(mockRepository.getLatestMoviesLastPage, 2)
    }
    
    func testLoadMore_whenNoMorePages_doesNotLoad() async {
        // Given
        givenSuccessfulLatestMovies(page: 1, totalPages: 1, count: 3)
        await whenViewDidLoad()
        let callCountBefore = mockRepository.getLatestMoviesCallCount
        
        // When
        await whenLoadMore()
        
        // Then
        XCTAssertEqual(mockRepository.getLatestMoviesCallCount, callCountBefore)
    }
    
    // MARK: - Refresh Tests
    
    func testRefresh_reloadsFromFirstPage() async {
        // Given
        givenSuccessfulLatestMovies(count: 3)
        await whenViewDidLoad()
        givenSuccessfulLatestMovies(movies: [Movie.mock(id: 100, title: "Refreshed Movie")])
        
        // When
        sut.trigger(.refresh)
        await waitForStateChange()
        
        // Then
        assertLoadedState(movieCount: 1)
        if case .loaded(let model) = sut.state {
            XCTAssertEqual(model.movies.first?.title, "Refreshed Movie")
        }
        XCTAssertEqual(mockRepository.getLatestMoviesLastPage, 1)
        XCTAssertEqual(mockRepository.getLatestMoviesLastForceRefresh, true)
    }
    
    // MARK: - Search Tests
    
    func testSearch_performsSearchWithQuery() async {
        // Given
        givenSuccessfulSearch(movies: [Movie.mock(id: 50, title: "Search Result")])
        
        // When
        await whenSearch("test query")
        
        // Then
        if case .searchResults(let model) = sut.state {
            XCTAssertEqual(model.movies.count, 1)
            XCTAssertEqual(model.query, "test query")
        } else {
            XCTFail("Expected searchResults state, got \(sut.state)")
        }
        XCTAssertEqual(mockRepository.searchMoviesLastQuery, "test query")
    }
    
    func testSearch_withEmptyResults_showsNoResults() async {
        // Given
        mockRepository.searchMoviesResult = .success(MovieListResponse.emptyMock())
        
        // When
        await whenSearch("nonexistent")
        
        // Then
        if case .noSearchResults(let query) = sut.state {
            XCTAssertEqual(query, "nonexistent")
        } else {
            XCTFail("Expected noSearchResults state, got \(sut.state)")
        }
    }
    
    func testSearch_clearingSearch_restoresMovieList() async {
        // Given
        givenSuccessfulLatestMovies(count: 3)
        await whenViewDidLoad()
        givenSuccessfulSearch(movies: [Movie.mock(id: 50)])
        await whenSearch("test")
        
        // When
        sut.searchText = ""
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        assertLoadedState(movieCount: 3)
    }
    
    // MARK: - Movie Lookup Tests
    
    func testMovieForId_returnsCorrectMovie() async {
        // Given
        givenSuccessfulLatestMovies(count: 3)
        await whenViewDidLoad()
        
        // When
        let movie = sut.movie(for: 2)
        
        // Then
        XCTAssertNotNil(movie)
        XCTAssertEqual(movie?.id, 2)
    }
    
    func testMovieForId_returnsNilForNonexistentId() async {
        // Given
        givenSuccessfulLatestMovies(count: 3)
        await whenViewDidLoad()
        
        // When
        let movie = sut.movie(for: 999)
        
        // Then
        XCTAssertNil(movie)
    }
    
    // MARK: - Given Helpers
    
    private func givenSuccessfulLatestMovies(page: Int = 1, totalPages: Int = 10, count: Int) {
        let response = MovieListResponse.mock(page: page, totalPages: totalPages, results: Movie.mockList(count: count))
        mockRepository.latestMoviesResult = .success(response)
    }
    
    private func givenSuccessfulLatestMovies(page: Int = 1, totalPages: Int = 10, movies: [Movie]) {
        let response = MovieListResponse.mock(page: page, totalPages: totalPages, results: movies)
        mockRepository.latestMoviesResult = .success(response)
    }
    
    private func givenSuccessfulSearch(movies: [Movie]) {
        mockRepository.searchMoviesResult = .success(MovieListResponse.mock(results: movies))
    }
    
    // MARK: - When Helpers
    
    private func whenViewDidLoad() async {
        sut.trigger(.viewDidLoad)
        await waitForStateChange()
    }
    
    private func whenLoadMore() async {
        sut.trigger(.loadMore)
        await waitForStateChange()
    }
    
    private func whenSearch(_ query: String) async {
        sut.searchText = query
        try? await Task.sleep(nanoseconds: 400_000_000)
    }
    
    private func waitForStateChange() async {
        try? await Task.sleep(nanoseconds: 100_000_000)
    }
    
    // MARK: - Then Helpers
    
    private func assertLoadedState(movieCount: Int, hasMorePages: Bool? = nil) {
        if case .loaded(let model) = sut.state {
            XCTAssertEqual(model.movies.count, movieCount)
            if let hasMorePages = hasMorePages {
                XCTAssertEqual(model.hasMorePages, hasMorePages)
            }
        } else {
            XCTFail("Expected loaded state, got \(sut.state)")
        }
    }
}
