// UIImage+.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

extension UIImageView {
    func createSystemIconImageView(iconName: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: iconName)?
            .withTintColor(UIColor(named: "CustomLightGray") ?? .gray, renderingMode: .automatic)
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = UIColor(named: "CustomLightGray")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}
