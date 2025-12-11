#if canImport(UIKit)
//
//  BaseRouter.swift
//  BSSwiftUI
//
//  Created by Bahadir Sonmez on 13.12.2025.
//

import SwiftUI

// MARK: - Route Protocol

public protocol RouteProtocol: Hashable, Identifiable {
    var id: Self { get }
}

public extension RouteProtocol {
    var id: Self { self }
}

// MARK: - Base Router Protocol

@MainActor
public protocol BaseRouterProtocol: ObservableObject {
    associatedtype Route: RouteProtocol
    
    var navigationPath: NavigationPath { get set }
    var presentedSheet: Route? { get set }
    var presentedFullScreenCover: Route? { get set }
    var alertMessage: String? { get set }
    
    func navigate(to route: Route)
    func presentSheet(_ route: Route)
    func presentFullScreenCover(_ route: Route)
    func showAlert(_ message: String)
    func pop()
    func popToRoot()
    func dismiss()
}

// MARK: - Base Router

@MainActor
open class BaseRouter<Route: RouteProtocol>: BaseRouterProtocol, ObservableObject {
    
    @Published public var navigationPath = NavigationPath()
    @Published public var presentedSheet: Route?
    @Published public var presentedFullScreenCover: Route?
    @Published public var alertMessage: String?
    
    public init() {}
    
    open func navigate(to route: Route) {
        navigationPath.append(route)
    }
    
    open func presentSheet(_ route: Route) {
        presentedSheet = route
    }
    
    open func presentFullScreenCover(_ route: Route) {
        presentedFullScreenCover = route
    }
    
    open func showAlert(_ message: String) {
        alertMessage = message
    }
    
    open func pop() {
        guard !navigationPath.isEmpty else { return }
        navigationPath.removeLast()
    }
    
    open func popToRoot() {
        navigationPath = NavigationPath()
    }
    
    open func dismiss() {
        presentedSheet = nil
        presentedFullScreenCover = nil
    }
}
#endif
