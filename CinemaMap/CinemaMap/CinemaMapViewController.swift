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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightButton = UIBarButtonItem(title: "filter", style: .plain, target: self, action: #selector(tapRightBtn))
                    
        navigationItem.rightBarButtonItem = rightButton
     
        
    }
    
    @objc
    func tapRightBtn(){
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let Btn1 = UIAlertAction(title: "메가박스", style: .default) { UIAlertAction in
            self.mapAnotation(data: "메가박스")
        }
        let Btn2 = UIAlertAction(title: "롯데시네마", style: .default) { UIAlertAction in
            self.mapAnotation(data: "롯데시네마")
        }
        let Btn3 = UIAlertAction(title: "CGV", style: .default) { UIAlertAction in
            self.mapAnotation(data: "CGV")
        }
        let Btn4 = UIAlertAction(title: "전체보기", style: .default){ UIAlertAction in
            self.mapAnotation(data: "전체보기")
        }
        let Btn5 = UIAlertAction(title: "취소", style: .cancel)
        
        actionSheet.addAction(Btn1)
        actionSheet.addAction(Btn2)
        actionSheet.addAction(Btn3)
        actionSheet.addAction(Btn4)
        actionSheet.addAction(Btn5)
        
        present(actionSheet, animated: true)
    }
    
    
    func mapAnotation(data: String){
        var filterData: [Theater] = []
        
        for item in theaterList {
            if item.type.contains(data) {
                filterData.append(item)
            }
        }
        if data == "전체보기" {
            filterData = theaterList
        }
        
        for item in filterData {
            let coordinate = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
            
            let regions = MKCoordinateRegion(center: coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
            
            mapView.setRegion(regions, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(item.location)"
            mapView.addAnnotation(annotation)
        }
    }

}
