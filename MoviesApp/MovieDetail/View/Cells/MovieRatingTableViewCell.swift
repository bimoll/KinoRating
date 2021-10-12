// MovieRatingTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

final class MovieRatingTableViewCell: UITableViewCell {
    // MARK: - Visual Components

    private let titleLable = UILabel().createTitleLabel()
    private let popularityLabel = UILabel().createSmallDescriptionLabel()
    private let voteCountLabel = UILabel().createSmallDescriptionLabel()
    private let popularityImageView = UIImageView().createSystemIconImageView(iconName: "star.fill")
    private let voteCountImageView = UIImageView().createSystemIconImageView(iconName: "person.3.fill")

    // MARK: - Private Properties

    private lazy var views = [titleLable, popularityLabel, popularityImageView, voteCountImageView, voteCountLabel]

    // MARK: - UITableViewCell(MovieRatingTableViewCell)

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        views.forEach { addSubview($0) }
        backgroundColor = UIColor(named: "CustomDarkGray")
        titleLable.font = UIFont.systemFont(ofSize: 26)
        setupTitleLabelConstraints()
        setupPopularityImageViewConstraints()
        setupPopularityLabelConstraints()
        setupRatingImageViewConstraints()
        setupRatingLabelConstraints()
    }

    // MARK: - Private Methods

    private func setupTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            titleLable.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            titleLable.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLable.heightAnchor.constraint(equalToConstant: 30),
            titleLable.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLable.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])
    }

    private func setupPopularityImageViewConstraints() {
        NSLayoutConstraint.activate([
            popularityImageView.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 10),
            popularityImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            popularityImageView.heightAnchor.constraint(equalToConstant: 30),
            popularityImageView.widthAnchor.constraint(equalTo: popularityImageView.heightAnchor, multiplier: 1),
            popularityImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
        ])
    }

    private func setupPopularityLabelConstraints() {
        NSLayoutConstraint.activate([
            popularityLabel.centerYAnchor.constraint(equalTo: popularityImageView.centerYAnchor),
            popularityLabel.leadingAnchor.constraint(equalTo: popularityImageView.trailingAnchor, constant: 10),
            popularityLabel.trailingAnchor.constraint(equalTo: centerXAnchor),
        ])
    }

    private func setupRatingImageViewConstraints() {
        NSLayoutConstraint.activate([
            voteCountImageView.topAnchor.constraint(equalTo: popularityImageView.topAnchor),
            voteCountImageView.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 10),
            voteCountImageView.heightAnchor.constraint(equalTo: popularityImageView.heightAnchor),
            voteCountImageView.widthAnchor.constraint(equalTo: voteCountImageView.heightAnchor, multiplier: 1),
            voteCountImageView.bottomAnchor.constraint(equalTo: popularityImageView.bottomAnchor),
        ])
    }

    private func setupRatingLabelConstraints() {
        NSLayoutConstraint.activate([
            voteCountLabel.centerYAnchor.constraint(equalTo: voteCountImageView.centerYAnchor),
            voteCountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            voteCountLabel.leadingAnchor.constraint(equalTo: voteCountImageView.trailingAnchor, constant: 20),
        ])
    }
}

// MARK: - MovieInfoCellProtocol

extension MovieRatingTableViewCell: MovieInfoCellProtocol {
    func configureCell(movieInfo: MovieInfo?) {
        guard let rating = movieInfo?.voteAverage else { return }
        guard let titleText = movieInfo?.title else { return }
        titleLable.text = titleText
        popularityLabel.text = "Рейтинг: \(rating)"
        guard let voteCount = movieInfo?.voteCount else { return }
        voteCountLabel.text = "\(voteCount) оценки"
    }
}
