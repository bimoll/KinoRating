// MoviesListViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// MoviesListViewController
final class MoviesListViewController: UIViewController {
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

    // MARK: - Private Properties

    private let networkManager = NetworkService()
    private let cacheImageService = CacheImageService()

    private enum LocalConstants {
        static let identifierMovieCollectionViewCell = "MovieCollectionViewCell"
        static let identifierFooterView = "FooterView"
    }

    private lazy var safeAreaGuide = view.safeAreaLayoutGuide
    private lazy var views: [UIView] = [moviesCollectionView, categoriesScrollView, searchTextField]

    private lazy var movies: [Movie] = [] {
        didSet {
            moviesCollectionView.reloadData()
        }
    }

    private var nextPageNumber = 1

    private lazy var moviesCategories: MoviesCategories = .popular {
        didSet {
            movies = []
            getMoviesPage(urlString: moviesCategories.getUrlString(page: 1))
        }
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
        moviesCategories = categories
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

        getMoviesPage(urlString: moviesCategories.getUrlString(page: nextPageNumber))
    }

    private func searchMovies(_ textField: UITextField, isPaginate: Bool) {
        let page = isPaginate ? nextPageNumber : 1

        if textField.hasText, let text = textField.text?.replacingOccurrences(of: " ", with: "%20") {
            if !isPaginate { movies = [] }
            getMoviesPage(urlString: Constants.getSearchMoviesURLString(page: page, searchedText: text))
        } else {
            if !isPaginate {
                setCurrentCategoriesMovies()
                return
            }

            let urlString = moviesCategories.getUrlString(page: page)
            getMoviesPage(urlString: urlString)
        }
    }

    private func showPosterImage(path: String?, completion: @escaping (UIImage?) -> ()) {
        let posterURLString = Constants.getPosterURLString(path: path ?? "")

        if let image = cacheImageService.getImageFromCache(url: posterURLString) {
            completion(image)
            return
        }

        guard let posterURL = URL(string: posterURLString) else {
            completion(nil)
            return
        }

        networkManager.downloadImage(url: posterURL) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(data):
                guard let data = data, let image = UIImage(data: data) else { return }
                self.cacheImageService.saveImageToCache(url: posterURLString, image: image)
                completion(image)
            case .failure:
                completion(nil)
            }
        }
    }

    private func getMoviesPage(urlString: String) {
        if nextPageNumber == 1 { movies = [] }
        spinner.startAnimating()
        networkManager
            .getMoviesPage(urlString: urlString) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case let .success(page):
                    self.appendNewMovies(page?.results)
                    self.setNextPageNumber(page)
                case let .failure(error):
                    print(error)
                }
                self.spinner.stopAnimating()
            }
    }

    private func setNextPageNumber(_ page: MoviesListPage?) {
        guard
            let currentPageNumber = page?.page,
            let totalPages = page?.totalPages,
            currentPageNumber < totalPages
        else {
            nextPageNumber = -1
            return
        }
        nextPageNumber = currentPageNumber + 1
    }

    private func setCurrentCategoriesMovies() {
        for button in categoriesButtons where button.backgroundColor != .black {
            guard let title = button.titleLabel?.text,
                  let moviesCategories = MoviesCategories(rawValue: title) else { return }
            self.moviesCategories = moviesCategories
        }
    }

    private func appendNewMovies(_ movies: [Movie]?) {
        guard let newMovies = movies else { return }
        self.movies.append(contentsOf: newMovies)
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
        movies.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: LocalConstants.identifierMovieCollectionViewCell,
            for: indexPath
        ) as? MovieCollectionViewCell else { return UICollectionViewCell() }
        cell.getImageCompletion = showPosterImage(path:completion:)
        cell.configureCell(movie: movies[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension MoviesListViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
        if indexPath.item == movies.count - 1 {
            searchMovies(searchTextField, isPaginate: true)
        }
    }
}

// MARK: - UITextFieldDelegate

extension MoviesListViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        searchMovies(textField, isPaginate: false)
    }

    func textFieldShouldReturn(_: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
    }
}
