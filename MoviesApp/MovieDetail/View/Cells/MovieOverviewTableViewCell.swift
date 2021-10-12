// MovieOverviewTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

final class MovieOverviewTableViewCell: UITableViewCell {
    // MARK: - Visual Components

    private let overviewTitleLabel = UILabel().createTitleLabel()
    private let overviewLabel = UILabel().createSmallDescriptionLabel()

    // MARK: - Private Methods

    private lazy var views = [overviewTitleLabel, overviewLabel]

    // MARK: - UITableViewCell(MovieOverviewTableViewCell)

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        backgroundColor = UIColor(named: "CustomDarkGray")
        views.forEach { addSubview($0) }
        setupOverviewTitleLabel()
        setupOverviewLabel()
    }

    // MARK: - Private Methods

    private func setupOverviewTitleLabel() {
        overviewTitleLabel.textAlignment = .left
        NSLayoutConstraint.activate([
            overviewTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            overviewTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            overviewTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])
    }

    private func setupOverviewLabel() {
        NSLayoutConstraint.activate([
            overviewLabel.topAnchor.constraint(equalTo: overviewTitleLabel.bottomAnchor, constant: 15),
            overviewLabel.leadingAnchor.constraint(equalTo: overviewTitleLabel.leadingAnchor),
            overviewLabel.trailingAnchor.constraint(equalTo: overviewTitleLabel.trailingAnchor),
            overviewLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
        ])
    }
}

// MARK: - MovieInfoCellProtocol

extension MovieOverviewTableViewCell: MovieInfoCellProtocol {
    func configureCell(movieInfo: MovieInfo?) {
        guard let overview = movieInfo?.overview else { return }
        overviewLabel.text = overview
        guard let tagline = movieInfo?.tagline else { return }
        if tagline.isEmpty {
            overviewTitleLabel.text = "Описание фильма"
            return
        }
        overviewTitleLabel.text = tagline
    }
}
