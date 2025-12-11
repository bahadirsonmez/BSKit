#if canImport(UIKit)
//
//  BaseRouter.swift
//  BSUIKit
//
//  Created by Bahadir Sonmez on 22.12.2025.
//

import UIKit

// MARK: - Route Protocol

public protocol RouteProtocol {
    // Marker protocol for routes
}

// MARK: - Router Display Type

public enum RouterDisplayType {
    case push
    case modal
    case fullScreen
}

// MARK: - Base Router Protocol

@MainActor
public protocol BaseRouterProtocol: AnyObject {
    associatedtype Route: RouteProtocol
    
    var viewController: UIViewController? { get set }
    var navigationController: UINavigationController? { get }
    
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
open class BaseRouter<Route: RouteProtocol>: BaseRouterProtocol {
    
    public weak var viewController: UIViewController?
    
    public var navigationController: UINavigationController? {
        viewController?.navigationController
    }
    
    public init() {}
    
    open func navigate(to route: Route) {
        // Override in subclass to handle navigation
    }
    
    open func presentSheet(_ route: Route) {
        // Override in subclass to handle sheet presentation
    }
    
    open func presentFullScreenCover(_ route: Route) {
        // Override in subclass to handle full screen presentation
    }
    
    open func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController?.present(alert, animated: true)
    }
    
    open func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    open func popToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    open func dismiss() {
        viewController?.dismiss(animated: true)
    }
}

// MARK: - Default Implementations

public extension BaseRouterProtocol {
    func close(displayType: RouterDisplayType, completion: (() -> Void)? = nil) {
        switch displayType {
        case .push:
            pop()
            completion?()
        case .modal, .fullScreen:
            viewController?.dismiss(animated: true, completion: completion)
        }
    }
    
    func close<T>(with data: T, displayType: RouterDisplayType, completion: ((T) -> Void)?) {
        close(displayType: displayType) {
            completion?(data)
        }
    }
}
#endif
