#if canImport(UIKit)
//
//  BaseView.swift
//  BSSwiftUI
//
//  Created by Bahadir Sonmez on 13.12.2025.
//

import SwiftUI

// MARK: - Base View Protocol

@MainActor
public protocol BaseViewProtocol: View {
    associatedtype ViewModel: BaseViewModelProtocol
    associatedtype ContentBody: View
    
    var viewModel: ViewModel { get }
    
    @ViewBuilder var contentBody: ContentBody { get }
}

// MARK: - Base View Protocol Extensions

public extension BaseViewProtocol {
    /// Convenience accessor to get text from the ViewModel's supporter
    func text(for key: ViewModel.Supporter.TextKey) -> String {
        viewModel.text(for: key)
    }
    
    /// Convenience accessor to track analytics events
    func trackEvent(_ event: ViewModel.Supporter.AnalyticsEvent) {
        viewModel.trackEvent(event)
    }
}

// MARK: - Common View Components

public struct LoadingView: View {
    public init() {}
    
    public var body: some View {
        ProgressView()
            .progressViewStyle(.circular)
    }
}

public struct ErrorView: View {
    let message: String
    
    public init(message: String) {
        self.message = message
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.red)
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}
#endif
