//
//  MovieDetailRouter.swift
//  DemoProject
//
//  Created by Bahadir Sonmez on 23.12.2025.
//

import UIKit
import BSUIKit
import DemoNetwork

final class MovieDetailRouter: BaseRouter<MovieDetailRouter.Route> {
    
    enum Route: RouteProtocol {
        case none
    }
    
    static func createView(movie: Movie) -> UIViewController {
        let supporter = MovieDetailSupporter()
        let viewModel = MovieDetailViewModel(movie: movie, supporter: supporter)
        let router = MovieDetailRouter()
        let viewController = MovieDetailViewController(viewModel: viewModel, router: router)
        
        router.viewController = viewController
        
        return viewController
    }
}
