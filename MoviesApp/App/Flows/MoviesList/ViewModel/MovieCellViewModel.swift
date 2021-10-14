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
        imageService.getPhoto(path: path ?? "") { [weak self] image in
            guard let self = self,
                  let image = image
            else {
                self?.updateViewData?(.noData)
                return
            }

            self.updateViewData?(.data(image))
        }
    }
}
