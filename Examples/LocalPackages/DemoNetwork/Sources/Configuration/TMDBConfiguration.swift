//
//  TMDBConfiguration.swift
//  DemoNetwork
//
//  Created by Bahadir Sonmez on 15.12.2025.
//

import Foundation

public enum TMDBConfiguration {
    public static let baseURL = "https://api.themoviedb.org/3"
    public static let imageBaseURL = "https://image.tmdb.org/t/p"
    public static var apiKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "TMDB_API_KEY") as? String,
              !key.isEmpty else {
            fatalError("TMDB_API_KEY not found in Info.plist. Please ensure Secrets.xcconfig is properly configured.")
        }
        return key
    }
    
    public enum ImageSize {
        case poster(PosterSize)
        case backdrop(BackdropSize)
        
        public var path: String {
            switch self {
            case .poster(let size): return size.rawValue
            case .backdrop(let size): return size.rawValue
            }
        }
    }
    
    public enum PosterSize: String {
        case w500
    }
    
    public enum BackdropSize: String {
        case w780
    }
    
    public static func imageURL(path: String?, size: ImageSize) -> URL? {
        guard let path = path else { return nil }
        return URL(string: "\(imageBaseURL)/\(size.path)\(path)")
    }
}
