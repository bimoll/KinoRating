// MovieReleaseInfoTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

final class MovieReleaseInfoTableViewCell: UITableViewCell {
    static let identifier = "MovieReleaseInfoTableViewCell"

    // MARK: - Visual Coponents

    private let durationTitleLabel = UILabel().createTitleLabel()
    private let durationImageView = UIImageView().createSystemIconImageView(iconName: GlobalConstants.durationImageName)
    private let durationLabel = UILabel().createSmallDescriptionLabel()
    private let ganresTitleLabel = UILabel().createTitleLabel()
    private let ganresLabel = UILabel().createSmallDescriptionLabel()
    private let ganrerImageView = UIImageView().createSystemIconImageView(iconName: GlobalConstants.genresImageName)

    // MARK: - Private Properties

    private lazy var views = [
        durationTitleLabel,
        durationLabel,
        ganresTitleLabel,
        ganresLabel,
        durationImageView,
        ganrerImageView,
    ]

    // MARK: - UITableViewCell(MovieReleaseInfoTableViewCell)

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        views.forEach { addSubview($0) }
        backgroundColor = UIColor(named: GlobalConstants.customDarkGrayColorName)
        durationTitleLabel.text = "Длительность"
        ganresTitleLabel.text = "Жанры"

        setupDurationTitleLabelConstraints()
        setupDurationLabelConstraints()
        setupGanresTitleLabelConstraints()
        setupGanresImageViewConstraints()
        setupGanresLabelConstraints()
        selectionStyle = .none
    }

    // MARK: - Public Methods

    func configureCell(movieInfo: MovieInfo?) {
        guard let duration = movieInfo?.runtime else { return }
        durationLabel.text = "\(duration) минут(ы)"

        guard let ganres = movieInfo?.genres else { return }
        var ganresString = ""
        ganres.forEach { ganresString += "\n\($0.name)" }
        ganresLabel.text = ganresString

        setupDurationImageViewConstraints()
    }

    // MARK: - Private Methods

    private func setupDurationTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            durationTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            durationTitleLabel.heightAnchor.constraint(equalToConstant: 30),
            durationTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            durationTitleLabel.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -10),
        ])
    }

    private func setupDurationImageViewConstraints() {
        NSLayoutConstraint.activate([
            durationImageView.topAnchor.constraint(equalTo: durationTitleLabel.bottomAnchor, constant: 20),
            durationImageView.leadingAnchor.constraint(equalTo: durationTitleLabel.leadingAnchor),
            durationImageView.heightAnchor.constraint(equalToConstant: 30),
            durationImageView.widthAnchor.constraint(equalTo: durationTitleLabel.heightAnchor, multiplier: 1),
        ])
    }

    private func setupDurationLabelConstraints() {
        NSLayoutConstraint.activate([
            durationLabel.centerYAnchor.constraint(equalTo: durationImageView.centerYAnchor),
            durationLabel.leadingAnchor.constraint(equalTo: durationImageView.trailingAnchor, constant: 10),
            durationLabel.trailingAnchor.constraint(equalTo: centerXAnchor),
        ])
    }

    private func setupGanresTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            ganresTitleLabel.topAnchor.constraint(equalTo: durationTitleLabel.topAnchor),
            ganresTitleLabel.heightAnchor
                .constraint(equalTo: durationTitleLabel.heightAnchor),
            ganresTitleLabel.leadingAnchor.constraint(equalTo: centerXAnchor),
            ganresTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])
    }

    private func setupGanresImageViewConstraints() {
        NSLayoutConstraint.activate([
            ganrerImageView.topAnchor.constraint(equalTo: durationImageView.topAnchor),
            ganrerImageView.leadingAnchor.constraint(equalTo: ganresTitleLabel.leadingAnchor),
            ganrerImageView.heightAnchor.constraint(equalTo: durationImageView.heightAnchor),
            ganrerImageView.widthAnchor.constraint(equalTo: ganrerImageView.heightAnchor, multiplier: 1),
        ])
    }

    private func setupGanresLabelConstraints() {
        NSLayoutConstraint.activate([
            ganresLabel.topAnchor.constraint(equalTo: ganresTitleLabel.bottomAnchor, constant: 10),
            ganresLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            ganresLabel.leadingAnchor.constraint(equalTo: ganrerImageView.trailingAnchor, constant: 20),
            ganresLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -15),
        ])
    }
}
