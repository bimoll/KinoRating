// ViewData.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Состояния вью
enum ViewData<Model> {
    case loading
    case data(_ model: Model)
    case noData
    case error(_ error: Error)
}
