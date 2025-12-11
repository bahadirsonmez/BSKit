#if canImport(UIKit)
//
//  BaseSupporter.swift
//  BSUIKit
//
//  Created by Bahadir Sonmez on 22.12.2025.
//

import Foundation

// MARK: - Base Supporter Protocol

public protocol BaseSupporterProtocol {
    associatedtype TextKey
    associatedtype AnalyticsEvent
    
    var screenTitle: String { get }
    
    func text(for key: TextKey) -> String
    func trackEvent(_ event: AnalyticsEvent)
}

// MARK: - Default Implementations

public extension BaseSupporterProtocol {
    func trackEvent(_ event: AnalyticsEvent) {
        #if DEBUG
        print("[Analytics] Event tracked: \(event)")
        #endif
    }
}
#endif
