// ImageAPIServiceProtocol.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

protocol ImageAPIServiceProtocol {
    func loadImage(by path: String, completion: @escaping ResultHandler<Data?>)
}
