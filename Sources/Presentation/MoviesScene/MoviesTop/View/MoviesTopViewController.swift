//
//  MoviesTopViewController.swift
//  reservation
//
//  Created by maye on 2022/5/5.
//

import UIKit

final class MoviesTopViewController: UIViewController, StoryboardInstantiable, Alertable {

    private var viewModel: MoviesTopViewModel!

    // MARK: - Lifecycle

    static func create(with viewModel: MoviesTopViewModel) -> MoviesTopViewController {
        let view = MoviesTopViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    private func bind(to viewModel: MoviesTopViewModel) {
        viewModel.error.observe(on: self) { [weak self] in self?.showError($0) }
    }
    
    // MARK: - Action
    
    @IBAction func doneSearchBtn(_ sender: UIButton) {
        let searchText = "さくら"
        viewModel.didSearch(query: searchText)
    }
    
    // MARK: - Private
    
    private func setupViews() {
        title = viewModel.screenTitle
    }
    
    private func showError(_ error: String) {
        guard !error.isEmpty else { return }
        showAlert(title: viewModel.errorTitle, message: error)
    }
}
