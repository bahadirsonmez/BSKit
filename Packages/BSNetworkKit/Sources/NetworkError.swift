//
//  NetworkError.swift
//  BSNetworkKit
//
//  Created by Bahadir Sonmez on 11.12.2025.
//

import Foundation

public enum NetworkError: LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case serverError(statusCode: Int)
    case unknown(Error)
    case maxRetriesExceeded(lastError: Error)
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received from the server"
        case .decodingError:
            return "Failed to decode the response"
        case .serverError(let statusCode):
            return "Server error with status code: \(statusCode)"
        case .unknown(let error):
            return error.localizedDescription
        case .maxRetriesExceeded(let lastError):
            return "Max retries exceeded. Last error: \(lastError.localizedDescription)"
        }
    }
    
    public func isRetryable(with retryableStatusCodes: Set<Int>) -> Bool {
        switch self {
        case .invalidURL, .decodingError:
            return false
        case .noData:
            return true
        case .serverError(let statusCode):
            return retryableStatusCodes.contains(statusCode)
        case .unknown:
            return true
        case .maxRetriesExceeded:
            return false
        }
    }
}
