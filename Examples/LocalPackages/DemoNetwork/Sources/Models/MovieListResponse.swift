//
//  MovieListResponse.swift
//  DemoNetwork
//
//  Created by Bahadir Sonmez on 15.12.2025.
//

import Foundation

public struct MovieListResponse: Codable {
    public let page: Int
    public let results: [Movie]
    public let totalPages: Int
    
    public init(page: Int, results: [Movie], totalPages: Int) {
        self.page = page
        self.results = results
        self.totalPages = totalPages
    }
}

