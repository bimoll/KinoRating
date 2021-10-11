// MoviesList.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

// MARK: - MoviesListPage

/// Страница с фильмами
struct MoviesListPage: Codable {
    /// id страницы
    let page: Int?
    /// Фильмы с данной страницы
    let results: [Movie]?
    /// Суммарное количество всех страниц
    let totalPages: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
    }
}

// MARK: - Movie

/// Фильм
struct Movie: Codable {
    /// id жанров
    let genreIDS: [Int]?
    /// id фильма
    let id: Int?
    /// Название фильма
    let title: String?
    /// Краткое описание фильма
    let overview: String?
    /// URL изображения с постером фильма
    let posterPath: String?
    /// Дата выхода фильма
    let releaseDate: String?
    /// Оценка фильма
    let voteAverage: Double?
    /// Количество отзывов
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case overview, title, id
        case genreIDS = "genre_ids"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
