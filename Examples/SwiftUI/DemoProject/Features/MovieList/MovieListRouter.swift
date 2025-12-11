//
//  MovieListRouter.swift
//  DemoProject
//
//  Created by Bahadir Sonmez on 13.12.2025.
//

import SwiftUI
import BSSwiftUI
import DemoNetwork

// MARK: - Route

enum MovieListRoute: RouteProtocol {
    case movieDetail(movie: Movie)
}

// MARK: - Router

@MainActor
final class MovieListRouter: BaseRouter<MovieListRoute> {
    
    private let container: AppContainerProtocol
    
    init(container: AppContainerProtocol) {
        self.container = container
        super.init()
    }
    
    // MARK: - Factory
    
    static func createView(container: AppContainerProtocol) -> MovieListView {
        let repository = MovieRepository(networkClient: container.networkClient)
        let supporter = MovieListSupporter()
        let viewModel = MovieListViewModel(
            repository: repository,
            supporter: supporter
        )
        let router = MovieListRouter(container: container)
        return MovieListView(viewModel: viewModel, router: router)
    }
    
    // MARK: - Navigation
    
    @ViewBuilder
    func view(for route: MovieListRoute) -> some View {
        switch route {
        case .movieDetail(let movie):
            MovieDetailRouter.createView(movie: movie, container: container)
        }
    }
}
