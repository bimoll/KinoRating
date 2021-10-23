// MoviePosterTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

final class MoviePosterTableViewCell: UITableViewCell {
    static let identifier = "MoviePosterTableViewCell"

    // MARK: - Visual Components

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .black
        return imageView
    }()

    // MARK: - Private Properties

    private var viewModel: MovieCellViewModelProtocol = MovieCellViewModel()

    private var viewData: ViewData<UIImage> = .loading {
        didSet { fetchUpdates() }
    }

    // MARK: - UITableViewCell(MoviePosterTableViewCell)

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        selectionStyle = .none
        setupPosterImageViewConstraints()
    }

    // MARK: - Public Methods

    func configureCell(imagePath: String?) {
        viewModel.updateViewData = { [weak self] viewData in
            self?.viewData = viewData
        }
        viewModel.showPosterImage(path: imagePath)
    }

    // MARK: - Private Methods

    private func fetchUpdates() {
        switch viewData {
        case .loading:
            addShimmerAnimation()
        case let .data(image):
            setImage(image)
        case .error, .noData:
            if posterImageView.image != nil { break }
            setImage(UIImage(named: ImageConstants.moviePlaceholderImageName))
        }
    }

    private func setImage(_ image: UIImage?) {
        layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
        posterImageView.image = image
        backgroundColor = UIColor(named: ColorConstants.customBlackColorName)
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
