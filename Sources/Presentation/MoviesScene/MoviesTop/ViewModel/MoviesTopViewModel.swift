//
//  MoviesTopViewModel.swift
//  reservation
//
//  Created by maye on 2022/5/5.
//

import Foundation

struct MoviesTopViewModelActions {
    let showMovieList: (MovieQuery) -> Void
}

protocol MoviesTopViewModelInput {
    func viewDidLoad()
    func didSearch(query: String)
}

protocol MoviesTopViewModelOutput {
    var error: Observable<String> { get }
    var screenTitle: String { get }
    var errorTitle: String { get }
}

protocol MoviesTopViewModel: MoviesTopViewModelInput, MoviesTopViewModelOutput {}

final class DefaultMoviesTopViewModel: MoviesTopViewModel {

    private let searchMoviesUseCase: SearchMoviesUseCase
    private let actions: MoviesTopViewModelActions?


    // MARK: - OUTPUT
    
    let error: Observable<String> = Observable("")
    let screenTitle = NSLocalizedString("Movies top", comment: "")
    let errorTitle = NSLocalizedString("Error", comment: "")

    // MARK: - Init

    init(searchMoviesUseCase: SearchMoviesUseCase,
         actions: MoviesTopViewModelActions? = nil) {
        self.searchMoviesUseCase = searchMoviesUseCase
        self.actions = actions
    }

    // MARK: - Private
    private func handle(error: Error) {
        self.error.value = error.isInternetConnectionError ?
            NSLocalizedString("No internet connection", comment: "") :
            NSLocalizedString("Failed loading movies", comment: "")
    }
}

// MARK: - INPUT. View event methods

extension DefaultMoviesTopViewModel {

    func viewDidLoad() { }

    func didSearch(query: String) {
        guard !query.isEmpty else { return }
        actions?.showMovieList(MovieQuery(query: query))
    }
}

// MARK: - Private

private extension Array where Element == MoviesPage {
    var movies: [Movie] { flatMap { $0.movies } }
}
