//
//  MovieEndpoint.swift
//  DemoNetwork
//
//  Created by Bahadir Sonmez on 15.12.2025.
//

import Foundation
import BSNetworkKit

public enum MovieEndpoint: Endpoint {
    case latest(page: Int, forceRefresh: Bool = false)
    case search(query: String, page: Int)
    
    public var baseURL: String {
        TMDBConfiguration.baseURL
    }
    
    public var path: String {
        switch self {
        case .latest:
            return "/movie/now_playing"
        case .search:
            return "/search/movie"
        }
    }
    
    public var method: HTTPMethod {
        .get
    }
    
    public var headers: [String: String]? {
        [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(TMDBConfiguration.apiKey)"
        ]
    }
    
    public var parameters: MovieParameters? {
        switch self {
        case .latest(let page, _):
            return MovieParameters(page: page)
        case .search(let query, let page):
            return MovieParameters(page: page, query: query)
        }
    }
    
    public var urlCachePolicy: URLRequest.CachePolicy {
        switch self {
        case .latest(_, let forceRefresh):
            return forceRefresh ? .reloadIgnoringLocalCacheData : .reloadRevalidatingCacheData
        case .search:
            return .reloadRevalidatingCacheData
        }
    }
}

public struct MovieParameters: Encodable {
    public let page: Int?
    public let query: String?
    public let language: String?
    
    public init(page: Int? = nil, query: String? = nil, language: String? = Locale.current.language.languageCode?.identifier) {
        self.page = page
        self.query = query
        self.language = language
    }
}
