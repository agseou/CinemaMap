//
//  UIViewController+Extension.swift
//  CinemaMap
//
//  Created by 은서우 on 2024/01/24.
//

import UIKit
import CoreLocation

extension UIViewController {
    
    // Alert 생성 함수
    func showAlert(title: String?, message: String?, buttonTitle: String?, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: title,
                                      message:message,
                                      preferredStyle: .alert)
        
        let OK = UIAlertAction(title: buttonTitle, style: .default) { _ in
            completionHandler()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(OK)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    // ActionSheet 생성 함수
    func showActionSheet(title: String?, message: String?, completionHandler: @escaping (UIAlertController) -> Void) {
        let actionSheet = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .actionSheet)
        
        completionHandler(actionSheet)
        
        present(actionSheet, animated: true)
    }
   
        
}
