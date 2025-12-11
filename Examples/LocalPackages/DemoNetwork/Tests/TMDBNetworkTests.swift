//
//  TMDBNetworkTests.swift
//  DemoNetwork
//
//  Created by Bahadir Sonmez on 15.12.2025.
//

import XCTest
@testable import DemoNetwork

final class TMDBNetworkTests: XCTestCase {
    
    func testMovieEndpointLatest() {
        let endpoint = MovieEndpoint.latest(page: 1)
        XCTAssertEqual(endpoint.path, "/movie/now_playing")
        XCTAssertEqual(endpoint.method, .get)
    }
    
    func testMovieEndpointSearch() {
        let endpoint = MovieEndpoint.search(query: "test", page: 1)
        XCTAssertEqual(endpoint.path, "/search/movie")
    }
}
