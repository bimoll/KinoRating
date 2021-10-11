// UILabel+.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

extension UILabel {
    func createSmallDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.textColor = UIColor(named: "CustomLightGray")
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    func createTitleLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 22)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
