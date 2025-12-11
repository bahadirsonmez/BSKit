//
//  MovieListViewModel.swift
//  DemoProject
//
//  Created by Bahadir Sonmez on 23.12.2025.
//

import Foundation
import BSUIKit
import DemoNetwork
import Combine

// MARK: - Input

enum MovieListInput {
    case viewDidLoad
    case loadMore
    case search(String)
}

// MARK: - View State

enum MovieListViewState: Equatable {
    case idle
    case loading
    case loaded([Movie])
    case error(String)
}

// MARK: - ViewModel

@MainActor
final class MovieListViewModel: BaseViewModel<MovieListInput, MovieListViewState, MovieListSupporter> {
    
    private let repository: MovieRepositoryProtocol
    private var movies: [Movie] = []
    private var currentPage = 1
    private var hasMorePages = true
    private var isLoadingMore = false
    
    private var searchTask: Task<Void, Never>?
    private var isSearching = false
    
    init(repository: MovieRepositoryProtocol, supporter: MovieListSupporter) {
        self.repository = repository
        super.init(initialState: .idle, supporter: supporter)
    }
    
    override func trigger(_ input: MovieListInput) {
        switch input {
        case .viewDidLoad:
            Task { await loadInitialMovies() }
        case .loadMore:
            Task { await loadMore() }
        case .search(let query):
            handleSearch(query)
        }
    }
    
    private func loadInitialMovies() async {
        state.value = .loading
        await fetchMovies(page: 1)
    }
    
    private func loadMore() async {
        guard !isLoadingMore, hasMorePages, !isSearching else { return }
        isLoadingMore = true
        await fetchMovies(page: currentPage + 1)
        isLoadingMore = false
    }
    
    private func fetchMovies(page: Int) async {
        do {
            let response = try await repository.getLatestMovies(page: page, forceRefresh: false)
            if page == 1 {
                movies = response.results
            } else {
                movies.append(contentsOf: response.results)
            }
            currentPage = response.page
            hasMorePages = response.hasMorePages
            state.value = .loaded(movies)
        } catch {
            state.value = .error(error.localizedDescription)
        }
    }
    
    private func handleSearch(_ query: String) {
        searchTask?.cancel()
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmed.isEmpty else {
            isSearching = false
            state.value = .loaded(movies)
            return
        }
        
        isSearching = true
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 300_000_000)
            guard !Task.isCancelled else { return }
            await performSearch(query: trimmed)
        }
    }
    
    private func performSearch(query: String) async {
        state.value = .loading
        do {
            let response = try await repository.searchMovies(query: query, page: 1)
            state.value = .loaded(response.results)
        } catch {
            state.value = .error(error.localizedDescription)
        }
    }
}
