//
//  CinemaMapViewController.swift
//  CinemaMap
//
//  Created by 은서우 on 2024/01/16.
//

import UIKit
import MapKit

class CinemaMapViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    let theaterList = TheaterList.mapAnnotations
    var latitudeAVG: Double = 0
    var logitudeAVG: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapAnnotation()
        CalculateLocation()
        
        let coordinate = CLLocationCoordinate2D(latitude: latitudeAVG, longitude: logitudeAVG)
        
        let regions = MKCoordinateRegion(center: coordinate, latitudinalMeters: 12000, longitudinalMeters: 12000)
        
        mapView.setRegion(regions, animated: true)
        
        let rightButton = UIBarButtonItem(title: "filter", style: .plain, target: self, action: #selector(tapRightBtn))
                    
        navigationItem.rightBarButtonItem = rightButton
        
    }
    
    func CalculateLocation(){
        
        for i in theaterList {
            latitudeAVG += i.latitude
            logitudeAVG += i.longitude
        }
        
        latitudeAVG /= Double(theaterList.count)
        logitudeAVG /= Double(theaterList.count)
    }
    
    func mapAnnotation(){
        for item in theaterList {
            let coordinate = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(item.location)"
            mapView.addAnnotation(annotation)
        }
    }
    
    
    @objc
    func tapRightBtn(){
        
        showActionSheet(title: nil, message: nil) { actionSheet in
            let Btn1 = UIAlertAction(title: "메가박스", style: .default) { UIAlertAction in
                self.mapAnotation(data: CinemaType.메가박스.rawValue)
            }
            let Btn2 = UIAlertAction(title: "롯데시네마", style: .default) { UIAlertAction in
                self.mapAnotation(data: CinemaType.롯데시네마.rawValue)
            }
            let Btn3 = UIAlertAction(title: "CGV", style: .default) { UIAlertAction in
                self.mapAnotation(data: CinemaType.CGV.rawValue)
            }
            let Btn4 = UIAlertAction(title: "전체보기", style: .default){ UIAlertAction in
                self.mapAnotation(data: CinemaType.ALL.rawValue)
            }
            let Btn5 = UIAlertAction(title: "취소", style: .cancel)
            
            actionSheet.addAction(Btn1)
            actionSheet.addAction(Btn2)
            actionSheet.addAction(Btn3)
            actionSheet.addAction(Btn4)
            actionSheet.addAction(Btn5)
        }
    }
    
    
    func mapAnotation(data: String){
        var filterData: [Theater] = []
        
        for item in theaterList {
            if item.type.rawValue == data {
                filterData.append(item)
            }
        }
        if data == CinemaType.ALL.rawValue {
            filterData = theaterList
        }
        
        latitudeAVG = 0
        logitudeAVG = 0
        for item in filterData {
            latitudeAVG += item.latitude
            logitudeAVG += item.longitude
        }
        latitudeAVG /= Double(filterData.count)
        logitudeAVG /= Double(filterData.count)
        
        let coordinate = CLLocationCoordinate2D(latitude: latitudeAVG, longitude: latitudeAVG)
            
        let regions = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
            
        mapView.setRegion(regions, animated: true)
    }

}
