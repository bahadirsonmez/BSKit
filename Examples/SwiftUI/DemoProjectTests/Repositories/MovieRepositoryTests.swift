//
//  MovieRepositoryTests.swift
//  DemoProjectTests
//
//  Created by Bahadir Sonmez on 17.12.2025.
//

import XCTest
@testable import DemoProject
import BSNetworkKit
import DemoNetwork

final class MovieRepositoryTests: XCTestCase {
    
    private var sut: MovieRepository!
    private var mockNetworkClient: MockNetworkClient!
    
    override func setUp() {
        super.setUp()
        mockNetworkClient = MockNetworkClient()
        sut = MovieRepository(networkClient: mockNetworkClient)
    }
    
    override func tearDown() {
        sut = nil
        mockNetworkClient = nil
        super.tearDown()
    }
    
    // MARK: - Get Latest Movies Tests
    
    func testGetLatestMovies_success_returnsMovieListResponse() async throws {
        // Given
        givenSuccessfulLatestMoviesResponse(count: 5)
        
        // When
        let result = try await sut.getLatestMovies(page: 1, forceRefresh: false)
        
        // Then
        assertMovieListResponse(result, expectedCount: 5, expectedPage: 1)
        assertNetworkCallCount(1)
    }
    
    func testGetLatestMovies_withDifferentPages_callsCorrectly() async throws {
        // Given
        givenSuccessfulLatestMoviesResponse(page: 1, count: 3)
        
        // When
        let result1 = try await sut.getLatestMovies(page: 1, forceRefresh: false)
        
        // Then
        XCTAssertEqual(result1.page, 1)
        
        // Given
        givenSuccessfulLatestMoviesResponse(page: 2, count: 3)
        
        // When
        let result2 = try await sut.getLatestMovies(page: 2, forceRefresh: false)
        
        // Then
        XCTAssertEqual(result2.page, 2)
        assertNetworkCallCount(2)
    }
    
    func testGetLatestMovies_networkError_throwsError() async {
        // Given
        givenNetworkError("No internet")
        
        // When / Then
        await assertThrowsError(message: "No internet") {
            _ = try await sut.getLatestMovies(page: 1, forceRefresh: false)
        }
    }
    
    // MARK: - Search Movies Tests
    
    func testSearchMovies_success_returnsSearchResults() async throws {
        // Given
        let response = MovieListResponse.mock(results: [Movie.mock(id: 100, title: "Search Result")])
        mockNetworkClient.requestResult = .success(response)
        
        // When
        let result = try await sut.searchMovies(query: "test", page: 1)
        
        // Then
        assertMovieListResponse(result, expectedCount: 1)
        XCTAssertEqual(result.results.first?.title, "Search Result")
        assertNetworkCallCount(1)
    }
    
    func testSearchMovies_emptyResults_returnsEmptyList() async throws {
        // Given
        mockNetworkClient.requestResult = .success(MovieListResponse.emptyMock())
        
        // When
        let result = try await sut.searchMovies(query: "nonexistent", page: 1)
        
        // Then
        XCTAssertTrue(result.results.isEmpty)
    }
    
    func testSearchMovies_networkError_throwsError() async {
        // Given
        givenNetworkError("Request failed")
        
        // When / Then
        await assertThrowsError(message: "Request failed") {
            _ = try await sut.searchMovies(query: "test", page: 1)
        }
    }
    
    // MARK: - Given Helpers
    
    private func givenSuccessfulLatestMoviesResponse(page: Int = 1, count: Int) {
        let response = MovieListResponse.mock(page: page, results: Movie.mockList(count: count))
        mockNetworkClient.requestResult = .success(response)
    }
    
    private func givenNetworkError(_ message: String) {
        let error = NSError(domain: "Network", code: -1, userInfo: [NSLocalizedDescriptionKey: message])
        mockNetworkClient.requestResult = .failure(error)
    }
    
    // MARK: - Then Helpers
    
    private func assertMovieListResponse(_ response: MovieListResponse, expectedCount: Int, expectedPage: Int? = nil) {
        XCTAssertEqual(response.results.count, expectedCount)
        if let expectedPage = expectedPage {
            XCTAssertEqual(response.page, expectedPage)
        }
    }
    
    private func assertNetworkCallCount(_ count: Int) {
        XCTAssertEqual(mockNetworkClient.requestCallCount, count)
    }
    
    private func assertThrowsError(message: String, _ operation: () async throws -> Void) async {
        do {
            try await operation()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual((error as NSError).localizedDescription, message)
        }
    }
}
