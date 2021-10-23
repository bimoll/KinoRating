// MovieAPIServiceProtocol.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

protocol MovieAPIServiceProtocol {
    func getDecodable<T: Decodable>(
        urlString: String,
        to decode: T.Type,
        completion: @escaping ResultHandler<T?>
    )
}
