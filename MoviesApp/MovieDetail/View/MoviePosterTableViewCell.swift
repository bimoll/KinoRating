// MoviePosterTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

final class MoviePosterTableViewCell: UITableViewCell {
    // MARK: - Visual Components

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .black
        return imageView
    }()

    // MARK: - Private Properties

    private let networkManager = NetworkService()

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        setupPosterImageViewConstraints()
    }

    // MARK: - Private Methods

    func configureCell(imagePath: String?) {
        guard let path = imagePath else { return }
        let posterURLString = "https://image.tmdb.org/t/p/w500\(path)"
        guard let posterURL = URL(string: posterURLString) else { return }
        networkManager.downloadImage(url: posterURL) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(data):
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self.posterImageView.image = UIImage(data: data)
                }
            case let .failure(error):
                print(error)
            }
        }
    }

    private func setupPosterImageViewConstraints() {
        addSubview(posterImageView)
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 0.75),
        ])
    }
}
