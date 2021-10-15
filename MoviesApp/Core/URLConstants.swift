// URLConstants.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Константы
struct URLConstants {
    /// Путь к популярным фильмам (без номера страницы)
    static let popularMoviesURLString =
        "https://api.themoviedb.org/3/movie/popular?api_key=ca2442da30f5d867dc86276640670af8&language=ru&page="
    /// Путь к фильмам с наивысшим рейтингом (без номера страницы)
    static let topRatedMoviesURLString =
        "https://api.themoviedb.org/3/movie/top_rated?api_key=ca2442da30f5d867dc86276640670af8&language=ru&page="
    /// Путь к фильмам в прокате (без номера страницы)
    static let nowPlayingMoviesURLString =
        "https://api.themoviedb.org/3/movie/now_playing?api_key=ca2442da30f5d867dc86276640670af8&language=ru&page="
    /// Путь к фильмам  (без номера страницы)
    static let upcomingMoviesURLString =
        "https://api.themoviedb.org/3/movie/upcoming?api_key=ca2442da30f5d867dc86276640670af8&language=ru&page="
    /// Путь к искомым фильмам
    static let searchMoviesURLString =
        "https://api.themoviedb.org/3/search/movie?api_key=ca2442da30f5d867dc86276640670af8&language=ru&page="

    /// Возвращает путь к поиску фильмов по набранному тексту с учетом номера страницы
    static func getSearchMoviesURLString(page: Int, searchedText: String) -> String {
        "\(searchMoviesURLString)\(page)&query=\(searchedText)"
    }

    /// Возвращает путь к детальной информации о фильме по ID
    static func getMovieDetailURLString(id: Int) -> String {
        "https://api.themoviedb.org/3/movie/\(id)?api_key=ca2442da30f5d867dc86276640670af8&language=ru"
    }
}
