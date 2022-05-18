//
//  MoviesListViewController.swift
//  ExampleMVVM
//
//  Created by Oleh Kudinov on 01.10.18.
//

import UIKit

final class MoviesListViewController: UIViewController, StoryboardInstantiable, Alertable {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var moviesListContainer: UIView!
    
    private var viewModel: MoviesListViewModel!
    private var posterImagesRepository: PosterImagesRepository?

    private var moviesTableViewController: MoviesListTableViewController?

    // MARK: - Lifecycle

    static func create(with viewModel: MoviesListViewModel,
                       posterImagesRepository: PosterImagesRepository?) -> MoviesListViewController {
        let view = MoviesListViewController.instantiateViewController()
        view.viewModel = viewModel
        view.posterImagesRepository = posterImagesRepository
        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBehaviours()
        requestAPIData()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    private func bind(to viewModel: MoviesListViewModel) {
        viewModel.items.observe(on: self) { [weak self] _ in self?.updateItems() }
        viewModel.loading.observe(on: self) { [weak self] in self?.updateLoading($0) }
        viewModel.query.observe(on: self) { [weak self] in self?.updateSearchQuery($0) }
        viewModel.error.observe(on: self) { [weak self] in self?.showError($0) }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: MoviesListTableViewController.self),
            let destinationVC = segue.destination as? MoviesListTableViewController {
            moviesTableViewController = destinationVC
            moviesTableViewController?.viewModel = viewModel
            moviesTableViewController?.posterImagesRepository = posterImagesRepository
        }
    }

    // MARK: - Action
    
    @IBAction func moviesListSearchButtonContainer(_ sender: UIButton) {
        let nextSearchText = "ゴルフ"
        viewModel.query.value = nextSearchText
        viewModel.didSearch(query: nextSearchText)
    }
    
    // MARK: - Private

    private func setupViews() {
        title = viewModel.screenTitle
    }

    private func setupBehaviours() {
        addBehaviors([BackButtonEmptyTitleNavigationBarBehavior(),
                      BarStyleNavigationBarBehavior()])
    }

    private func requestAPIData() {
        viewModel.didSearch(query: viewModel.query.value)
    }
    
    private func updateItems() {
        moviesTableViewController?.reload()
    }

    private func updateLoading(_ loading: MoviesListViewModelLoading?) {
        moviesListContainer.isHidden = true
        LoadingView.hide()

        switch loading {
        case .fullScreen: LoadingView.show()
        case .nextPage: moviesListContainer.isHidden = false
        case .none:
            moviesListContainer.isHidden = viewModel.isEmpty
        }

        moviesTableViewController?.updateLoading(loading)
    }
    
    private func updateSearchQuery(_ query: String) {
        showAlert(title: "What's Search Query?", message: query)
    }
    
    private func showError(_ error: String) {
        guard !error.isEmpty else { return }
        showAlert(title: viewModel.errorTitle, message: error)
    }
}
