// UIView+.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

extension UIView {
    func addShimmerAnimation() {
        let gradientLayer = CAGradientLayer()
        let gradientColorOne: CGColor = UIColor(white: 0.85, alpha: 1.0).cgColor
        let gradientColorTwo: CGColor = UIColor(white: 0.95, alpha: 1.0).cgColor
        gradientLayer.frame = bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = [gradientColorOne, gradientColorTwo, gradientColorOne]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.cornerRadius = 10
        layer.addSublayer(gradientLayer)

        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: animation.keyPath)
    }
}
