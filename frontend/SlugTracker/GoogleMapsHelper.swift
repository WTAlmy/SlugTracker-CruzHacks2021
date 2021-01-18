//
//  GoogleMapsHelper.swift
//  GoogleMapsDemo
//
//  Created by Alex Nagy on 23.11.2020.
//

import UIKit
import GoogleMaps

struct GoogleMapsHelper {
    
    static let UCSC = CLLocation(latitude: 36.9881, longitude: -122.0582)
    
    static var preciseLocationZoomLevel: Float = 15.0
    static var approximateLocationZoomLevel: Float = 10.0
    
    // setup location manager
    static func initLocationManager(_ locationManager: CLLocationManager, delegate: UIViewController) {
        var locationManager =  locationManager
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = delegate as? CLLocationManagerDelegate
    }
    
    // create map
    static func createMap(on view: UIView, locationManager: CLLocationManager, mapView: GMSMapView) {
        let camera = GMSCameraPosition.camera(withLatitude: UCSC.coordinate.latitude, longitude: UCSC.coordinate.longitude, zoom: 14.0)
        var mapView = mapView
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.mapType = .satellite
        
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // edit map type if needed
       // view = mapView
        
        view.addSubview(mapView)
    }
    
    static func addMarker(_ locationManager: CLLocationManager, mapView: GMSMapView, snippet: String, title: String){
        let marker = GMSMarker()
        marker.position = locationManager.location!.coordinate
        marker.title = title
        marker.snippet = snippet
        marker.icon = GMSMarker.markerImage(with: .systemBlue)
        marker.map = mapView
    }
    
    // update current location
    static func didUpdateLocations(_ locations: [CLLocation], locationManager: CLLocationManager, mapView: GMSMapView) {
        let location: CLLocation = locations.last!
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 14.0)
        mapView.camera = camera
    }
    
    static func handle(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Check accuracy authorization
        let accuracy = manager.accuracyAuthorization
        switch accuracy {
        case .fullAccuracy:
            print("Location accuracy is precise.")
        case .reducedAccuracy:
            print("Location accuracy is not precise.")
        @unknown default:
            fatalError()
        }
        
        // Handle authorization status
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        @unknown default:
            fatalError()
        }
    }
}
