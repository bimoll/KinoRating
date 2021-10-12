// MoviesListViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// MoviesListViewController
final class MoviesListViewController: UIViewController {
    private enum LocalConstants {
        static let identifierMovieCollectionViewCell = "MovieCollectionViewCell"
        static let identifierFooterView = "FooterView"
        static let errorTitle = "Ошибка!"
    }

    // MARK: - Visual Components

    private lazy var spinner: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .large)
        indicatorView.color = .white
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }()

    private lazy var searchTextField: UISearchTextField = {
        let searchTextField = UISearchTextField()
        searchTextField.textColor = .white
        searchTextField.autocorrectionType = .no
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Поиск по фильмам",
            attributes: [
                NSAttributedString.Key
                    .foregroundColor: UIColor.gray,
            ]
        )
        searchTextField.delegate = self
        searchTextField.leftView?.tintColor = .gray
        return searchTextField
    }()

    private lazy var moviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .black
        collectionView.register(
            MovieCollectionViewCell.self,
            forCellWithReuseIdentifier: LocalConstants.identifierMovieCollectionViewCell
        )
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.footerReferenceSize = CGSize(
            width: collectionView.bounds.width,
            height: 50
        )
        collectionView.register(
            FooterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: LocalConstants.identifierFooterView
        )
        return collectionView
    }()

    private lazy var categoriesButtons: [UIButton] = {
        var buttons: [UIButton] = []
        MoviesCategories.allCases
            .forEach { buttons.append(UIButton().createSegmentedControlButton(setTitle: $0.rawValue)) }
        return buttons
    }()

    private lazy var categoriesScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .black
        scrollView.addSubview(categoriesStackView)
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    private lazy var categoriesStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: categoriesButtons)
        stackView.backgroundColor = .black
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()

    private lazy var safeAreaGuide = view.safeAreaLayoutGuide
    private lazy var views: [UIView] = [moviesCollectionView, categoriesScrollView, searchTextField]

    // MARK: - Private Properties

    private var viewModel: MovieListViewModelProtocol = MovieListViewModel()
    private var viewData: ViewData<[Movie]>? {
        didSet { fetchUpdates() }
    }

    // MARK: - UIViewController(MoviesListViewController)

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    // MARK: - Actions

    @objc private func handleSegmentedControlButtons(sender: UIButton) {
        guard
            let title = sender.titleLabel?.text,
            let categories = MoviesCategories(rawValue: title)
        else { return }
        navigationItem.title = "\(title) Movies"
        viewModel.setCurrentCategory(categories)
        searchTextField.text = ""

        categoriesButtons.forEach { button in
            if button == sender {
                UIView.animate(withDuration: 0.2, delay: 0.1, options: .transitionFlipFromLeft) {
                    button.backgroundColor = .gray
                }

            } else {
                UIView.animate(withDuration: 0.2, delay: 0.1, options: .transitionFlipFromLeft) {
                    button.backgroundColor = .black
                }
            }
        }
    }

    // MARK: - Private Methods

    private func setupView() {
        views.forEach { view.addSubview($0) }

        configureNavigationBar()
        setupMoviesCollectionViewConstraints()
        setupCategoriesScrollViewConstraints()
        setupCategoriesStackViewConstraints()
        setupSearchTextFieldConstraints()
        categoriesButtons
            .forEach {
                $0.addTarget(self, action: #selector(handleSegmentedControlButtons(sender:)), for: .touchUpInside)
            }
        categoriesButtons.first?.backgroundColor = .darkGray

        updateView()
        viewModel.getMoviesPage(viewModel.getCurrentCategory().getUrlString(page: 1))
    }

    private func fetchUpdates() {
        let urlString = viewModel.getCurrentCategory().getUrlString(page: 1)
        switch viewData {
        case .loading:
            spinner.startAnimating()
        case .data:
            moviesCollectionView.reloadData()
        case let .error(error):
            showLoadingErrorAlert(
                title: LocalConstants.errorTitle,
                message: error.localizedDescription
            ) { [weak self] in
                self?.viewModel.getMoviesPage(urlString)
            }
        case .noData, .none:
            break
        }
    }

    private func updateView() {
        viewModel.updateViewData = { [weak self] viewData in
            guard let self = self else { return }
            self.viewData = viewData
            self.spinner.stopAnimating()
        }
    }

    private func configureNavigationBar() {
        navigationItem.title = "Popular Movies"
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.backgroundColor = .black
        navigationController?.navigationBar
            .titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar
            .largeTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: .bold),
            ]
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupCategoriesScrollViewConstraints() {
        categoriesScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoriesScrollView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            categoriesScrollView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            categoriesScrollView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            categoriesScrollView.heightAnchor.constraint(equalToConstant: 60),
        ])
    }

    private func setupCategoriesStackViewConstraints() {
        categoriesStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoriesStackView.topAnchor.constraint(equalTo: categoriesScrollView.topAnchor, constant: 10),
            categoriesStackView.leadingAnchor.constraint(equalTo: categoriesScrollView.leadingAnchor, constant: 5),
            categoriesStackView.trailingAnchor.constraint(equalTo: categoriesScrollView.trailingAnchor),
            categoriesStackView.heightAnchor.constraint(equalTo: categoriesScrollView.heightAnchor, constant: -10),
        ])
    }

    private func setupSearchTextFieldConstraints() {
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            searchTextField.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            searchTextField.heightAnchor.constraint(equalToConstant: 40),
        ])
    }

    private func setupMoviesCollectionViewConstraints() {
        moviesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            moviesCollectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor),
            moviesCollectionView.leadingAnchor.constraint(equalTo: categoriesScrollView.leadingAnchor),
            moviesCollectionView.trailingAnchor.constraint(equalTo: categoriesScrollView.trailingAnchor),
            moviesCollectionView.bottomAnchor.constraint(equalTo: categoriesScrollView.topAnchor),
        ])
    }
}

// MARK: - UICollectionViewDataSource

extension MoviesListViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        guard case let .data(movies) = viewData else {
            return 0
        }
        return movies.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard case let .data(movies) = viewData else {
            return UICollectionViewCell()
        }

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: LocalConstants.identifierMovieCollectionViewCell,
            for: indexPath
        ) as? MovieCollectionViewCell else { return UICollectionViewCell() }

        cell.configureCell(movie: movies[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension MoviesListViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard case let .data(movies) = viewData else { return }

        let movieDetailViewController = MovieDetailViewController()
        movieDetailViewController.setMovieID(id: movies[indexPath.item].id)
        navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MoviesListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _: UICollectionView,
        layout _: UICollectionViewLayout,
        sizeForItemAt _: IndexPath
    ) -> CGSize {
        let cellWidth = view.frame.width / 2 - 12
        return CGSize(width: cellWidth, height: cellWidth * 1.8)
    }

    func collectionView(
        _: UICollectionView,
        layout _: UICollectionViewLayout,
        insetForSectionAt _: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 5, left: 6, bottom: 5, right: 6)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: LocalConstants.identifierFooterView,
                for: indexPath
            )
            footer.addSubview(spinner)
            spinner.frame = CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: 50)
            return footer
        }
        return UICollectionReusableView()
    }

    func collectionView(
        _: UICollectionView,
        willDisplay _: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        guard case let .data(movies) = viewData else { return }

        if indexPath.item == movies.count - 1 {
            viewModel.searchMovies(searchTextField, isPaginate: true)
        }
    }
}

// MARK: - UITextFieldDelegate

extension MoviesListViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel.searchMovies(textField, isPaginate: false)
    }

    func textFieldShouldReturn(_: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
}
