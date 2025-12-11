#if canImport(UIKit)
//
//  Observable.swift
//  BSUIKit
//
//  Created by Bahadir Sonmez on 22.12.2025.
//

import Foundation

// MARK: - Observable

/// A simple observable wrapper that provides data binding capabilities for UIKit.
/// This serves as the UIKit equivalent of SwiftUI's @Published property wrapper.
public final class Observable<T> {
    
    public var value: T {
        didSet {
            listeners.forEach { $0(value) }
        }
    }
    
    private var listeners: [(T) -> Void] = []
    
    public init(_ value: T) {
        self.value = value
    }
    
    /// Binds a listener closure that gets called immediately with the current value
    /// and whenever the value changes.
    public func bind(_ closure: @escaping (T) -> Void) {
        closure(value)
        listeners.append(closure)
    }
    
    /// Binds a listener closure that only gets called when the value changes,
    /// not immediately upon binding.
    public func observe(_ closure: @escaping (T) -> Void) {
        listeners.append(closure)
    }
    
    /// Removes all listeners.
    public func removeAllListeners() {
        listeners.removeAll()
    }
}

// MARK: - Observable where T is Equatable

public extension Observable where T: Equatable {
    
    /// Binds a listener that only fires when the value actually changes.
    func bindDistinct(_ closure: @escaping (T) -> Void) {
        var lastValue = value
        closure(value)
        listeners.append { newValue in
            if newValue != lastValue {
                lastValue = newValue
                closure(newValue)
            }
        }
    }
}
#endif
