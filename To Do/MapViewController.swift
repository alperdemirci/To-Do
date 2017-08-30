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

protocol ScreenshotProtocol {
    func screenshotImage(image: UIImage)
}

enum mapViewMode: UInt {
    case callingFromListItemViewController
    case callingFromAddNewItemViewController
}

class MapViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate {
    
    let database = FirebaseDataAdapter()
    var delegate: ScreenshotProtocol?
    
    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
    }
    
    func callingViewController(_ toNewMode: mapViewMode) {
        switch toNewMode {
        case .callingFromAddNewItemViewController:
            print("callingFromAddNewItemViewController")
        case .callingFromListItemViewController:
            print("callingFromListItemViewController")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // TODO: check the state of mapViewMode
        // TODO: make a db call to get the data if mapViewMode is in the .callingFromListItemViewController state
    }
    @IBAction func searchPressed(_ sender: UIBarButtonItem) {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        if self.mapView.annotations.count != 0 {
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            let location = CLLocationCoordinate2DMake(localSearchResponse!.boundingRegion.center.latitude, localSearchResponse!.boundingRegion.center.longitude) // Lattitude - Longitude
            
            let span = MKCoordinateSpanMake(0.01, 0.01)
            let region = MKCoordinateRegionMake(location, span)
            self.mapView.setRegion(region, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = searchBar.text
//          annotation.subtitle = ""
            self.mapView.addAnnotation(annotation)
            self.mapView.showsUserLocation = false
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    // MARK: CLLocation delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegionMake(myLocation, span)
        self.mapView.setRegion(region, animated: true)
    }
    
    //MARK: screenshot
    func screenShotMethod() {
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        guard let screenshot = UIGraphicsGetImageFromCurrentImageContext() else {
            return
        }
        UIGraphicsEndImageContext()
        //pass the image via protocol to addViewController
        delegate?.screenshotImage(image: screenshot)
    }

    override func viewWillDisappear(_ animated: Bool) {
        print("view will disappear")
        self.screenShotMethod()
        super.viewWillDisappear(true)
    }
}

