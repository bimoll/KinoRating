// MovieInfo.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import RealmSwift

// MARK: - MovieInfo

/// Детальная инфоромация о фильме
class MovieInfo: Object, Codable {
    /// постер  фильма
    @objc dynamic var backdropPath = ""
    /// жанры
    var genres = List<Genre>()
    /// описание
    @objc dynamic var overview = ""
    /// показатель популярности
    @objc dynamic var popularity = 0.0
    /// дата выхода
    @objc dynamic var releaseDate = ""
    /// продолжительность
    @objc dynamic var runtime = 0
    /// слоган
    @objc dynamic var tagline = ""
    /// название
    @objc dynamic var title = ""
    /// средняя оценка
    @objc dynamic var voteAverage = 0.0
    /// количество оценок
    @objc dynamic var voteCount = 0
    /// id фильма
    @objc dynamic var id = Int()

    enum CodingKeys: String, CodingKey {
        case genres, runtime, tagline, title, overview, popularity, id
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }

    override class func primaryKey() -> String? {
        "id"
    }
}

// MARK: - Genre

/// Жанр
class Genre: Object, Codable {
    /// название жанра
    @objc dynamic var name = ""
}
