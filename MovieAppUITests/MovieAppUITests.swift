// MovieAppUITests.swift
// Copyright © RoadMap. All rights reserved.

import XCTest

/// Элементы первого экрана приложения
struct FirstScreen {
    private let app = XCUIApplication()

    private var categoriesSwitchStackView: XCUIElement {
        app.descendantElement(matching: .other, identifier: "CategoriesSwitch")
    }

    private var moviesCollectionView: XCUIElement {
        app.descendantElement(matching: .collectionView, identifier: "MoviesCollection")
    }

    var searchTextField: XCUIElement {
        app.descendantElement(matching: .textField, identifier: "SearchMovies")
    }

    var navigationBar: XCUIElement {
        app.descendantElement(matching: .navigationBar, identifier: "NavigationMoviesList")
    }

    func categoriesButton(id: String) -> XCUIElement {
        categoriesSwitchStackView.descendantElement(matching: .button, identifier: id)
    }

    func movieCell(title: String) -> XCUIElement {
        moviesCollectionView.descendantElement(matching: .cell, identifier: title)
    }
}

final class MovieAppUITests: XCTestCase {
    var application: XCUIApplication!
    let firstScreen = FirstScreen()

    override func setUpWithError() throws {
        continueAfterFailure = false
        application = XCUIApplication()
        application.launch()
    }

    override func tearDownWithError() throws {
        application = nil
    }

    func testTitleChangedValidWhenCategoriesTapped() throws {
        let categoryName = "Now Playing"

        let topRatedButton = firstScreen.categoriesButton(id: categoryName)
        XCTAssert(topRatedButton.exists)
        topRatedButton.tap()

        XCTAssert(firstScreen.navigationBar.staticTexts["\(categoryName) Movies"].exists)
    }

    func testMoviesTapedValid() {
        let title = "Веном 2"

        let movieCell = firstScreen.movieCell(title: title)
        XCTAssert(movieCell.exists)
        movieCell.tap()

        XCTAssert(XCUIApplication().staticTexts[title].exists)
    }

    func testSearchMoviesValid() {
        let searchTextField = firstScreen.searchTextField
        XCTAssert(searchTextField.exists)
        searchTextField.tap()
        searchTextField.typeText("W")
        let movieCell = firstScreen.movieCell(title: "Буш")
        XCTAssert(movieCell.exists)
    }
}
