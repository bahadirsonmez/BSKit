//
//  MovieListResponse+Extensions.swift
//  DemoProject
//
//  Created by Bahadir Sonmez on 15.12.2025.
//

import Foundation

public extension MovieListResponse {
    var hasMorePages: Bool {
        page < totalPages
    }
}
