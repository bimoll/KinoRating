// MoviesList.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import RealmSwift

// MARK: - MoviesListPage

/// Страница с фильмами
class MoviesListPage: Object, Codable {
    /// id страницы
    @objc dynamic var page = Int()
    /// Фильмы с данной страницы
    var results = List<Movie>()
    /// Суммарное количество всех страниц
    @objc dynamic var totalPages = Int()

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
    }
}

// MARK: - Movie

/// Фильм
class Movie: Object, Codable {
    /// id жанров
    var genreIDS: List<Int>?
    /// id фильма
    @objc dynamic var id = Int()
    /// Название фильма
    @objc dynamic var title = String()
    /// Краткое описание фильма
    @objc dynamic var overview = String()
    /// URL изображения с постером фильма
    @objc dynamic var posterPath = String()
    /// Дата выхода фильма
    @objc dynamic var releaseDate = String()
    /// Оценка фильма
    @objc dynamic var voteAverage = Double()
    /// Количество отзывов
    @objc dynamic var voteCount = Int()
    /// URL страницы
    @objc dynamic var pageURL: String? = ""
    /// Ключ - URL страницы
    override class func primaryKey() -> String? {
        "pageURL"
    }

    enum CodingKeys: String, CodingKey {
        case overview, title, id
        case genreIDS = "genre_ids"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
