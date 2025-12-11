//
//  MovieListViewModel.swift
//  DemoProject
//
//  Created by Bahadir Sonmez on 13.12.2025.
//

import Foundation
import Combine
import BSSwiftUI
import DemoNetwork

// MARK: - Input

enum MovieListInput {
    case viewDidLoad
    case loadMore
    case refresh
    case clearSearch
    case searchLoadMore
}

// MARK: - View State

enum MovieListViewState: Equatable {
    case idle
    case loading
    case loaded(MovieListPresentationModel)
    case searching
    case searchResults(SearchPresentationModel)
    case noSearchResults(String)
    case error(String)
}

// MARK: - Presentation Model

struct MovieListPresentationModel: Equatable {
    let movies: [MovieRowPresentationModel]
    let hasMorePages: Bool
}

struct SearchPresentationModel: Equatable {
    let movies: [MovieRowPresentationModel]
    let query: String
    let hasMorePages: Bool
}

// MARK: - ViewModel

@MainActor
final class MovieListViewModel: BaseViewModel<MovieListInput, MovieListViewState, MovieListSupporter> {
    
    @Published var searchText = ""
    
    private let repository: MovieRepositoryProtocol
    
    // Latest Movies
    private var currentPage = 1
    private var movies: [Movie] = []
    private var hasMorePages = true
    private var isLoadingMore = false

    // Search
    private var searchCurrentPage = 1
    private var searchMovies: [Movie] = []
    private var isSearching = false
    private var searchTask: Task<Void, Never>?
    private var searchHasMorePages = true
    private var isSearchLoadingMore = false
    
    func movie(for id: Int) -> Movie? {
        if isSearching {
            return searchMovies.first { $0.id == id }
        }
        return movies.first { $0.id == id }
    }
    
    init(repository: MovieRepositoryProtocol, supporter: MovieListSupporter) {
        self.repository = repository
        super.init(initialState: .idle, supporter: supporter)
        setupSearchBinding()
    }
    
    override func trigger(_ input: MovieListInput) {
        switch input {
        case .viewDidLoad:
            Task { await loadInitialMovies() }
        case .loadMore:
            Task { await loadMore() }
        case .refresh:
            Task { await refresh() }
        case .clearSearch:
            clearSearch()
        case .searchLoadMore:
            Task { await loadMoreSearchResults() }
        }
    }
}

// MARK: - Latest Movies

private extension MovieListViewModel {
    
    func loadInitialMovies() async {
        isSearching = false
        state = .loading
        await fetchLatestMovies(page: 1, forceRefresh: false)
    }
    
    func loadMore() async {
        guard !isLoadingMore, hasMorePages, !isSearching else { return }
        isLoadingMore = true
        
        await fetchLatestMovies(page: currentPage + 1, forceRefresh: false)
        
        isLoadingMore = false
    }
    
    func refresh() async {
        currentPage = 1
        movies = []
        hasMorePages = true
        
        if isSearching {
            let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            await performSearch(query: query)
        } else {
            await fetchLatestMovies(page: 1, forceRefresh: true)
        }
    }
    
    func fetchLatestMovies(page: Int, forceRefresh: Bool) async {
        do {
            let response = try await repository.getLatestMovies(page: page, forceRefresh: forceRefresh)
            handleLatestResponse(response, page: page)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    func handleLatestResponse(_ response: MovieListResponse, page: Int) {
        if page == 1 {
            movies = response.results
        } else {
            let existingIds = Set(movies.map { $0.id })
            let newMovies = response.results.filter { !existingIds.contains($0.id) }
            movies.append(contentsOf: newMovies)
        }
        
        currentPage = response.page
        hasMorePages = response.hasMorePages
        
        state = .loaded(MovieListPresentationModel(
            movies: movies.map { MovieRowPresentationModel(movie: $0) },
            hasMorePages: hasMorePages
        ))
    }
}

// MARK: - Search

private extension MovieListViewModel {
    
    func setupSearchBinding() {
        $searchText
            .removeDuplicates()
            .sink { [weak self] query in
                self?.handleSearchQueryChanged(query)
            }
            .store(in: &cancellables)
    }
    
    func handleSearchQueryChanged(_ query: String) {
        searchTask?.cancel()
        
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedQuery.isEmpty else {
            if isSearching {
                restoreMovieList()
            }
            return
        }
        
        isSearching = true
        
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 300_000_000)
            guard !Task.isCancelled else { return }
            await performSearch(query: trimmedQuery)
        }
    }
    
    func clearSearch() {
        searchTask?.cancel()
        isSearching = false
        searchMovies = []
        searchCurrentPage = 1
        searchHasMorePages = true
    }
    
    func restoreMovieList() {
        clearSearch()
        
        if movies.isEmpty {
            Task { await loadInitialMovies() }
        } else {
            state = .loaded(MovieListPresentationModel(
                movies: movies.map { MovieRowPresentationModel(movie: $0) },
                hasMorePages: hasMorePages
            ))
        }
    }
    
    func performSearch(query: String) async {
        searchMovies = []
        searchCurrentPage = 1
        searchHasMorePages = true
        state = .searching
        
        do {
            let response = try await repository.searchMovies(query: query, page: 1)
            searchMovies = response.results
            searchCurrentPage = response.page
            searchHasMorePages = response.hasMorePages
            
            if response.results.isEmpty {
                state = .noSearchResults(query)
            } else {
                state = .searchResults(SearchPresentationModel(
                    movies: response.results.map { MovieRowPresentationModel(movie: $0) },
                    query: query,
                    hasMorePages: searchHasMorePages
                ))
            }
        } catch is CancellationError {
            // Ignore cancellation errors - these occeur when search is cancelled due to new input
        } catch let urlError as URLError where urlError.code == .cancelled {
            // Ignore URL session cancellation errors
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    func loadMoreSearchResults() async {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !isSearchLoadingMore, searchHasMorePages, isSearching, !query.isEmpty else { return }
        isSearchLoadingMore = true
        
        do {
            let response = try await repository.searchMovies(query: query, page: searchCurrentPage + 1)
            
            let existingIds = Set(searchMovies.map { $0.id })
            let newMovies = response.results.filter { !existingIds.contains($0.id) }
            searchMovies.append(contentsOf: newMovies)
            
            searchCurrentPage = response.page
            searchHasMorePages = response.hasMorePages
            
            state = .searchResults(SearchPresentationModel(
                movies: searchMovies.map { MovieRowPresentationModel(movie: $0) },
                query: query,
                hasMorePages: searchHasMorePages
            ))
        } catch {
            // Don't show error for pagination failures, just stop loading more
        }
        
        isSearchLoadingMore = false
    }
}
