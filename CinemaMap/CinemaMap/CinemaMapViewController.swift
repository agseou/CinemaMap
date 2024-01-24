//
//  CinemaMapViewController.swift
//  CinemaMap
//
//  Created by 은서우 on 2024/01/16.
//

import UIKit
import CoreLocation
import MapKit

class CinemaMapViewController: UIViewController {
    // MARK: - PROPERTIES
    
    @IBOutlet var mapView: MKMapView!
    let theaterList: [Theater] = TheaterList.mapAnnotations
    lazy var filterList: [Theater] = theaterList
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setMapAnotation()
        
        locationManager.delegate = self
        checkDeviceLocationAuthorization()
    }
    
    // MARK: - FUNCTIONS
    func configureView() {
        let rightButton = UIBarButtonItem(title: "filter",
                                          style: .plain,
                                          target: self,
                                          action: #selector(tapRightBtn))
        navigationItem.rightBarButtonItem = rightButton
    }
    
    func setMapAnotation() {
        for item in filterList {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: item.latitude,
                                                           longitude: item.longitude)
            annotation.title = "\(item.location)"
            mapView.addAnnotation(annotation)
        }
        setLocation(list: filterList)
    }
    
    func setLocation(list: [Theater]){
        var latitudeAVG: CLLocationDegrees = 0
        var longitudeAVG: CLLocationDegrees = 0
        var maxLatitude: CLLocationDegrees = list[0].latitude
        var minLatitude: CLLocationDegrees = list[0].latitude
        var maxLongitude: CLLocationDegrees = list[0].longitude
        var minLongitude: CLLocationDegrees = list[0].longitude
        
        for item in list {
            latitudeAVG += item.latitude
            longitudeAVG += item.longitude
            if maxLatitude < item.latitude {
                maxLatitude = item.latitude
            } else if minLatitude > item.latitude {
                minLatitude = item.latitude
            }
            if maxLongitude < item.longitude {
                maxLongitude = item.longitude
            } else if minLongitude > item.longitude {
                minLongitude = item.longitude
            }
        }
        latitudeAVG /= Double(list.count)
        longitudeAVG /= Double(list.count)
        
        let coordinate = CLLocationCoordinate2D(latitude: latitudeAVG,
                                                longitude: longitudeAVG)
        let span = MKCoordinateSpan(latitudeDelta: maxLatitude - minLatitude + 0.01,
                                    longitudeDelta: maxLongitude - minLongitude + 0.01)
        let regions = MKCoordinateRegion(center: coordinate, span: span)
        
        mapView.setRegion(regions, animated: true)
    }
    
    
    @objc
    func tapRightBtn(){
        
        showActionSheet(title: nil, message: nil) { actionSheet in
            let Btn1 = UIAlertAction(title: CinemaType.메가박스.rawValue, style: .default) { UIAlertAction in
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.filterList = self.theaterList.filter({ list in
                    return list.type == .메가박스
                })
                self.setMapAnotation()
            }
            let Btn2 = UIAlertAction(title: CinemaType.롯데시네마.rawValue, style: .default) { UIAlertAction in
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.filterList = self.theaterList.filter({ list in
                    return list.type == .롯데시네마
                })
                self.setMapAnotation()
            }
            let Btn3 = UIAlertAction(title: CinemaType.CGV.rawValue, style: .default) { UIAlertAction in
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.filterList = self.theaterList.filter({ list in
                    return list.type == .CGV
                })
                self.setMapAnotation()
            }
            let Btn4 = UIAlertAction(title: CinemaType.전체보기.rawValue, style: .default){ UIAlertAction in
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.filterList = self.theaterList
                self.setMapAnotation()
            }
            let Btn5 = UIAlertAction(title: "취소", style: .cancel)
            
            actionSheet.addAction(Btn1)
            actionSheet.addAction(Btn2)
            actionSheet.addAction(Btn3)
            actionSheet.addAction(Btn4)
            actionSheet.addAction(Btn5)
        }
    }
    
}

// MARK: - 위치 프로토콜
extension CinemaMapViewController: CLLocationManagerDelegate {
    
    // 사용자의 위치를 가져오기 -> [성공]
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        
        if let coordinate = locations.last?.coordinate {
            print(coordinate.latitude)
            print(coordinate.longitude)
            setRegionAndAnnotation(center: coordinate)
        }
        locationManager.stopUpdatingLocation()
    }
    
    func setRegionAndAnnotation(center: CLLocationCoordinate2D) {
        // 지도 중심 기반으로 보여질 범위 설정
        let region = MKCoordinateRegion(center: center, latitudinalMeters:400, longitudinalMeters: 400)
        mapView.setRegion(region, animated: true)
    }
    
    // 사용자의 위치를 가져오기 -> [실패]
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.654370, longitude: 127.049948), latitudinalMeters:400, longitudinalMeters: 400)
        mapView.setRegion(region, animated: true)
    }
    
    // 사용자 권한 상태가 바뀔 때를 알려줌
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkDeviceLocationAuthorization()
        
    }
    
}
