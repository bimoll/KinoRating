// MovieInfo.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

// MARK: - MovieInfo

/// Детальная инфоромация о фильме
struct MovieInfo: Codable {
    /// постер  фильма
    let backdropPath: String?
    /// жанры
    let genres: [Genre]?
    /// описание
    let overview: String?
    /// показатель популярности
    let popularity: Double?
    /// дата выхода
    let releaseDate: String?
    /// продолжительность
    let runtime: Int?
    /// слоган
    let tagline: String?
    /// название
    let title: String?
    /// средняя оценка
    let voteAverage: Double?
    /// количество оценок
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case genres, runtime, tagline, title, overview, popularity
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

// MARK: - Genre

/// Жанр
struct Genre: Codable {
    /// название жанра
    let name: String?
}
