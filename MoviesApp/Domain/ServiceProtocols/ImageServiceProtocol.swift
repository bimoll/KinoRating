// ImageServiceProtocol.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

protocol ImageServiceProtocol {
    func getImageData(path: String, completion: @escaping ResultHandler<Data?>)
}
