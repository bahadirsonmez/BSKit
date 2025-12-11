#if canImport(UIKit)
//
//  BaseViewModel.swift
//  BSSwiftUI
//
//  Created by Bahadir Sonmez on 13.12.2025.
//

import Foundation
import Combine

// MARK: - Base ViewModel Protocol

@MainActor
public protocol BaseViewModelProtocol: ObservableObject {
    associatedtype Input
    associatedtype State
    associatedtype Supporter: BaseSupporterProtocol
    
    var state: State { get set }
    var supporter: Supporter { get }
    
    func trigger(_ input: Input)
    func text(for key: Supporter.TextKey) -> String
    func trackEvent(_ event: Supporter.AnalyticsEvent)
}

// MARK: - Default Implementations

public extension BaseViewModelProtocol {
    func text(for key: Supporter.TextKey) -> String {
        supporter.text(for: key)
    }
    
    func trackEvent(_ event: Supporter.AnalyticsEvent) {
        supporter.trackEvent(event)
    }
}

// MARK: - Base ViewModel

@MainActor
open class BaseViewModel<Input, State, Supporter: BaseSupporterProtocol>: BaseViewModelProtocol, ObservableObject {
    
    @Published public var state: State
    public let supporter: Supporter
    
    public var cancellables = Set<AnyCancellable>()
    
    public init(initialState: State, supporter: Supporter) {
        self.state = initialState
        self.supporter = supporter
    }
    
    open func trigger(_ input: Input) {
        // Override in subclass
    }
}
#endif
