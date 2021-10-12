// MovieDetailView.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

final class MovieDetailView: UIView {
    private enum LocalConstants {
        static let identifierMoviePosterTableViewCell = "MoviePosterTableViewCell"
        static let identifierMovieRatingTableViewCell = "MovieRatingTableViewCell"
        static let identifierMovieReleaseInfoTableViewCell = "MovieReleaseInfoTableViewCell"
        static let identifierMovieOverviewTableViewCell = "MovieOverviewTableViewCell"
        static let countCells = 4
    }

    // MARK: - Visual Components

    private lazy var shimmerView: UIView = {
        let view = UIView()
        let frameSize = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
        addSubview(view)
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: frameSize.y)
        view.center = frameSize
        return view
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.backgroundColor = .black
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .white
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        tableView.register(
            MoviePosterTableViewCell.self,
            forCellReuseIdentifier: LocalConstants.identifierMoviePosterTableViewCell
        )
        tableView.register(
            MovieRatingTableViewCell.self,
            forCellReuseIdentifier: LocalConstants.identifierMovieRatingTableViewCell
        )
        tableView.register(
            MovieReleaseInfoTableViewCell.self,
            forCellReuseIdentifier: LocalConstants.identifierMovieReleaseInfoTableViewCell
        )
        tableView.register(
            MovieOverviewTableViewCell.self,
            forCellReuseIdentifier: LocalConstants.identifierMovieOverviewTableViewCell
        )
        return tableView
    }()

    // MARK: - Private Properties

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

    func startLoading() {
        shimmerView.isHidden = false
        tableView.isHidden = true
        shimmerView.addShimmerAnimation()
    }

    func showMoviesInfo(_ info: MovieInfo) {
        tableView.isHidden = false
        shimmerView.isHidden = true
        movieInfo = info
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
        LocalConstants.countCells
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var identifier: String

        switch indexPath.row {
        case 0:
            guard let cell = tableView
                .dequeueReusableCell(
                    withIdentifier: LocalConstants
                        .identifierMoviePosterTableViewCell
                ) as? MoviePosterTableViewCell
            else { return UITableViewCell() }
            cell.configureCell(imagePath: movieInfo?.backdropPath)
            cell.selectionStyle = .none
            return cell
        case 1:
            identifier = LocalConstants.identifierMovieRatingTableViewCell
        case 2:
            identifier = LocalConstants.identifierMovieReleaseInfoTableViewCell
        case 3:
            identifier = LocalConstants.identifierMovieOverviewTableViewCell
        default:
            return UITableViewCell()
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MovieInfoCellProtocol else {
            return UITableViewCell()
        }
        cell.configureCell(movieInfo: movieInfo)
        cell.selectionStyle = .none
        return cell
    }
}
