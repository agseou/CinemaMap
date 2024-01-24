//
//  UIViewController+Extension.swift
//  CinemaMap
//
//  Created by 은서우 on 2024/01/24.
//

import UIKit

extension UIViewController {
    func showActionSheet(title: String?, message: String?, completionHandler: @escaping (UIAlertController) -> Void) {
        let actionSheet = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .actionSheet)
        
        completionHandler(actionSheet)
        
        present(actionSheet, animated: true)
    }
}
