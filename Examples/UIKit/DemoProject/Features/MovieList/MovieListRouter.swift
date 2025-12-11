//
//  MovieListRouter.swift
//  DemoProject
//
//  Created by Bahadir Sonmez on 23.12.2025.
//

import UIKit
import BSUIKit
import DemoNetwork

final class MovieListRouter: BaseRouter<MovieListRouter.Route> {
    
    static func createView(repository: MovieRepositoryProtocol) -> UIViewController {
        let supporter = MovieListSupporter()
        let viewModel = MovieListViewModel(repository: repository, supporter: supporter)
        let router = MovieListRouter()
        let viewController = MovieListViewController(viewModel: viewModel, router: router)
        
        router.viewController = viewController
        
        return viewController
    }
    
    enum Route: RouteProtocol {
        case detail(Movie)
    }
    
    override func navigate(to route: Route) {
        switch route {
        case .detail(let movie):
            let detailVC = MovieDetailRouter.createView(movie: movie)
            viewController?.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
