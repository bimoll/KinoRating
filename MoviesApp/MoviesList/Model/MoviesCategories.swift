// MoviesCategories.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Перечисление категорий фильмов
enum MoviesCategories: String, CaseIterable {
    case popular = "Popular"
    case topRated = "Top Rated"
    case uncoming = "Uncoming"
    case nowPlaying = "Now Playing"

    func getUrlString(page: Int) -> String {
        switch self {
        case .popular:
            return "\(Constants.popularMoviesURLString)\(page)"
        case .topRated:
            return "\(Constants.topRatedMoviesURLString)\(page)"
        case .nowPlaying:
            return "\(Constants.nowPlayingMoviesURLString)\(page)"
        case .uncoming:
            return "\(Constants.upcomingMoviesURLString)\(page)"
        }
    }
}
