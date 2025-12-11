//
//  RetryPolicy.swift
//  BSNetworkKit
//
//  Created by Bahadir Sonmez on 20.12.2025.
//

import Foundation

// MARK: - Retry Policy

public struct RetryPolicy: Sendable {
    public let maxRetries: Int
    public let baseDelay: TimeInterval
    public let strategy: RetryStrategy
    public let retryableStatusCodes: Set<Int>
    
    public init(
        maxRetries: Int = 3,
        baseDelay: TimeInterval = 1.0,
        strategy: RetryStrategy = .constant,
        retryableStatusCodes: Set<Int> = [408, 429, 500, 502, 503, 504]
    ) {
        self.maxRetries = maxRetries
        self.baseDelay = baseDelay
        self.strategy = strategy
        self.retryableStatusCodes = retryableStatusCodes
    }
    
    public func delay(for attempt: Int) -> TimeInterval {
        switch strategy {
        case .constant:
            return baseDelay
        case .linear(let increment):
            return baseDelay + (Double(attempt) * increment)
        case .exponentialBackoff(let multiplier):
            return baseDelay * pow(multiplier, Double(attempt))
        }
    }
    
    public func shouldRetry(for error: Error, attempt: Int) -> Bool {
        guard attempt < maxRetries else { return false }
        
        if let networkError = error as? NetworkError {
            return networkError.isRetryable(with: retryableStatusCodes)
        }
        
        // Retry on URL errors (timeout, network connection lost, etc.)
        if let urlError = error as? URLError {
            return urlError.isRetryable
        }
        
        return false
    }
}

// MARK: - Retry Strategy

public enum RetryStrategy: Sendable {
    case constant
    case linear(increment: TimeInterval)
    case exponentialBackoff(multiplier: Double)
}

// MARK: - Default Policies

public extension RetryPolicy {
    static let none = RetryPolicy(maxRetries: 0)
    static let `default` = RetryPolicy()
    static let aggressive = RetryPolicy(maxRetries: 5, baseDelay: 0.5)
}

// MARK: - URLError Extension

private extension URLError {
    var isRetryable: Bool {
        switch code {
        case .timedOut,
             .cannotFindHost,
             .cannotConnectToHost,
             .networkConnectionLost,
             .dnsLookupFailed,
             .notConnectedToInternet,
             .secureConnectionFailed:
            return true
        default:
            return false
        }
    }
}
