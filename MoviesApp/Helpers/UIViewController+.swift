// UIViewController+.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

// MARK: - Alert

extension UIViewController {
    func showLoadingErrorAlert(title: String, message: String, completion: @escaping () -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: GlobalConstants.isRetryMessage, style: .default, handler: { _ in
            completion()
        }))
        alert.addAction(UIAlertAction(title: GlobalConstants.cancelString, style: .cancel, handler: { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        present(alert, animated: true)
    }
}
