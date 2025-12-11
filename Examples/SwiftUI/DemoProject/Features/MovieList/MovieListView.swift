//
//  MovieListView.swift
//  DemoProject
//
//  Created by Bahadir Sonmez on 13.12.2025.
//

import SwiftUI
import BSSwiftUI
import DemoDesignSystem
import DemoNetwork

struct MovieListView: BaseViewProtocol {
    
    @StateObject var viewModel: MovieListViewModel
    @StateObject private var router: MovieListRouter
    
    init(
        viewModel: MovieListViewModel,
        router: MovieListRouter
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _router = StateObject(wrappedValue: router)
    }
    
    private var supporter: MovieListSupporter {
        viewModel.supporter
    }
    
    var body: some View {
        NavigationStack(path: $router.navigationPath) {
            contentBody
                .navigationTitle(supporter.text(for: .title))
                .searchable(
                    text: $viewModel.searchText,
                    prompt: supporter.text(for: .searchPlaceholder)
                )
                .navigationDestination(for: MovieListRoute.self) { route in
                    router.view(for: route)
                }
        }
        .onAppear {
            supporter.trackEvent(.screenViewed)
            viewModel.trigger(.viewDidLoad)
        }
    }
    
    var contentBody: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading, .searching:
                LoadingView()
            case .loaded(let model):
                movieList(model: model)
            case .searchResults(let model):
                searchResultsList(model: model)
            case .noSearchResults(let query):
                noResultsView(query: query)
            case .error(let message):
                ErrorView(message: message)
            }
        }
    }
    
    // MARK: - Private Views
    
    private func movieList(model: MovieListPresentationModel) -> some View {
        MovieListContentView(
            movies: model.movies,
            hasMorePages: model.hasMorePages,
            onMovieSelected: { rowModel in
                supporter.trackEvent(.movieSelected(id: rowModel.id))
                if let movie = viewModel.movie(for: rowModel.id) {
                    router.navigate(to: .movieDetail(movie: movie))
                }
            },
            onLoadMore: { _ in
                viewModel.trigger(.loadMore)
            },
            rowContent: { rowModel in
                MovieRowView(model: rowModel)
            }
        )
        .refreshable {
            viewModel.trigger(.refresh)
        }
    }
    
    private func searchResultsList(model: SearchPresentationModel) -> some View {
        MovieListContentView(
            movies: model.movies,
            hasMorePages: model.hasMorePages,
            onMovieSelected: { rowModel in
                supporter.trackEvent(.movieSelected(id: rowModel.id))
                if let movie = viewModel.movie(for: rowModel.id) {
                    router.navigate(to: .movieDetail(movie: movie))
                }
            },
            onLoadMore: { _ in
                viewModel.trigger(.searchLoadMore)
            },
            rowContent: { rowModel in
                MovieRowView(model: rowModel)
            }
        )
    }
    
    private func noResultsView(query: String) -> some View {
        VStack(spacing: DSSpacing.md) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: DSSize.Icon.large))
                .foregroundColor(DSColor.textSecondary)
                .accessibilityHidden(true)
            Text(supporter.text(for: .noResults))
                .headlineStyle()
            Text(supporter.text(for: .noResultsMessage(query)))
                .secondaryStyle()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(supporter.text(for: .noResultsAccessibilityLabel(query)))
    }
}

// MARK: - Preview

#Preview {
    MovieListView(
        viewModel: MovieListViewModel(
            repository: PreviewMovieRepository(),
            supporter: MovieListSupporter()
        ),
        router: MovieListRouter(container: AppContainer.shared)
    )
}
