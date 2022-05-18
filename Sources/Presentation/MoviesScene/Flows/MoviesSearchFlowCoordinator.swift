//
//  MoviesSearchFlowCoordinator.swift
//  ExampleMVVM
//
//  Created by Oleh Kudinov on 03.03.19.
//

import UIKit

protocol MoviesSearchFlowCoordinatorDependencies  {
    func makeMoviesTopViewController(actions: MoviesTopViewModelActions) -> MoviesTopViewController
    func makeMoviesListViewController(movieQuery: MovieQuery, actions: MoviesListViewModelActions) -> MoviesListViewController
    func makeMoviesDetailsViewController(movie: Movie) -> UIViewController
}

final class MoviesSearchFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: MoviesSearchFlowCoordinatorDependencies

    private weak var moviesListVC: MoviesListViewController?

    init(navigationController: UINavigationController,
         dependencies: MoviesSearchFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        // Note: here we keep strong reference with actions, this way this flow do not need to be strong referenced
        let actions = MoviesTopViewModelActions(showMovieList: showMovieList)
        let vc = dependencies.makeMoviesTopViewController(actions: actions)
        
        navigationController?.pushViewController(vc, animated: false)
    }

    private func showMovieList(movieQuery: MovieQuery) {
        let actions = MoviesListViewModelActions(showMovieDetails: showMovieDetails)
        let vc = dependencies.makeMoviesListViewController(movieQuery: movieQuery, actions: actions)
        
        navigationController?.pushViewController(vc, animated: false)
        moviesListVC = vc
    }
    
    private func showMovieDetails(movie: Movie) {
        let vc = dependencies.makeMoviesDetailsViewController(movie: movie)
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
