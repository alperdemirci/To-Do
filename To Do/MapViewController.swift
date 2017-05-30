//
//  MapViewController.swift
//  To Do
//
//  Created by alper on 5/22/17.
//  Copyright © 2017 alper. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let locationManager = CLLocationManager()
        
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()  //Ask Permission from the user
//        locationManager.requestLocation() //one time location request
        
        
        
        
        
        let location = CLLocationCoordinate2DMake(48.88182, 2.43952) // Lattitude - Longitude
        
        let span = MKCoordinateSpanMake(0.02, 0.02)
        
        let region = MKCoordinateRegionMake(location, span)
        
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        //annotation.setCoordinate(location)
        annotation.coordinate = location
        
        
        annotation.title = "Pizza Pistorante"
        annotation.subtitle = "Luna Rossa"
        
        
        
        mapView.addAnnotation(annotation)
        
        //Showing the device location on the map
        self.mapView.showsUserLocation = true;
        
    }
}

//extension ViewController : CLLocationManagerDelegate {
//    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        if status == .AuthorizedWhenInUse {
//            locationManager.requestLocation()
//        }
//    }
//    
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.first {
//            print("location:: (location)")
//        }
//    }
//    
//    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
//        print("error:: (error)")
//    }
//}
