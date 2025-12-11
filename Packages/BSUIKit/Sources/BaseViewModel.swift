#if canImport(UIKit)
//
//  BaseViewModel.swift
//  BSUIKit
//
//  Created by Bahadir Sonmez on 22.12.2025.
//

import Foundation

// MARK: - Base ViewModel Protocol

@MainActor
public protocol BaseViewModelProtocol: AnyObject {
    associatedtype Input
    associatedtype State
    associatedtype Supporter: BaseSupporterProtocol
    
    var state: Observable<State> { get }
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
open class BaseViewModel<Input, State, Supporter: BaseSupporterProtocol>: BaseViewModelProtocol {
    
    public let state: Observable<State>
    public let supporter: Supporter
    
    public init(initialState: State, supporter: Supporter) {
        self.state = Observable(initialState)
        self.supporter = supporter
    }
    
    open func trigger(_ input: Input) {
        // Override in subclass
    }
}
#endif
