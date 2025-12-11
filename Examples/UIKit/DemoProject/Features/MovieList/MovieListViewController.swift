//
//  MovieListViewController.swift
//  DemoProject
//
//  Created by Bahadir Sonmez on 23.12.2025.
//

import UIKit
import BSUIKit
import DemoNetwork
import DemoDesignSystem

final class MovieListViewController: BaseViewController<MovieListViewModel, BaseTableView<Movie, MovieTableViewCell>> {
    
    private let router: MovieListRouter
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = text(for: "movieList.searchPlaceholder")
        return searchController
    }()
    
    init(viewModel: MovieListViewModel, router: MovieListRouter) {
        self.router = router
        let mainView = BaseTableView<Movie, MovieTableViewCell>()
        mainView.tableView.separatorStyle = .none
        mainView.tableView.backgroundColor = .clear
        super.init(viewModel: viewModel, mainView: mainView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackEvent(.screenViewed)
    }
    
    override func setupUI() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        mainView.onSelect = { [weak self] movie in
            self?.trackEvent(.movieSelected(id: movie.id))
            self?.router.navigate(to: .detail(movie))
        }
        
        mainView.onFetchNextPage = { [weak self] in
            self?.viewModel.trigger(.loadMore)
        }
    }
    
    override func bindViewModel() {
        viewModel.state.bind { [weak self] state in
            self?.stateDidChange(state)
        }
        viewModel.trigger(.viewDidLoad)
    }
    
    private func stateDidChange(_ state: MovieListViewState) {
        switch state {
        case .idle:
            showLoading()
        case .loading:
            showLoading()
        case .loaded(let movies):
            hideLoading()
            mainView.configure(with: movies)
        case .error(let message):
            showError(message: message)
        }
    }
}

// MARK: - UISearchResultsUpdating

extension MovieListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text ?? ""
        viewModel.trigger(.search(query))
    }
}
