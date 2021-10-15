// MovieCellViewModel.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

protocol MovieCellViewModelProtocol {
    var updateViewData: ViewDataHandler<UIImage>? { get set }
    func showPosterImage(path: String?)
}

final class MovieCellViewModel: MovieCellViewModelProtocol {
    // MARK: - Public Properties

    var updateViewData: ViewDataHandler<UIImage>?

    // MARK: - Private Properties

    private var imageService = ImageService()

    // MARK: - Initialization

    init() {
        imageService.downloadNotify = { [weak self] in
            self?.updateViewData?(.loading)
        }
    }

    // MARK: - Public Methods

    func showPosterImage(path: String?) {
        updateViewData?(.loading)
        imageService.getImageData(path: path ?? "") { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .success(data):
                guard let imageData = data,
                      let image = UIImage(data: imageData)
                else {
                    self.updateViewData?(.noData)
                    return
                }
                self.updateViewData?(.data(image))
            case let .failure(error):
                self.updateViewData?(.error(error))
            }
        }
    }
}
