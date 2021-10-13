// UIApplication+.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

extension UIApplication {
    var keyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }
    }
}
