// MovieCollectionViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// MovieCollectionViewCell
final class MovieCollectionViewCell: UICollectionViewCell {
    // MARK: - Visual Components

    private lazy var moviePosterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var movieTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        return label
    }()

    // MARK: - Private Properties

    private var viewData: ViewData<UIImage> = .loading {
        didSet {
            setNeedsLayout()
        }
    }

    // MARK: - UICollectionViewCell(MovieCollectionViewCell)

    override func prepareForReuse() {
        super.prepareForReuse()
        moviePosterImageView.image = nil
    }

    override func layoutSubviews() {
        switch viewData {
        case .loading:
            addShimmerAnimation()
        case let .data(image):
            setImage(image)
        case .error, .noData:
            setImage(UIImage(named: GlobalConstants.moviePlaceholderImageName))
        }
    }

    // MARK: - Private Properties

    private lazy var views: [UIView] = [moviePosterImageView, movieTitleLabel]
    private var viewModel = MovieCellViewModel()

    // MARK: - Public Methods

    func configureCell(movie: Movie) {
        updateCell()

        layer.cornerRadius = 10
        views.forEach { addSubview($0) }
        setupMoviePosterImageViewConstraints()
        viewModel.showPosterImage(path: movie.posterPath)
        setupMovieTitleLabel(title: movie.title)
    }

    // MARK: - Private Methods

    private func updateCell() {
        viewModel.updateViewData = { [weak self] viewData in
            guard let self = self else { return }
            self.viewData = viewData
        }
    }

    private func setImage(_ image: UIImage?) {
        layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
        moviePosterImageView.image = image
        backgroundColor = UIColor(named: GlobalConstants.customBlackColorName)
    }

    private func setupMovieTitleLabel(title: String?) {
        guard let text = title else { return }
        movieTitleLabel.text = text
        setupMovieTitleLabelConstraints()
    }

    private func setupMoviePosterImageViewConstraints() {
        moviePosterImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            moviePosterImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            moviePosterImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            moviePosterImageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            moviePosterImageView.heightAnchor.constraint(equalTo: moviePosterImageView.widthAnchor, multiplier: 1.5),
        ])
    }

    private func setupMovieTitleLabelConstraints() {
        movieTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieTitleLabel.topAnchor.constraint(equalTo: moviePosterImageView.bottomAnchor, constant: 5),
            movieTitleLabel.leadingAnchor.constraint(equalTo: moviePosterImageView.leadingAnchor, constant: 5),
            movieTitleLabel.trailingAnchor.constraint(equalTo: moviePosterImageView.trailingAnchor, constant: -15),
            movieTitleLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -5),
        ])
    }
}
