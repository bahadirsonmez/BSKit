#if canImport(UIKit)
//
//  BaseViewController.swift
//  BSUIKit
//
//  Created by Bahadir Sonmez on 22.12.2025.
//

import UIKit

// MARK: - Base ViewController Protocol

@MainActor
public protocol BaseViewControllerProtocol: UIViewController {
    associatedtype ViewModel: BaseViewModelProtocol
    associatedtype MainView: UIView
    
    var viewModel: ViewModel { get }
    var mainView: MainView { get }
    
    func setupUI()
    func bindViewModel()
}

// MARK: - Base ViewController Protocol Extensions

public extension BaseViewControllerProtocol {
    /// Convenience accessor to get text from the ViewModel's supporter
    func text(for key: ViewModel.Supporter.TextKey) -> String {
        viewModel.text(for: key)
    }
    
    /// Convenience accessor to track analytics events
    func trackEvent(_ event: ViewModel.Supporter.AnalyticsEvent) {
        viewModel.trackEvent(event)
    }
    
    /// Convenience accessor to the screen title
    var screenTitle: String {
        viewModel.supporter.screenTitle
    }
}

// MARK: - Base ViewController

@MainActor
open class BaseViewController<ViewModel: BaseViewModelProtocol, MainView: UIView>: UIViewController, BaseViewControllerProtocol {
    
    public let viewModel: ViewModel
    public let mainView: MainView
    
    public init(viewModel: ViewModel, mainView: MainView = MainView()) {
        self.viewModel = viewModel
        self.mainView = mainView
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func loadView() {
        view = mainView
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = screenTitle
        
        setupUI()
        bindViewModel()
    }
    
    open func setupUI() {
        // Override in subclass
    }
    
    open func bindViewModel() {
        // Override in subclass
    }
    
    // MARK: - State Handling Helpers
    
    private var loadingView: LoadingView?
    private var errorView: ErrorView?
    
    open func showLoading() {
        hideError()
        guard loadingView == nil else { return }
        
        let loading = LoadingView()
        loading.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loading)
        
        NSLayoutConstraint.activate([
            loading.topAnchor.constraint(equalTo: view.topAnchor),
            loading.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loading.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loading.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        self.loadingView = loading
    }
    
    open func hideLoading() {
        loadingView?.removeFromSuperview()
        loadingView = nil
    }
    
    open func showError(message: String) {
        hideLoading()
        guard errorView == nil else { 
            errorView?.message = message
            return 
        }
        
        let error = ErrorView(message: message)
        error.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(error)
        
        NSLayoutConstraint.activate([
            error.topAnchor.constraint(equalTo: view.topAnchor),
            error.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            error.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            error.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        self.errorView = error
    }
    
    open func hideError() {
        errorView?.removeFromSuperview()
        errorView = nil
    }
}
#endif
