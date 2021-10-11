// MovieDetailView.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

final class MovieDetailView: UIView {
    // MARK: - Visual Components

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.backgroundColor = .black
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .white
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        tableView.register(MoviePosterTableViewCell.self, forCellReuseIdentifier: identifierMoviePosterTableViewCell)
        tableView.register(MovieRatingTableViewCell.self, forCellReuseIdentifier: identifierMovieRatingTableViewCell)
        tableView.register(
            MovieReleaseInfoTableViewCell.self,
            forCellReuseIdentifier: identifierMovieReleaseInfoTableViewCell
        )
        tableView.register(
            MovieOverviewTableViewCell.self,
            forCellReuseIdentifier: identifierMovieOverviewTableViewCell
        )
        return tableView
    }()

    // MARK: - Private Properties

    private let identifierMoviePosterTableViewCell = "MoviePosterTableViewCell"
    private let identifierMovieRatingTableViewCell = "MovieRatingTableViewCell"
    private let identifierMovieReleaseInfoTableViewCell = "MovieReleaseInfoTableViewCell"
    private let identifierMovieOverviewTableViewCell = "MovieOverviewTableViewCell"

    private var movieInfo: MovieInfo? {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: - Initializators

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func setMovieInfo(movieInfo: MovieInfo?) {
        self.movieInfo = movieInfo
    }

    // MARK: - Private Methods

    private func setupView() {
        backgroundColor = .black
        setupTableViewConstraints()
    }

    private func setupTableViewConstraints() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

// MARK: - UITableViewDataSource

extension MovieDetailView: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView
                .dequeueReusableCell(withIdentifier: identifierMoviePosterTableViewCell) as? MoviePosterTableViewCell
            else { return UITableViewCell() }
            cell.configureCell(imagePath: movieInfo?.backdropPath)
            cell.selectionStyle = .none
            return cell
        case 1:
            guard let cell = tableView
                .dequeueReusableCell(withIdentifier: identifierMovieRatingTableViewCell) as? MovieRatingTableViewCell
            else { return UITableViewCell() }
            cell.configureCell(movieInfo: movieInfo)
            cell.selectionStyle = .none
            return cell
        case 2:
            guard let cell = tableView
                .dequeueReusableCell(
                    withIdentifier: identifierMovieReleaseInfoTableViewCell
                ) as? MovieReleaseInfoTableViewCell
            else { return UITableViewCell() }
            cell.configureCell(movieInfo: movieInfo)
            cell.selectionStyle = .none
            return cell
        case 3:
            guard let cell = tableView
                .dequeueReusableCell(
                    withIdentifier: identifierMovieOverviewTableViewCell
                ) as? MovieOverviewTableViewCell
            else { return UITableViewCell() }
            cell.configureCell(movieInfo: movieInfo)
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
    }
}
