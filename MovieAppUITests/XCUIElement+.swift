// XCUIElement+.swift
// Copyright © RoadMap. All rights reserved.

import XCTest

extension XCUIElement {
    func descendantElement(
        matching elementType: XCUIElement.ElementType,
        identifier: String? = nil
    ) -> XCUIElement {
        var query = descendants(matching: elementType)
        if let identifier = identifier {
            let predicate = NSPredicate(format: "identifier == '\(identifier)'")
            query = query.matching(predicate)
        }
        return query.element
    }
}
