// UIViewController+.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

// MARK: - Alert

extension UIViewController {
    func showMessageAlert(title: String, message: String, completion: @escaping () -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Попробовать еще", style: .default, handler: { _ in
            completion()
        }))
        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
    }
}
