//
//  MovieDetailRouter.swift
//  DemoProject
//
//  Created by Bahadir Sonmez on 13.12.2025.
//

import SwiftUI
import BSSwiftUI
import DemoNetwork

// MARK: - Route

enum MovieDetailRoute: RouteProtocol {}

// MARK: - Router

@MainActor
final class MovieDetailRouter: BaseRouter<MovieDetailRoute> {
    
    private let container: AppContainerProtocol
    
    init(container: AppContainerProtocol) {
        self.container = container
        super.init()
    }
    
    // MARK: - Factory
    
    static func createView(movie: Movie, container: AppContainerProtocol) -> MovieDetailView {
        let supporter = MovieDetailSupporter()
        let viewModel = MovieDetailViewModel(movie: movie, supporter: supporter)
        let router = MovieDetailRouter(container: container)
        return MovieDetailView(viewModel: viewModel, router: router)
    }
}
