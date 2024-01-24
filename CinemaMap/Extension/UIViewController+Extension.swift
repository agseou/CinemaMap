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
    
    // 기기의 위치 권한을 확인하기
    func checkDeviceLocationAuthorization() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                //현재 사용자의 위치 권한 상태 확인
                let authorization: CLAuthorizationStatus
                if #available(iOS 14.0, *) { //iOS 14 이상부터
                    authorization = CLLocationManager().authorizationStatus
                } else {
                    authorization = CLLocationManager.authorizationStatus()
                }
                DispatchQueue.main.async {
                    self.checkCurrentLocationAuthorization(status: authorization)
                }
            } else {
                print("위치 서비스가 꺼져 있어서, 위치 권한 요청을 할 수 없어요.")
            }
        }
    }
    
    // "현재" 기기의 위치 권한을 확인하기
    func checkCurrentLocationAuthorization(status: CLAuthorizationStatus) {
        let locationManager = CLLocationManager()
        
        switch status {
            // 권한 허용에 접근 안함
        case .notDetermined:
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            showAlert(title: "위치정보이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정> 개인정보보호'에서 위치서비스를 켜주세요", buttonTitle: "설정으로 이동") {
                if let setting = URL(string: UIApplication.openSettingsURLString){
                    UIApplication.shared.open(setting)
                } else {
                    print("설정으로 가주세요")
                }
            }
        case .authorizedAlways:
            print("")
        case .authorizedWhenInUse:
            print("")
        default :
            print("error")
        }
    }
       
        
}
