// MovieCellViewModel.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

protocol MovieCellViewModelProtocol {
    var updateViewData: ViewDataHandler<UIImage>? { get set }
    func showPosterImage(path: String?)
}

final class MovieCellViewModel: MovieCellViewModelProtocol {
    var updateViewData: ViewDataHandler<UIImage>?

    private let cacheImageService = CacheImageService()
    private var networkService = NetworkService()

    init() {
        updateViewData?(.loading)
    }

    func showPosterImage(path: String?) {
        let posterURLString = Constants.getPosterURLString(path: path ?? "")

        if let image = cacheImageService.getImageFromCache(url: posterURLString) {
            updateViewData?(.data(image))
            return
        }

        guard let posterURL = URL(string: posterURLString) else {
            updateViewData?(.noData)
            return
        }

        networkService.downloadImage(url: posterURL) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(data):
                guard let data = data, let image = UIImage(data: data) else { return }
                self.cacheImageService.saveImageToCache(url: posterURLString, image: image)
                self.updateViewData?(.data(image))
            case let .failure(error):
                self.updateViewData?(.error(error))
            }
        }
    }
}
